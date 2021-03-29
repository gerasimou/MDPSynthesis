package mdpSynthesis;

import java.util.ArrayList;
import java.util.List;

import org.spg.PrismAPI.PrismAPI;

import evochecker.EvoChecker;
import evochecker.auxiliary.Constants;
import evochecker.plotting.PlotFactory;
import prism.Point;
import utilities.FileUtil;

public class MainMDPSynthesis {
	public static void main(String[] args) {

		 //Simple Model
		 String problem = "simple";		
		 //DPM Model
		 problem = "dpm";
		 //CSMA Model
		 problem = "csma";
//		 //WLAN Model
		 problem = "wlan";
//		 //Zeroconf Model
		 problem = "zeroconf";
		 //Javier's models
		 problem = "ow";
		 //Consensus
//		 problem = "consensus";
//		 //DPM
//		 problem = "dpm";
//		 //Scheduler
//		 problem = "scheduler";
//		 //Team
//		 problem = "team";
		 //FX
//		 problem = "fx";
		 
		 String model = "inputs/" + problem +"/"+ problem +"3.pm";
		 String prop  = "inputs/" + problem +"/"+ problem +".pctl";
		 

		
		MDPSynthesis transformer = new MDPSynthesis(model, prop);
		transformer.run();
		
		String evoModel 	 = transformer.getEvoModelFile();
		String evoProperties = transformer.getEvoPropertiesFile();
				
		
		//1) Create EvoChecker instance
		EvoChecker ec = new EvoChecker();
		
		//2) Set configuration file
		String configFile ="config.properties"; 
		ec.setConfigurationFile(configFile);
	
		ec.setProperty(Constants.PLOT_PARETO_FRONT, "false");
		ec.setProperty(Constants.PYTHON3_DIRECTORY, "/Users/sgerasimou/anaconda3/bin/python3");
		ec.setProperty(Constants.VERBOSE, "true");
		ec.setProperty(Constants.POPULATION_SIZE_KEYWORD, "40");
		ec.setProperty(Constants.MAX_EVALUATIONS_KEYWORD, "200");
		ec.setProperty(Constants.MODEL_FILE_KEYWORD, evoModel);
		ec.setProperty(Constants.PROPERTIES_FILE_KEYWORD, evoProperties);
		ec.setProperty(Constants.PROBLEM_KEYWORD, problem);
		ec.setProperty(Constants.PROCESSORS_KEYWORD, "1");

		
		//3) Start EvoChecker
		ec.start();

		//Save EvoChecker results to new file with suffix "_all"
		String paretoFrontFilename = ec.getParetoFrontFileName();
		String allResultsFilename  = paretoFrontFilename+"_all"; 
		FileUtil.saveToFile(allResultsFilename, FileUtil.readFile(paretoFrontFilename), false);
		
		//Add separator
		StringBuilder sb = new StringBuilder("=\n");
		 
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
		 catch (Exception e) {
			 e.printStackTrace();
		 }
		 
		 
		 //Run Storm
		 sb.append("=\n");
		 sb.append(RunStorm.runStorm(model, prop));
		 
		 System.out.println(sb.toString());

		 //Save Prism results to file
		 FileUtil.saveToFile(allResultsFilename, sb.toString(), true);
		 
		 //Plot
		 try {
			 if (ec.getObjectivesNum() == 2) {
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
		 

		 
//		 String[] cmd = new String[]{model,  prop};
//		 PrismCL.main(cmd);
//		 new PrismCL().go(cmd);
//		 System.exit(0);

	}

}