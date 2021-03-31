package mdpSynthesis;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.spg.PrismAPI.PrismAPI;
import org.spg.PrismAPI.PrismParamAPI;
import org.spg.utils.PrismAPIUtilities;

import explicit.MDPSparse;
import explicit.Model;
import parser.EvaluateContextValues;
import parser.State;
import parser.Values;
import parser.ast.Expression;
import parser.ast.ExpressionConstant;
import parser.ast.ExpressionLiteral;
import parser.ast.ModulesFile;
import parser.ast.PropertiesFile;
import parser.ast.RewardStruct;
import parser.ast.RewardStructItem;
import parser.visitor.ASTTraverse;
import prism.Prism;
import prism.PrismLangException;
import prism.PrismUtils;
import utilities.FileUtil;

public class MDPSynthesis {
	
	private String modelFName;
	private String propertiesFName;
	private String modelName;
	private String basePath;
	
	private Prism prism;

	
	private String evoTemplateFileName;
	private String evoPropertiesFileName;

	public final String STATE = "x";
	public final String EVOVAR = "o";
	private Map<Integer, Integer> optionsMap;
		
	MDPSparse mdpModel = null;
	ModulesFile modules = null;

	
	public MDPSynthesis (String modelFile, String propertiesFile) {
		this.modelFName 		= modelFile;
		this.propertiesFName	= propertiesFile;
		
		File modelF	= new File(modelFName);
		this.basePath  			= modelF.getParent(); 
		this.modelName			= modelFName.substring(modelFName.lastIndexOf("/") + 1, modelFName.lastIndexOf("."));
		
		evoTemplateFileName 	= basePath + File.separator + modelName+ "Evo.pm";
		evoPropertiesFileName 	= basePath + File.separator + modelName+ "Evo.pctl";
		
		buildModel();
		
		optionsMap = new HashMap<>();
//		labelList = new ArrayList<>();
	}
	
	/**
	 * Get the transition matrix of specified modelFile and propertiesFile
	 */
	private void buildModel() {
		try {
			PrismAPI api = new PrismAPI(basePath + File.separator + modelName +".log");
			api.parseModelAndPropertiesFiles(modelFName, propertiesFName);
			prism = api.getPrism();
			
			prism.setEngine(Prism.EXPLICIT);
			modules = prism.parseModelString(FileUtil.readFile(modelFName));
			modules.setUndefinedConstants(null);
			prism.loadPRISMModel(modules);
			prism.buildModel();
			
//			PrismParamAPI api = new PrismParamAPI(basePath + File.separator + modelName +".log");
//			String model = PrismAPIUtilities.readModelFile(modelFName);
//			api.loadParamModel(model);
//			prism = api.getPrism();
//			
//			prism.setEngine(Prism.EXPLICIT);
//			modules = api.getMofulesFile();;
//			api.setPropertiesFile(propertiesFName);
////			prism.parseModelString(FileUtil.readFile(modelFName));
////			modules.setUndefinedConstants(null);
////			prism.loadPRISMModel(modules);
//			prism.buildModel();
		}
		catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
	}
	
	public void run() {
		System.out.println("Creating EvoChecker template...");
		Model model = prism.getBuiltModelExplicit();
//		MDPSparse mdpModel = null;
		if (model instanceof MDPSparse)
			mdpModel = (MDPSparse) model;
		ModulesFile modulesFile = prism.getPRISMModel();
		
		try {
			StringBuilder sb1 = flattenMDP(mdpModel);
			StringBuilder sb2 = constructEvolveOptions();
			StringBuilder sb3 = manageRewardStructures(modulesFile, (MDPSparse)model);
			sb1.append(sb2);
			sb1.append(sb3);
			
			//Save EvoChecker template to file
			FileUtil.saveToFile(evoTemplateFileName, sb1.toString(), false);
			System.out.println("EvoChecker template created: " + evoTemplateFileName);
	
			manageProperties(mdpModel, modulesFile);
		}
		catch (PrismLangException e) {
			e.printStackTrace();
		}
		
		System.out.println("DONE");
	}
	
	
	private StringBuilder manageRewardStructures(ModulesFile modulesFile, MDPSparse model) throws PrismLangException {
		StringBuilder sb = new StringBuilder("\n\n");
		RewardStructureVisitor rewardVisitor = new RewardStructureVisitor();
		
		for (RewardStruct rStruct : modulesFile.getRewardStructs()) {
			rStruct.accept(rewardVisitor);
			sb.append(rewardVisitor.toString());
		}
		
		//append constants just in case they are used in rewards
		sb.append("\n " + modules.getConstantList().toString());
		
		return sb;
	}
	
	private StringBuilder flattenMDP(MDPSparse mdpModel) {
		StringBuilder sb = new StringBuilder("dtmc\n\n");
		
		int i, j, totalChoices, numChoices, numStates, numTransitions;
		boolean first;
//		FileWriter out;
//		TreeMap<Integer, Double> sorted;
		Object action;
		
		//Get information about the model
		totalChoices 	= mdpModel.getNumChoices();
		numStates 		= mdpModel.getNumStates();
		numTransitions	= mdpModel.getNumTransitions();
		
		//compressing model
		int minState  =numStates, maxState =0;
		int minState1 =numStates, maxState1=0;
//		minState  =192; maxState =315; minState1 =161; maxState1=191;
		
		
		sb.append("module M\n\tx : [0.." + (numStates - 1) + "];\n\n");
//		sorted = new TreeMap<Integer, Double>();
		for (i=0; i<numStates; i++) {
			numChoices = mdpModel.getNumChoices(i);
			
			//if numChoices = 1 -> there is no non-determinism
			//=> export a normal probabilistic transition
			if (numChoices == 1) {
				if ( (i<=minState || i>maxState) && (i<=minState1 || i>maxState1)) {
					action = mdpModel.getAction(i, 0);
					sb.append(action != null ? ("\t[" + action + "]") : "\t[]");
					sb.append("\tx=" + i + "->");
					first = true;
					Iterator<Map.Entry<Integer, Double>> iter = mdpModel.getTransitionsIterator(i, 0);
					while (iter.hasNext()) {
						if (first)
							first = false;
						else
							sb.append("+");
						Map.Entry<Integer, Double> e = iter.next();
						// Note use of PrismUtils.formatDouble to match PRISM-exported files
	//					sb.append(PrismUtils.formatDouble(e.getValue()) + ":(x'=" + e.getKey() + ")");
						sb.append(String.format("%.06f", e.getValue()) + ":(x'=" + e.getKey() + ")");
					}
					sb.append(";\n");
				}
			}
			else {
				optionsMap.put(i, numChoices-1);
				for (j=0; j<numChoices; j++) {
					action = mdpModel.getAction(i, j);
					sb.append(action != null ? ("\t[" + action + "]") : "\t[]");
					sb.append("\tx="+i + "&"+EVOVAR+i+"="+j + "->");
					first = true;
					Iterator<Map.Entry<Integer, Double>> iter = mdpModel.getTransitionsIterator(i, j);
					while (iter.hasNext()) {
						if (first)
							first = false;
						else
							sb.append("+");
						Map.Entry<Integer, Double> e = iter.next();
						// Note use of PrismUtils.formatDouble to match PRISM-exported files
						if (e.getKey()>minState && e.getKey()<=maxState) 
							sb.append(PrismUtils.formatDouble(e.getValue()) + ":(x'=" + (minState) + ")");
						else if (e.getKey()>minState1 && e.getKey()<=maxState1) 
							sb.append(PrismUtils.formatDouble(e.getValue()) + ":(x'=" + (minState1) + ")");
						else
							sb.append(PrismUtils.formatDouble(e.getValue()) + ":(x'=" + e.getKey() + ")");
					}
					sb.append(";\n");
				}
			}
		}
		sb.append("endmodule\n\n");
		
		return sb;
	}
	
	
	private StringBuilder constructOptions() {
		StringBuilder sb = new StringBuilder();

		for (Map.Entry<Integer, Integer> e : optionsMap.entrySet()) {
			sb.append("const int " + EVOVAR + e.getKey() +";\n");
		}
		
		sb.append("\n\n");
		return sb;
	}
	
	
	private StringBuilder constructEvolveOptions() {
		StringBuilder sb = new StringBuilder();

		for (Map.Entry<Integer, Integer> e : optionsMap.entrySet()) {
			sb.append("evolve int " + EVOVAR + e.getKey() +" [0.."+ e.getValue() +"];\n");
		}
		
		sb.append("\n\n");
		return sb;
	}
	
	
	private void manageProperties(MDPSparse mdpModel, ModulesFile modulesFile) {
		try {
			PropertiesVisitor propVisitor = new PropertiesVisitor(mdpModel, modulesFile);
			
			PropertiesFile propFile = prism.parsePropertiesFile(new File(propertiesFName));
//			propFile.getAllLabels().
			int propsNum = propFile.getNumProperties();
			for (int i=0; i<propsNum; i++) {
				parser.ast.Property p 		= propFile.getPropertyObject(i);
				Expression e	= p.getExpression();
				
				e.accept(propVisitor);
				
//				e = (Expression)o;
//				System.out.println("DONE" + e.toTreeString());
			}
			List<String> evoProperties = propVisitor.getEvoProperties();
			FileUtil.saveToFile(evoPropertiesFileName, String.join("\n\n", evoProperties), false);
			System.out.println("EvoChecker properties created: " + evoPropertiesFileName);
			
		} catch (FileNotFoundException | PrismLangException e) {
			e.printStackTrace();
		}
	}
	
	
	public String getEvoModelFile() {
		return evoTemplateFileName;
	}
	
	public String getEvoPropertiesFile() {
		return evoPropertiesFileName;
	}
	
	
	public class RewardStructureVisitor extends ASTTraverse{
		StringBuilder sb = new StringBuilder();
		RewardVisitor rVisitor = new RewardVisitor();
		
		@Override
		public void visitPre(RewardStruct e) throws PrismLangException{
			sb.setLength(0);
			sb.append("rewards");
			if (e.getName() != null && e.getName().length() > 0) 
				sb.append(" \""+e.getName()+"\"");
			sb.append(" \n");
		}
		
		@Override
		public void visitPost(RewardStruct e) throws PrismLangException{
			sb.append("\nendrewards\n\n");			
		}

		@Override
		public void visitPost(RewardStructItem e) throws PrismLangException{
			if (e.getSynch() != null) 
				sb.append("\t[" + e.getSynch() + "] ");
			else
				sb.append("\t");
			
//			sb.append(e.getStates());
			sb.append(evaluate(e.getStates()));
			
//			e.getReward().accept(rVisitor);
			
			sb.append(" : " + e.getReward() + ";\n");
		}
		
		private String evaluate (Expression e) throws PrismLangException {
			if (e instanceof ExpressionLiteral &&  
					((ExpressionLiteral)e).getValue().toString().equals("true"))
				return "true";
			
			List<Integer> validStates = new ArrayList<Integer>();
			List<State> statesList = mdpModel.getStatesList();
			int numStates = statesList.size();
			
			Values constantValues = mdpModel.getConstantValues();
			
			for (int i = 0; i < numStates; i++) {
				boolean b = e.evaluateBoolean (constantValues, statesList.get(i));
				if (b)
					validStates.add(i);
			}
			StringBuilder sb = new StringBuilder();
			Iterator<Integer> it = validStates.iterator();
			while (it.hasNext()) {
				sb.append("x="+it.next());
				if (it.hasNext())
					sb.append("|");
			}
			return sb.length() > 0 ? sb.toString() : "false";
		}
		
		public String toString() {
			return sb.toString();
		}
	
		
		class RewardVisitor extends ASTTraverse{
			@Override
			public void visitPre(ExpressionConstant e) throws PrismLangException{
				Object o = e.evaluate(new EvaluateContextValues(modules.getConstantValues(), null));
				System.out.println(o);
			}
		}
		
	}

}
