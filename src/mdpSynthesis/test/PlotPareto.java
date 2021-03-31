package mdpSynthesis.test;

import evochecker.auxiliary.Constants;
import evochecker.auxiliary.Utility;
import evochecker.plotting.PlotFactory;

public class PlotPareto {

	public static void main(String[] args) {
		String allResultsFilename = "data/ow/NSGAII/OW_NSGAII_310321_015357_Front_all"; 
		 //Plot
		 try {
			 
			 Utility.setPropertiesFile("config.properties");
			 Utility.setProperty(Constants.PYTHON3_DIRECTORY, "/Users/sgerasimou/anaconda3/bin/python3");
			 PlotFactory.setParetoFrontScriptFile("scripts/plotFront3DComparison.py");
			 PlotFactory.plotParetoFront(allResultsFilename, 3);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
