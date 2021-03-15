package mdp2dtmc;

import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.spg.PrismAPI.PrismParamAPI;
import org.spg.utils.PrismAPIUtilities;

import property.Label;
import property.Objective;
import property.Property;
import property.parser.PCTLParser;

public class Main2 {

	public static void main(String[] args) {

		// Set files
		// String modelFile = "inputs/zeroconf/zeroconf.nm";
		// String propsFile = "inputs/zeroconf/zeroconf.pctl";
		String modelFile = "inputs/cobot/cobot.pm";
		String propsFile = "inputs/cobot/cobot.pctl";
		try {
			// new Main2().run1(modelFile,propsFile);
			// new Main2().run2(modelFile, propsFile);
			new Main2().run1(modelFile, propsFile);
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
		System.exit(0);
	}

	public void run1(String modelFile, String propsFile) throws Exception {
		System.out.println("Evaluating the extraction of states based on an expression in the PCTL property");

		// Init PrismAPI
		// Param could be the filename of the output (from Prism)
		PrismParamAPI api = new PrismParamAPI();

		// Read and load model
		String model = PrismAPIUtilities.readModelFile(modelFile);
		api.loadParamModel(model);

		// Set properties file
		api.setPropertiesFile(propsFile);

		List<String> varsToSearch = new ArrayList<String>();
		List<String> statesList;
		String condition;

		// Example 1) Find states satisfying a simple condition:
		// state=WF_SUCC, where WF_SUCC=10 ==>state=10
		// output: [15]
		// varsToSearch.clear();
		// varsToSearch.add("state");
		// condition = "state = 10";
		// statesList = api.findStatesSatisfyingExpression(condition, varsToSearch);
		// System.out.println("States satisfying " + condition + ":\t" +
		// Arrays.toString(statesList.toArray()));

		// Example 1) Find states satisfying a complex condition
		// s62 > 2 & state > 6
		// output: [16, 17, 18, 19, 20, 21, 22, 23]
		varsToSearch.clear();

		// l=3 & mess=0 & y=2 & probes=1 & ip=1;
		// l=4 & ip=1
		varsToSearch.add("l");
		varsToSearch.add("mess");
		varsToSearch.add("y");
		varsToSearch.add("probes");
		varsToSearch.add("ip");
		varsToSearch.add("ip");
		
		// condition = "(l=4 & ip=1)";
		condition = "l=3 & mess=0 & y=2 & probes=1 & ip=1";
		// condition = "l=4 & ip=1";
		statesList = api.findStatesSatisfyingExpression(condition, varsToSearch);
		System.out.println("States satisfying " + condition + ":\t" + Arrays.toString(statesList.toArray()));

		// Close down all API connections
		api.closeDown();
		System.exit(0);
	}

	public void run2(String modelFile, String propsFile) throws Exception {

		// Init PrismAPI
		// Param could be the filename of the output (from Prism)
		PrismParamAPI api = new PrismParamAPI();
		// Read and load model
		String model = PrismAPIUtilities.readModelFile(modelFile);
		api.loadParamModel(model);

		// Set properties file
		api.setPropertiesFile(propsFile);

		// Get states info
		String s = api.getModelStatesInfo();

		List<Label> l = new ArrayList<Label>();
		PCTLParser parser = new PCTLParser(l);

		parser.readFileForLabels(modelFile);

		// Close down all API connections
		api.closeDown();
		System.exit(-1);
	}

	public void run3(String modelFile, String propsFile) throws Exception {

		// Init PrismAPI
		// Param could be the filename of the output (from Prism)
		PrismParamAPI api = new PrismParamAPI();
		// Read and load model
		String model = PrismAPIUtilities.readModelFile(modelFile);
		api.loadParamModel(model);

		// Set properties file
		api.setPropertiesFile(propsFile);

		// Get states info
		// String s = api.getModelStatesInfo();

		List<Label> l = new ArrayList<Label>();
		PCTLParser parser = new PCTLParser(l);

		parser.readFileForLabels(modelFile);

		parser.readFileForLabels(propsFile);

		parser.parse(propsFile);

		StringBuilder sb = new StringBuilder();

		for (Property p : parser.getListProperties()) {
			// 1. read raw expression
			String expr = p.getActualExpression();
			System.out.println("expr: " + expr);
			// 2. obtain all variables names
			List<String> vars = getArgumentsNames(expr);
			// 3. use PrismAPI to get the satisfying states
			String condition = p.getActualExpression();
			List<String> statesList = api.findStatesSatisfyingExpression(condition, vars);
			// 4. replace the expression of property with all states
			// 4.1 first, append the string "u=" prior to state number

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

		String ext = propsFile.substring(propsFile.lastIndexOf("."), propsFile.length());
		String propsFileNew = propsFile + "_new_states" + ext;
		FileWriter fw = new FileWriter(propsFileNew);
		fw.write(sb + "\n");
		fw.close();
		// Close down all API connections
		api.closeDown();

		System.exit(-1);
	}

	private List<Integer> getAllSatisfyingStatesByProperty(String expression) {

		// read all properties and replace expression with
		// satisfing states

		return null;
	}

	private List<String> getArgumentsNames(String expression) {
		// System.out.println("Expression: " + expression);
		expression = expression.replaceAll("[(|)]", "");
		String exp[] = expression.split("(&|\\|)");
		List<String> vars = new ArrayList<String>();
		Pattern pattern = Pattern.compile("[a-zA-Z_$][a-zA-Z_$0-9]*(<|<=|>|>=|=)");
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
			s = s.replace("=", "");
			exp[i] = s;
		}
		return Arrays.asList(exp);
	}
}
