package mdp2dtmc;

import org.spg.PrismAPI.PrismAPI;

public class MainMDPSynthesis {
	public static void main(String[] args) {

		 //Simple Model
		 String model = "inputs/simple/simple.nm";
		 String prop  = "inputs/simple/simple.pctl";
		 //DPM Model
		 model = "inputs/dpm/dpm.pm";
		 prop  = "inputs/dpm/dpm.pctl";
		 //CSMA Model
//		 model = "inputs/csma/csma.nm";
//		 prop  = "inputs/csma/csma.pctl";
//		 //WLAN Model
		 model = "inputs/wlan/wlan.nm";
		 prop  = "inputs/wlan/wlan.pctl";
//		 //Zeroconf Model
//		 model = "inputs/zeroconf/zeroconf.nm";
//		 prop  = "inputs/zeroconf/zeroconf.pctl";
		
//		MDPSynthesis transformer = new MDPSynthesis(model, prop);
//		transformer.run();
		
//		String evoModel 	 = transformer.getEvoModelFile();
//		String evoProperties = transformer.getEvoPropertiesFile();
//		String evoModel 	 = "inputs/csma/csmaEvo.pm";//transformer.getEvoModelFile();
//		String evoProperties = "inputs/csma/csmaEvo.pctl";//transformer.getEvoPropertiesFile();
				
		
//		//1) Create EvoChecker instance
//		EvoChecker ec = new EvoChecker();
//		
//		//2) Set configuration file
//		String configFile ="config.properties"; 
//		ec.setConfigurationFile(configFile);
//	
//		ec.setProperty("PLOT_PARETO_FRONT", "true");
//		ec.setProperty("VERBOSE", "true");
//		ec.setProperty("MAX_EVALUATIONS", "100");
//		ec.setProperty("MODEL_TEMPLATE_FILE", evoModel);
//		ec.setProperty("PROPERTIES_FILE", evoProperties);
//	
//		//3) Start EvoChecker
//		ec.start();
//				
		 
		 
		 PrismAPI api = new PrismAPI();
		 api.parseModelAndPropertiesFiles(model, prop);
		 api.buildModelExplicit();
		 api.runPrism();	
		 
		System.exit(0);

	}

}
