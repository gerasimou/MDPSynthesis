package mdpSynthesis;

import java.io.IOException;

public class RunStorm {

	public static void main(String[] args) {
		String model 		= "inputs/fx/fxSmall.pm";
		String properties	= "inputs/fx/fxSmall.pctl";

		if (args.length == 2) {
			model = args[0];
			properties = args[1];
		}
		System.out.println(runStorm(model, properties));
	}
	
	
	
	public static String runStorm (String model, String properties) {
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
					stormOutput.append(String.join("\t", points) +"\n");
				}
	//			System.out.println(stormOutput.toString());
			}
			return stormOutput.toString();
			
		} catch (IOException e) {
			e.printStackTrace();	
		}		
		return null;
	}

}
