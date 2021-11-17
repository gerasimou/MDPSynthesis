package mdpSynthesis;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import evochecker.EvoChecker;
import evochecker.EvoCheckerMDP;
import evochecker.auxiliary.Constants;
import evochecker.auxiliary.FileUtil;
import evochecker.auxiliary.Utility;
import evochecker.genetic.jmetal.experiments.Experiment;
import evochecker.genetic.jmetal.metaheuristics.settings.NSGAII_Settings;
import evochecker.genetic.jmetal.metaheuristics.settings.SPEA2_Settings;
import evochecker.properties.Property;
import jmetal.core.Algorithm;
import jmetal.core.Problem;
import jmetal.experiments.Settings;
import jmetal.util.JMException;

public class MDPSynthesisStudy extends Experiment{

	private Problem problemStudy;

	private String 		modelFilename;		//= "models/DPM/dpm.pm";
	private String 		propertiesFilename;// 	= "models/DPM/dpm.pctl";

	private int times = 0;
	
	private List<Property> objectives;
	
	
	@Override
	public void algorithmSettings(String problemName, int problemIndex, Algorithm[] algorithm) throws ClassNotFoundException {
	      try {
		  
	    	  
	    	  
		      int numberOfAlgorithms = algorithmNameList_.length;
	
		      HashMap[] parameters = new HashMap[numberOfAlgorithms];
	
		      for (int i = 0; i < numberOfAlgorithms; i++) {
		          parameters[i] = new HashMap();
		        } // for
		      
		      	if (!(paretoFrontFile_[problemIndex] == null) && !paretoFrontFile_[problemIndex].equals("")) {
		      		for (int i = 0; i < numberOfAlgorithms; i++)
		      			parameters[i].put("paretoFrontFile_", paretoFrontFile_[problemIndex]);
          		} // if
	
		      //set the algorithms
		      	switch (times % numberOfAlgorithms){
		      		case 0:{ 	algorithm[0] = new NSGAII_Settings(problemName, problemStudy).configure();
		      			   		break;}
		      		
		      		case 1:{ 	algorithm[1] = new SPEA2_Settings(problemName, problemStudy).configure();
		      					break;}
  	
//		      		case 2:{	algorithm[2] = new MOCell_Settings(problemName, problemStudy).configure();
//			      				break;}
//		      		case 3:{ 	algorithm[3] = new RandomSearch_Settings(problemName, problemStudy).configure();
//  			   					break;}
//		      		
		
  		
  			      		default:{throw new JMException("Error in algorithmSettings()");}
		      	}
		      	times++;
	      } catch (IllegalArgumentException ex) {
	          Logger.getLogger(MDPSynthesisStudy.class.getName()).log(Level.SEVERE, null, ex);  
	      } catch  (JMException ex) {
	          Logger.getLogger(MDPSynthesisStudy.class.getName()).log(Level.SEVERE, null, ex);  
	      }    
	  } // algorithmSettings

	
	 public static void main(String[] args) throws IOException{
//		 System.out.println(FileUtil.readFile("data/ow/data/Prism/ow/FUN.1"));
		 
		 
		 String configFile ="config.properties"; 
		 Utility.setPropertiesFile(configFile);
		  int runs = Integer.parseInt(Utility.getProperty("RUNS", "10"));
		  
//		  for (int runNum=0; runNum<runs; runNum++){
			  long start = System.currentTimeMillis();
		  
			  MDPSynthesisStudy evoStudy = new MDPSynthesisStudy();
			  try {
				
				  //init evoChecker
				  evoStudy.initialize();
				  //give a name for the study
				  evoStudy.experimentName_ 	= Utility.getProperty(Constants.PROBLEM_KEYWORD);
				  //name the algorithms
				  evoStudy.algorithmNameList_ = new String[]{"NSGAII", "SPEA2"};
				  //name the problem
				  evoStudy.problemList_		= new String[]{Utility.getProperty(Constants.PROBLEM_KEYWORD)};
				  //name the pareto front - empty if unknown
				  evoStudy.paretoFrontFile_	= new String[1];//Space allocation for 1 front;
				  //name the indicators
				  evoStudy.indicatorList_		= new String[]{"HV", "GD", "IGD", "GENSPREAD", "EPSILON"};		  
				  
				  //output directory
				  String outputDir					= Utility.getProperty("OUTPUTDIR", "data") ;
				  if (outputDir == null)
					  throw new FileNotFoundException("Output directory not specified");
				  evoStudy.experimentBaseDirectory_	= outputDir + File.separator + evoStudy.experimentName_;
				  //pareto front directory - empty if unknown
				  evoStudy.paretoFrontDirectory_ 	= "";
				  
				  //init the array containing the settings of the algorithms
				  int numOfAlgorithms			= evoStudy.algorithmNameList_.length;
				  evoStudy.algorithmSettings_	= new Settings[numOfAlgorithms];
				  
				  //set the runs
				  evoStudy.independentRuns_		= runs;
				  
				  //init the experiment
				  evoStudy.initExperiment();
				  
				  //Run the experiments - number of threads
//				  evoStudy.runExperiment(1);
				  
				  //Run model checkers
//				  evoStudy.runModelCheckers(evoStudy);
				  
				  //Generate quality indicators
				  evoStudy.generateQualityIndicators();
	
				  //Generate latex tables
				  evoStudy.generateLatexTables();
				  				
			} catch (Exception e) {
				e.printStackTrace();
			}
			  
			long end = System.currentTimeMillis();
				
			//export time taken to file
//			long timeUsed = (end - start)/1000;
//			System.err.println("Run " + runNum +":\t" + timeUsed);
//			String fileName = Utility.getProperty("OUTPUTDIR") + Utility.getProperty("EXPERIMENT") + "/run.csv";
//			FileUtil.saveToFile(fileName, timeUsed+"", true);
		  }
//	  }
	 
	 
	 private void initialize() {
		 String problem = null;
		 problem = "simple";	//Simple Model		
		 problem = "dpm";		//DPM Model
		 problem = "csma";		//CSMA Model
//		 problem = "wlan";		//WLAN Model
//		 problem = "zeroconf";	//Zeroconf Model
//		 problem = "consensus";	//Consensus
//		 problem = "dpm";		//DPM
//		 problem = "scheduler";	//Scheduler - WORKS BUT TAKES A LONG TIME
//		 problem = "team";		//Team
////		 problem = "teamAtva";		//Team
////		 problem = "fx";		//FX
		 problem = "tas";		//TAS
		 problem = "ow";		//Javier's models
		 
//		 String model = "models/" + problem +"Old/"+ problem +"5.pm";
//		 String prop  = "models/" + problem +"Old/"+ problem +".pctl";

		//From config.properties
		String model = Utility.getProperty(Constants.MODEL_FILE_KEYWORD);
		String prop  = Utility.getProperty(Constants.PROPERTIES_FILE_KEYWORD);
		problem 	 = model.substring(model.lastIndexOf("/")+1, model.lastIndexOf("."));

		 
		MDPSynthesis transformer = new MDPSynthesis(model, prop);
//			transformer.run();
		//1) Create EvoChecker instance
//			EvoChecker ec = new EvoChecker();
		
		transformer.runEvolvables();//Short();
		//1) Create EvoChecker instance
		EvoChecker ec = new EvoCheckerMDP(transformer.internalModelRepresentation, transformer.evolvables);
	
		
		String evoModel 	 = transformer.getEvoModelFile();
		String evoProperties = transformer.getEvoPropertiesFile();
		
		//2) Set configuration file
		String configFile ="config.properties"; 
		ec.setConfigurationFile(configFile);
		
		ec.setProperty(Constants.PLOT_PARETO_FRONT, "false");
		ec.setProperty(Constants.PYTHON3_DIRECTORY, "/Users/sgerasimou/anaconda3/bin/python3");
//		ec.setProperty(Constants.VERBOSE, "false");
		ec.setProperty(Constants.MODEL_FILE_KEYWORD, evoModel);
		ec.setProperty(Constants.PROPERTIES_FILE_KEYWORD, evoProperties);
		ec.setProperty(Constants.PROBLEM_KEYWORD, problem);
		ec.setProperty(Constants.PROCESSORS_KEYWORD, "1");
		ec.setProperty(Constants.DOUBLE_PRECISION, "12");
//		ec.setProperty(Constants.ALGORITHM_KEYWORD, "NSGAII");

//		ec.setProperty(Constants.POPULATION_SIZE_KEYWORD, "50");
//		ec.setProperty(Constants.MAX_EVALUATIONS_KEYWORD, "1000");
//		ec.setProperty(Constants.INTEGER_MUTATION_PROBABILITY, "0.9");
		ec.setProperty("MUTATION_OPERATOR", "PolynomialUniformAll");

		
		//get problem
		try {
			ec.makeInitialisations();
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(-1);
		}
		problemStudy = ec.getProblem(); 
		modelFilename = model;
		propertiesFilename = prop;
		objectives = ec.getObjectives();
	 }
	 
	 
	 private void runModelCheckers(Experiment evoStudy) {
		 //Append Prism and Storm to Algorithms
		 String[] strA = Arrays.copyOf(evoStudy.algorithmNameList_, evoStudy.algorithmNameList_.length+2);
		 strA[evoStudy.algorithmNameList_.length] 	= "Prism";
		 strA[evoStudy.algorithmNameList_.length+1] = "Storm";
		 evoStudy.algorithmNameList_ = strA;
		 
		 
		//Run Prism
		String prismResult 	= RunPrism.runPrism(modelFilename, propertiesFilename," ", objectives);
		String filePathP 	= evoStudy.experimentBaseDirectory_ + "/data/Prism/" + evoStudy.problemList_[0];
		FileUtil.createDir(filePathP);
		for (int i=0; i<evoStudy.independentRuns_; i++) {
			FileUtil.saveToFile(filePathP + "/FUN."+i, prismResult.substring(0, prismResult.length()-1), false);
		}
		
		//Run Storm
		String stormResult = RunStorm.runStorm(modelFilename, propertiesFilename, " ", objectives);
		String filePathS 	= evoStudy.experimentBaseDirectory_ + "/data/Storm/" + evoStudy.problemList_[0];
		FileUtil.createDir(filePathS);
		for (int i=0; i<evoStudy.independentRuns_; i++) {
			FileUtil.saveToFile(filePathS + "/FUN."+i, stormResult.substring(0, stormResult.length()-1), false);
		}
	 }
}
