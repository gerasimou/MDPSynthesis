package mdpSynthesis;

import java.util.ArrayList;
import java.util.List;

import org.spg.PrismAPI.PrismAPI;

import evochecker.EvoChecker;
import evochecker.EvoCheckerMDP;
import evochecker.auxiliary.Constants;
import evochecker.auxiliary.Utility;
import evochecker.plotting.PlotFactory;
import prism.Point;
import utilities.FileUtil;

public class MainMDPSynthesis {

	public static void main(String[] args) {
		specifyCommandLine();
//		specifyInternal();
	}
	
	
	private static  void specifyInternal() {
		 //Simple Model
		 String problem = "simple";		
		 //DPM Model
		 problem = "dpm";
		 //CSMA Model
//		 problem = "csma";
//		 //WLAN Model
//		 problem = "wlan";
//		 //Zeroconf Model
//		 problem = "zeroconf";
		 //Javier's models
		 problem = "ow";
		 //Consensus
//		 problem = "consensus";
//		 //DPM
//		 problem = "dpm";
//		 //Scheduler - WORKS BUT TAKES A LONG TIME
//		 problem = "scheduler";
//		 //Team
//		 problem = "team";
		 //FX
//		 problem = "fx";
		 
		 String model = "models/" + problem +"/"+ problem +"3.pm";
		 String prop  = "models/" + problem +"/"+ problem +".pctl";
		 

		
		MDPSynthesis transformer = new MDPSynthesis(model, prop);
//		transformer.run();
		//1) Create EvoChecker instance
//		EvoChecker ec = new EvoChecker();
		
		transformer.runEvolvables();
		//1) Create EvoChecker instance
		EvoChecker ec = new EvoCheckerMDP(transformer.internalModelRepresentation, transformer.evolvables);
	
		
		String evoModel 	 = transformer.getEvoModelFile();
		String evoProperties = transformer.getEvoPropertiesFile();
		
		//2) Set configuration file
		String configFile ="config.properties"; 
		ec.setConfigurationFile(configFile);
	
		ec.setProperty(Constants.PLOT_PARETO_FRONT, "false");
		ec.setProperty(Constants.PYTHON3_DIRECTORY, "/Users/sgerasimou/anaconda3/bin/python3");
		ec.setProperty(Constants.VERBOSE, "true");
		ec.setProperty(Constants.MODEL_FILE_KEYWORD, evoModel);
		ec.setProperty(Constants.PROPERTIES_FILE_KEYWORD, evoProperties);
		ec.setProperty(Constants.PROBLEM_KEYWORD, problem);
		ec.setProperty(Constants.PROCESSORS_KEYWORD, "1");
		ec.setProperty(Constants.DOUBLE_PRECISION, "12");

		//
		ec.setProperty(Constants.POPULATION_SIZE_KEYWORD, "20");
		ec.setProperty(Constants.MAX_EVALUATIONS_KEYWORD, "200");
		ec.setProperty(Constants.INTEGER_MUTATION_PROBABILITY, "0.9");
		ec.setProperty("MUTATION_OPERATOR", "PolynomialUniformAll");
		
		run(ec, model, prop);
	}
	
	
	private static void specifyCommandLine() {
		//Set configuration file
		Utility.setPropertiesFile("config.properties");
				
		String model = Utility.getProperty(Constants.MODEL_FILE_KEYWORD);
		String prop  = Utility.getProperty(Constants.PROPERTIES_FILE_KEYWORD);
		
		MDPSynthesis transformer = new MDPSynthesis(model, prop);
		transformer.runEvolvables();

		//1) Create EvoChecker instance
		EvoChecker ec = new EvoCheckerMDP(transformer.internalModelRepresentation, transformer.evolvables);
	
		
		String evoModel 	 = transformer.getEvoModelFile();
		String evoProperties = transformer.getEvoPropertiesFile();
		
		ec.setProperty(Constants.MODEL_FILE_KEYWORD, evoModel);
		ec.setProperty(Constants.PROPERTIES_FILE_KEYWORD, evoProperties);
		ec.setProperty(Constants.PROCESSORS_KEYWORD, "1");
		ec.setProperty(Constants.DOUBLE_PRECISION, "12");
		ec.setProperty("MUTATION_OPERATOR", "PolynomialUniformAll");

		run(ec, model, prop);
	}
		
		
	private static void run(EvoChecker ec, String model, String prop) {
		//3) Start EvoChecker
		ec.start();

		//Save EvoChecker results to new file with suffix "_all"
		String paretoFrontFilename = ec.getParetoFrontFileName();
		String allResultsFilename  = paretoFrontFilename+"_all"; 

		StringBuilder sb = new StringBuilder(FileUtil.readFile(paretoFrontFilename));
		sb.append("\n");
//		FileUtil.saveToFile(allResultsFilename, FileUtil.readFile(paretoFrontFilename), false);

		//Add separator
		 sb.append("=\n");

		//Run Prism
		runPrism(model, prop, sb);

		//Add separator
		 sb.append("=\n");

		 //Run Storm
		 sb.append(RunStorm.runStorm(model, prop));
		 
		 System.out.println(sb.toString());

		 //Save all results to file
		 FileUtil.saveToFile(allResultsFilename, sb.toString(), true);
		 
		 //Plot
		 plot(allResultsFilename, ec.getObjectivesNum());
	}
	
	
	
	private static void runPrism(String model, String prop, StringBuilder sb) {
		//Run Prism
		 PrismAPI api = new PrismAPI(null);
		 api.parseModelAndPropertiesFiles(model, prop);
		 api.buildModel();
		 try {
			 List<Object> results = api.runPrism();
	
	 
			 if (results.get(0) instanceof ArrayList<?>) {
				 ArrayList<?> rl = (ArrayList<?>) results.get(0); 
				 for (Object p : rl) {
					 sb.append(((Point)p).getCoord(0) +"\t"+ ((Point)p).getCoord(1) +"\n");
	//				 System.out.println(((Point)p).getCoord(0) +"\t"+ ((Point)p).getCoord(1));
				 }
			 }
		 }
		 catch (Exception | Error e) {
			 e.printStackTrace();
		 }
	}
	
	
	private static void plot(String allResultsFilename, int objectivesNum) {
		 try {
			 if (objectivesNum == 2) {
				 PlotFactory.setParetoFrontScriptFile("scripts/plotFront2DComparison.py");
				 PlotFactory.plotParetoFront(allResultsFilename, 2);
			 }
			 else {
				 PlotFactory.setParetoFrontScriptFile("scripts/plotFront3DComparison.py");
				 PlotFactory.plotParetoFront(allResultsFilename, 3);
			 }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
