package mdpSynthesis;

import java.io.IOException;
import java.util.List;

import evochecker.properties.Property;

public class RunStorm {

	public static void main(String[] args) {
		String model 		= "inputs/fx/fxSmall.pm";
		String properties	= "inputs/fx/fxSmall.pctl";

		if (args.length == 2) {
			model = args[0];
			properties = args[1];
		}
		System.out.println(runStorm(model, properties, "\t"));
	}
	
	
	
	public static String runStorm (String model, String properties, String delimiter) {
		String params[] = new String[] {"/usr/local/bin/storm", "--prism", 
				model, "--prop", properties};  

		StringBuilder stormOutput = new StringBuilder();
		
		try {
			ProcessBuilder pb = new ProcessBuilder(params);
			Process p = pb.start();
			String result = new String(p.getInputStream().readAllBytes());
			String toFind = "Pareto optimal points found:";
			int index = result.indexOf(toFind);
			if (index != -1) {
				String paretoFront[] = result.substring(index+toFind.length()+1).split("\n");
				
				for (String pareto : paretoFront) {
					if (pareto.isBlank())
						break;
					String points[] = pareto.trim().strip().replaceAll("(\\(|\\)|\\s+)", "").split(",");//replaceAll(" ", "").
					stormOutput.append(String.join(delimiter, points) +"\n");
				}
	//			System.out.println(stormOutput.toString());
			}
			return stormOutput.toString();
			
		} catch (IOException e) {
			e.printStackTrace();	
		}		
		return null;
	}
	
	
	
	public static String runStorm (String model, String properties, String delimiter, List<Property> objectives) {
		String params[] = new String[] {"/usr/local/bin/storm", "--prism", 
				model, "--prop", properties};  

		StringBuilder stormOutput = new StringBuilder();
		
		try {
			ProcessBuilder pb = new ProcessBuilder(params);
			Process p = pb.start();
			String result = new String(p.getInputStream().readAllBytes());
			String toFind = "Pareto optimal points found:";
			int index = result.indexOf(toFind);
			if (index != -1) {
				String paretoFront[] = result.substring(index+toFind.length()+1).split("\n");
				
				for (String pareto : paretoFront) {
					if (pareto.isBlank())
						break;
					String points[] = pareto.trim().strip().replaceAll("(\\(|\\)|\\s+)", "").split(",");//replaceAll(" ", "").
					
					for (int i=0; i<objectives.size(); i++) {
						if (objectives.get(i).isMaximization())
							stormOutput.append("-" + points[i]);
//							stormOutput.append(points[i]);
						else
							stormOutput.append(points[i]);
						if (i<objectives.size()-1)
							stormOutput.append(delimiter);
					}
					stormOutput.append("\n");
				}
			}
			return stormOutput.toString();
			
		} catch (IOException e) {
			e.printStackTrace();	
		}		
		return null;
	}

}
