package mdpSynthesis.test;

import evochecker.plotting.PlotFactory;

public class PlotPareto {

	public static void main(String[] args) {
		String allResultsFilename = "data/fx/NSGAII/FX_NSGAII_170321_193630_Set"; 
		 //Plot
		 try {
			 PlotFactory.setParetoFrontScriptFile("scripts/plotFront2DComparison.py");
			PlotFactory.plotParetoFront(allResultsFilename, 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
