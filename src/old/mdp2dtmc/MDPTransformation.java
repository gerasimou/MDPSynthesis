package old.mdp2dtmc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.spg.PrismAPI.PrismAPI;
import org.spg.PrismAPI.PrismParamAPI;
import org.spg.utils.PrismAPIUtilities;

import old.property.Label;
import old.property.Objective;
import old.property.Property;
import old.property.parser.PCTLParser;
import utilities.FileUtil;

public class MDPTransformation {
	
	private String modelFName;
	private String propertiesFName;
	private String modelName;
	private String transitionMatrixFile;
	private String basePath;
	
	private String evoTemplateFileName;
	private String evoPropertiesFileName;
	
	private Map<String, List<RewardItem>> rewardStrcutures = new HashMap<String, List<RewardItem>>();
	private Map<String, Integer> evolveMax = null;
	private List<RewardItem> badItems = new ArrayList<RewardItem>();
	
	public final String STATE = "u";
	public final String EVOVAR = "o";
	private int maxState = 0;

	private List<Label> labelList;

	
	
	public MDPTransformation (String modelFile, String propertiesFile) {
		this.modelFName 		= modelFile;
		this.propertiesFName	= propertiesFile;
		
		File modelF	= new File(modelFName);
		this.basePath  = modelF.getParent(); 
		this.modelName		= modelFName.substring(modelFName.lastIndexOf("/") + 1, modelFName.lastIndexOf("."));
		transitionMatrixFile = basePath + File.separator + modelName +".tra";
		
		getTransitionMatrix();
		
		labelList = new ArrayList<>();
	}
	
	
	/**
	 * Get the transition matrix of specified modelFile and propertiesFile
	 */
	private void getTransitionMatrix() {
		try {
			PrismAPI api = new PrismAPI(basePath + File.separator + modelName +".log");
			api.parseModelAndPropertiesFiles(modelFName, propertiesFName);
			api.buildModel();
			api.getTransitionMatrix(transitionMatrixFile);
			api.closeDown();
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
	}
	
	
	public void run() {
		System.out.println("Creating EvoChecker template...");
		
		try {
			Map<List<String>, String> options = new LinkedHashMap<List<String>, String>();
			buildRewardStructureAndStates();
			prepareMap(options);
			String evoContent = getEvoCheckerContent(options);
			
			//Save EvoChecker template to file
			evoTemplateFileName = basePath + File.separator + modelName+ "Evo.pm";
			FileUtil.saveToFile(evoTemplateFileName, evoContent, false);
//			toEvoCheckerTemplate(evoContent);
			System.out.println("EvoChecker template created: " + evoTemplateFileName);
			
			transformProperties(modelFName, propertiesFName);
			if (badItems.size() > 0)
				System.out.println("Number of bad items: " + badItems.size());
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	
	private void buildRewardStructureAndStates() throws Exception {
		// 1. Read all reward items in the original model and
		// generate necessary structure
		BufferedReader br = new BufferedReader(new FileReader(modelFName));
		String line;
		while ((line = br.readLine()) != null) {
			if (line.startsWith("//"))
				continue;

			//handle labels
			if (line.startsWith("label ")) {
				handleLabel(line);
			}
			//handle rewards
			else {
				String ss[] = line.split(" ");
				if (ss != null && ss.length >= 1 && ss[0].equals("rewards")) {
					// reward_content.append(String.format("rewards \"%s\"\n", str));
					String reward_name = "all";
					if (ss.length >= 2 && ss[1] != null) {
						reward_name = ss[1].replaceAll("^\"|\"$", "");
					}
					// read all reward items in this reward structure
					List<RewardItem> items = new ArrayList<RewardItem>();
					String inline = br.readLine();
					while (!inline.equals("endrewards")) {
						if ((!(inline.startsWith("//") || inline.startsWith("\t//"))) && inline.contains("[")
								&& inline.contains("]")) {
							// build a reward item
							String label = inline.substring(inline.indexOf("[") + 1, inline.indexOf("]"));
							String guard = inline.substring(inline.indexOf("]") + 1, inline.indexOf(":"));
							String reward = inline.substring(inline.indexOf(":") + 1, inline.indexOf(";"));
							RewardItem i = new RewardItem(label.trim(), guard.trim(), reward.trim(), reward_name);
							items.add(i);
						}
						inline = br.readLine();
					}
					// add all items to a reward structure
					rewardStrcutures.put(reward_name, items);
				}
			}
			
		}
		br.close();

		// 2. read the generate new model file with dummay parametic var and
		// evaluate all reward items and obtain their satisfying states
		PrismParamAPI api = new PrismParamAPI();
		String model = PrismAPIUtilities.readModelFile(modelFName);
		model += "const double pointless;\n";
		api.loadParamModel(model);
		api.setPropertiesFile(propertiesFName);

		Iterator<List<RewardItem>> itemsIterator = rewardStrcutures.values().iterator();

		while (itemsIterator.hasNext()) {
			List<RewardItem> itemList = itemsIterator.next();
			for (RewardItem i : itemList) {
				if (i.isGuardAlwaysTrue()) {
					continue;
				}
				List<String> vars = getArgumentsNames(i.getGuard());
				String condition = i.getGuard();
				// System.out.printf("{%s}, {%s}\n", Arrays.asList(vars.toArray()), condition);
				List<String> statesList = api.findStatesSatisfyingExpression(condition, vars);
				// System.out.printf("States: %s\n", Arrays.asList(statesList.toArray()));
				if (statesList.size() <= 0) {
					badItems.add(i);
					continue;
				}
				for (String s : statesList) {
					i.getStates().add(Integer.parseInt(s));
				}
			}
		}
		api.closeDown();
	}
	
	
	private void handleLabel(String line) {
		// read chars after label to first equal sign for label
		String str = line.replace("label \"", "");
		String key = str.substring(0, str.lastIndexOf("\""));
		str = line.substring(0, line.indexOf("=") + 1);
		str = line.replace(str, "");
		str = str.substring(0, str.length() - 1);
		Label l = new Label(key, str, true);
		labelList.add(l);
	}
	
	
	private List<String> getArgumentsNames(String expression) {
		String strExp = expression;
		// System.out.println("Expression: " + expression);
		strExp = strExp.replaceAll("[()]", "");
		strExp = strExp.replaceAll("  ", "");
		String exp[] = strExp.split("(&|\\|)");
		Pattern pattern = Pattern.compile("[a-zA-Z_$][a-zA-Z_$0-9]*(<|<=|>|>=|!=|=)");
		for (int i = 0; i < exp.length; i++) {
			String s = exp[i];
			Matcher m = pattern.matcher(s);
			while (m.find()) {
				s = m.group();
			}
			s = s.replaceAll(" ", "");
			s = s.replace("<", "");
			s = s.replace("<=", "");
			s = s.replace(">", "");
			s = s.replace(">=", "");
			s = s.replace("!=", "");
			s = s.replace("=", "");
			exp[i] = s;
		}
		List<String> arguments = new ArrayList<String>();
		for (String s : exp) {
			if (!arguments.contains(s))
				arguments.add(s);
		}
		return arguments;
	}
	
	
	public void prepareMap(Map<List<String>, String> options) throws Exception {	
		String transitionMatrix = FileUtil.readFile(transitionMatrixFile);
		Scanner scan = new Scanner(transitionMatrix);
		boolean summaryLine = true;
		/// int inner;
		List<String> visited = new ArrayList<String>();
		int outer = 0, inner = 0;
		List<String> lastKey = null;
		String lastOption = null, line;
		evolveMax = new LinkedHashMap<String, Integer>();
		while (scan.hasNext()) {
			line = scan.nextLine();
			if (summaryLine) {
				summaryLine = false;
				continue;
			}
			String arg[] = line.split(" ");
			// 0 0 1 0.9 d OR 1 0 1 1
			List<String> key = new ArrayList<String>();
			key.add(arg[0]);
			key.add(arg[1]);
			String v = options.get(key);
			if (v == null) {
				// before anything, if there is open key
				// terminate it
				if (lastKey != null) {
					// check if the last entry is a single transition
					// whether with a label or not
					String lastValue = options.get(lastKey);
					String transitions[] = lastValue.split(":");
					if (transitions.length <= 2 && !lastKey.get(0).equals(arg[0]) && !visited.contains(arg[0])) {
						// remove the option guard condition
						String operands[] = lastOption.split("=");
						if (Integer.parseInt(operands[1]) <= 0) {
							lastValue = lastValue.replace(lastOption, "");
							inner--;
						}
					}
					// finally, terminate the entry with semi-colin and update
					// the value
					options.put(lastKey, lastValue + ";");
					// save current evovable and max of inner count for later use
					// in template printing
					evolveMax.put((EVOVAR + outer), inner);
				}
				if (!visited.contains(arg[0])) {
					visited.add(arg[0]);
					outer++;
					inner = 0;
				} else {
					inner++;
				}
				// create first new option
				// if (args.length >= 5) {
				// with label
				StringBuilder sb = new StringBuilder();

				sb.append(String.format("%s=%s", STATE, arg[0]));
				lastOption = String.format("&%s=%d", "" + (EVOVAR + outer), inner);
				sb.append(lastOption);
				int target = Integer.parseInt(arg[2]);
				if (target > maxState)
					maxState = target;
				sb.append(String.format("->%s:(%s'=%d)", arg[3], STATE, target));

				String label = "[] ";
				if (arg.length >= 5 && arg[4] != null) {
					// TODO: should be made as list of items and not single one
					List<RewardItem> others = new ArrayList<RewardItem>();
					List<RewardItem> items = rewardStates(arg[4], others);
					boolean labelDone = false;
					// 1.check first with all rewards that has same label
					if (items != null) {
						for (RewardItem i : items) {
							boolean toNext = false;
							if (i.getStates().size() >= 1 && i.getStates().get(0) <= Integer.parseInt(arg[0])) {
								if (!i.getStates().contains(Integer.parseInt(arg[0]))) {
									toNext = true;
								}
							} else {
								toNext = true;
							}
							if (toNext)
								continue;
							i.setPartOfTransformationModel(true);
							labelDone = true;
							label = String.format("[%s] ", i.getLabel());
						}
						for (RewardItem i : items) {
							if (i.isGuardAlwaysTrue()) {
								i.setPartOfTransformationModel(true);
								labelDone = true;
								label = String.format("[%s] ", i.getLabel());
							}
						}
					}
					// 2. now, check with all reminding rewards and create a new reward entry
					if (others != null) {
						for (RewardItem i : others) {
							if (i.getStates().size() >= 1 && i.getStates().get(0) <= Integer.parseInt(arg[0])) {
								if (i.getStates().contains(Integer.parseInt(arg[0]))) {
									// generate a new reward and add it to this reward structure
									if (labelDone) {
										String rs_name = i.getContainer();
										// 1. get all RewardItems that are auto-generated if any in this structure
										List<RewardItem> oldList = rewardStrcutures.get(rs_name);
										RewardItem targetItem = null;
										for (RewardItem item : oldList) {
											if (item.isAutoGenerated() && item.getLabel().equals(arg[4])) {
												targetItem = item;
												break;
											}
										}
										// 2. amend the states list and add this current state or create new one
										if (targetItem == null) {
											RewardItem gen = new RewardItem(arg[4], "auto-gen", i.getReward(), rs_name);
											gen.setPartOfTransformationModel(true);
											gen.getStates().add(Integer.parseInt(arg[0]));
											gen.setAutoGenerated(true);
											oldList.add(gen);
											rewardStrcutures.put(rs_name, oldList);
										} else {
											targetItem.getStates().add(Integer.parseInt(arg[0]));
										}
									} else {
										label = String.format("[%s] ", i.getLabel());
									}
								}
							}
						}
					}
				}
				v = label + sb.toString();
			} else {
				// already exist option, so just append to the value
				StringBuilder sb = new StringBuilder();
				sb.append(String.format("+%s:", arg[3]));
				int target = Integer.parseInt(arg[2]);
				if (target > maxState)
					maxState = target;
				sb.append(String.format("(%s\'=%d)", STATE, target));
				v = v + sb.toString();
			}
			options.put(key, v);
			lastKey = key;
		}
		// check last entry
		if (lastKey != null) {
			// check if the last entry is a single transition
			// whether with a label or not
			String lastValue = options.get(lastKey);
			String transitions[] = lastValue.split(":");
			if (transitions.length <= 2 && !visited.contains(lastKey.get(0))) {
				// remove the option guard condition
				lastValue = lastValue.replace(lastOption, "");
			}
			// else
			evolveMax.put((EVOVAR + outer), inner);
			// finally, terminate the entry with semicolon and update
			// the value
			options.put(lastKey, lastValue + ";");
		}
	}

	public String getEvoCheckerContent(Map<List<String>, String> options) {

		StringBuilder sb = new StringBuilder();

		sb.append("dtmc\n\n");

		for (Map.Entry<String, Integer> e : evolveMax.entrySet()) {
			if (e.getValue() >= 1) {
				sb.append("evolve int " + e.getKey() + " [0.." + e.getValue() + "];\n");
			} else if (e.getValue() == 0) {
				// need to sort those options with only one choice
				String remove = "&" + e.getKey() + "=" + e.getValue();
				for (Map.Entry<List<String>, String> e2 : options.entrySet()) {
					if (e2.getValue().contains(remove)) {
						String newValue = e2.getValue().replace(remove, "");
						e2.setValue(newValue);
					}
				}
			} else {
				// value = -1, so just ignore
			}
		}

		// there is always a single output module
		sb.append("\nmodule M\n");
		sb.append("\t" + STATE + ":[0.." + maxState + "] init 0;\n");
		for (Map.Entry<List<String>, String> e : options.entrySet()) {
			sb.append("\n\t" + e.getValue());
		}
		sb.append("\nendmodule\n\n");

		// add rewards
		sb.append("\n//reward structures\n");
		for (Map.Entry<String, List<RewardItem>> rs : rewardStrcutures.entrySet()) {
			String rs_name = rs.getKey();
			if (rs_name.equals("all"))
				rs_name = "";
			else
				rs_name = "\"" + rs_name + "\"";
			sb.append("rewards " + rs_name + "\n");
			int count = 0;
			for (RewardItem ri : rs.getValue()) {
				List<Integer> items = new ArrayList<Integer>();
				if (ri.isPartOfTransformationModel()) {
					count++;
					int i = 0;
					if (ri.isGuardAlwaysTrue()) {
						String l = ri.getLabel();
						String c = "true";
						sb.append(String.format("\t[%s] %s : %s;\n", l != null ? l : "", c, ri.getReward()));
					} else {
						String l = ri.getLabel();
						String c;
						for (; i < ri.getStates().size(); i++) {
							// String c = ri.isGuardAlwaysTrue() ? "true" : encodeStatesToString(ri);
							if (i > 0 && i % 500 == 0) {
								// split here
								c = encodeStatesToString(items);
								sb.append(String.format("\t[%s] %s : %s;\n", l != null ? l : "", c, ri.getReward()));
								items.clear();
							} else if (i + 1 < ri.getStates().size()) // last state
								items.add(ri.getStates().get(i));
							else {
								c = encodeStatesToString(items);
								sb.append(String.format("\t[%s] %s : %s;\n", l != null ? l : "", c, ri.getReward()));
							}
						}
					}
				} else {
					sb.append(String.format("\t//[%s] %s : %s; NOT PART OF TRANSFORMATION\n", ri.getLabel(),
							ri.getGuard(), ri.getReward()));
				}
			}
			if (count == 0)
				sb.append("// no rewards are called in this reward structure\n");
			sb.append("endrewards\n\n");
		}
		return sb.toString();
	}

	public String getEvoModelFile() {
		return evoTemplateFileName;
	}
	
	public String getEvoPropertiesFile() {
		return evoPropertiesFileName;
	}

	private Map<String, List<RewardItem>> cachedItems = new HashMap<String, List<RewardItem>>();
	private Map<String, List<RewardItem>> cachedOthers = new HashMap<String, List<RewardItem>>();

	/**
	 * This method returns a list of items that have the label as reward label. For
	 * performance, this function also caches returned items
	 * 
	 * @param label
	 * @param others
	 * @return
	 * @throws Exception
	 */
	private List<RewardItem> rewardStates(String label, List<RewardItem> others) throws Exception {
		List<RewardItem> returned = null;
		if (cachedItems.keySet().contains(label)) {
			if (cachedOthers.get(label) != null)
				others.addAll(cachedOthers.get(label));
			returned = cachedItems.get(label);
		}

		if (returned != null)
			return returned;

		Iterator<List<RewardItem>> itemsIterator = rewardStrcutures.values().iterator();
		List<RewardItem> list = new ArrayList<RewardItem>();
		while (itemsIterator.hasNext()) {
			List<RewardItem> itemList = itemsIterator.next();
			for (RewardItem i : itemList) {
				if (i.getLabel().equals(label))
					list.add(i);
				else
					others.add(i);
			}
		}
		if (list.size() >= 1) {
			returned = list;
			cachedItems.put(label, list);
		} else
			cachedItems.put(label, null);

		if (others.size() >= 1)
			cachedOthers.put(label, others);
		else {
			others = null;
			cachedOthers.put(label, null);
		}
		return returned;
	}

	
	public void transformProperties(String mFile, String pFile) throws Exception {

		// Init PrismAPI
		// Param could be the filename of the output (from Prism)
		PrismParamAPI api = new PrismParamAPI();

		String model = PrismAPIUtilities.readModelFile(mFile);
		model += "\nconst double pointless;\n\n";
		api.loadParamModel(model);

		// Set properties file
		api.setPropertiesFile(pFile);

		// Get states info
		// String s = api.getModelStatesInfo();

		PCTLParser parser = new PCTLParser(labelList);

//		parser.readFileForLabels(mFile);

		parser.readFileForLabels(pFile);
//		handleLabel(pFile);

		parser.parse(pFile);

		StringBuilder sb = new StringBuilder();

		for (Property p : parser.getListProperties()) {
			// 1. read raw expression
			String expr = p.getActualExpression();
			// System.out.println("expr: " + expr);
			// 2. obtain all variables names
			if (expr == null)
				continue;
			List<String> vars = getArgumentsNames(expr);
			// 3. use PrismAPI to get the satisfying states
			String condition = p.getActualExpression();
			List<String> statesList = api.findStatesSatisfyingExpression(condition, vars);
			// 4. replace the expression of property with all states
			// 4.1 first, append the string "u=" prior to state number
			// System.out.println("Property: " + p.getRawExpression() + "\n\t----> Number
			// states: " + statesList.size());

			if (statesList.size() <= 0)
				continue;

			int i = 0;

			Set<String> states = new HashSet<String>();
			String exp = "";
			for (; i < statesList.size() - 1; i++) {
				String ss = statesList.get(i);
				if (!states.contains(ss)) {
					ss = "u=" + ss + "|";
					exp = exp + ss;
					states.add(ss);
				}
			}
			String ss = statesList.get(i);
			if (!states.contains(ss)) {
				ss = "u=" + ss;
				exp = exp + ss;
			}

			String newRaw = p.getRawExpression();
			newRaw = newRaw.replace(p.getActualExpression(), "(" + exp + ")");
			String propertystr = null;
			if (p instanceof Objective) {
				propertystr = "//Objective";
				if (p.isMaximization())
					propertystr = propertystr + ", max";
				else
					propertystr = propertystr + ", min";
			} else {
				propertystr = "//Constraint";
				if (p.isMaximization())
					propertystr = propertystr + ", max";
				else
					propertystr = propertystr + ", min";
			}
			sb.append(propertystr + "\n");
			sb.append(newRaw + "\n");
		}

		// write string build to a new property file
		String ext = pFile.substring(pFile.lastIndexOf("."), pFile.length());
		evoPropertiesFileName = basePath + File.separator + modelName+ "Evo"+ ext;
		FileUtil.saveToFile(evoPropertiesFileName, sb + "\n\n", false);
		System.out.println("EvoChecker properties created: " + evoPropertiesFileName);
		 
		// Close down all API connections
		api.closeDown();
	}
	
	private String encodeStatesToString(List<Integer> states) {
		// replace the condition with states
		int s;
		String str = "";
		for (s = 0; s < states.size() - 1; s++) {
			str += " u=" + states.get(s) + " |";
		}
		str += " u=" + states.get(s);
		return str;
	}
}
