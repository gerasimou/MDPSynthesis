package mdpSynthesis;

import java.util.ArrayList;
import java.util.List;

import org.spg.PrismAPI.PrismAPI;

import evochecker.properties.Property;
import prism.Point;

public class RunPrism {
	
	public static String runPrism(String model, String prop, String delimiter) {
		StringBuilder sb = new StringBuilder();

		//Run Prism
		 PrismAPI api = new PrismAPI(null);
		 api.parseModelAndPropertiesFiles(model, prop);
		 api.buildModel();
		 try {
			 List<Object> results = api.runPrism();
	
	 
			 if (results.get(0) instanceof ArrayList<?>) {
				 ArrayList<?> rl = (ArrayList<?>) results.get(0); 
				 for (Object p : rl) {
					 sb.append(((Point)p).getCoord(0) + delimiter + ((Point)p).getCoord(1) +"\n");
	//				 System.out.println(((Point)p).getCoord(0) +"\t"+ ((Point)p).getCoord(1));
				 }
			 }
			return sb.toString();
		 }
		 catch (Exception | Error e) {
			 e.printStackTrace();
		 }
		 
		 return "";
	}
	
	
	
	public static String runPrism(String model, String prop, String delimiter, List<Property> objectives) {
		StringBuilder sb = new StringBuilder();

		//Run Prism
		 PrismAPI api = new PrismAPI(null);
		 api.parseModelAndPropertiesFiles(model, prop);
		 api.buildModel();
		 try {
			 List<Object> results = api.runPrism();
	
	 
			 if (results.get(0) instanceof ArrayList<?>) {
				 ArrayList<?> rl = (ArrayList<?>) results.get(0);
				 for (int i=0; i<rl.size(); i++) {
					 Object p = rl.get(i);
					 for (int j=0; j<objectives.size(); j++) {
						 if (objectives.get(j).isMaximization())
							 sb.append(-((Point)p).getCoord(j)); 
//							 sb.append(((Point)p).getCoord(j));
						 else
							 sb.append(((Point)p).getCoord(j));
						 sb.append(delimiter); 
					 }
					 sb.append("\n");
				 }
			 }
			return sb.toString();
		 }
		 catch (Exception | Error e) {
			 e.printStackTrace();
		 }
		 
		 return "";
	}
}
