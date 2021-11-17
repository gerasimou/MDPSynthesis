package utilities;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class FileRenamer {

	public static void main(String[] args) throws IOException {

		String []algos 		= new String[] {"NSGAII", "SPEA2"};
		String []problems	= new String[] {"ow4", "ow5", "ow6"};
		
		for (String algo : algos) {
			for (String problem : problems) {
				String path = "data/" + problem + "/data/" + algo + "/" + problem;
				Boolean[] objMax = new Boolean[] {false, true, true};
						
				File dir = new File(path);

				
		        File[] filesInDir = dir.listFiles();
		        
		        //find files with "front" suffix
		        List<File> pFronts = new ArrayList<>();
		        List<File> pSet    = new ArrayList<>();
		        for (File f : filesInDir) {
		        	if (f.getName().endsWith("Front"))
		        		pFronts.add(f);
		        	else
		        		pSet.add(f);
		        	
//		        	System.out.println(f.getParent());
		        }        
		        
//		      Boolean[] objMax = new Boolean[] {false, true};

		        refactorPFFiles(pFronts, objMax);
		        
//		        int i = 0;
//		        int start=10, finish =23;
//		        for (File f : pFronts) {        	
//		        	String key = f.getName().substring(start, finish);
		//
//		        	Path p = Paths.get(f.getAbsolutePath());
//		        	Files.move(p, p.resolveSibling("FUN."+i));
//		        	
//		        	File ff;
//		        	int j=0;
//		        	for (; j<pSet.size(); j++) {
//		        		File f2  = pSet.get(j);
//		        		
//		        		if (f2.getName().contains(key))
//		        			break;
//		        	}
//		        	ff = pSet.get(j);
//		        	Path pp = Paths.get(ff.getAbsolutePath());
//		        	Files.move(pp, pp.resolveSibling("VAR."+i++));
//		        }
			}
		}
	}
	
	
	private static void refactorPFFiles(List<File> pFronts, Boolean[] objMax) {
		int n = 0;
		for (File f : pFronts) {
			try {
				StringBuilder output = new StringBuilder(100);

				BufferedReader bfr = null;
				bfr = new BufferedReader(new FileReader(f));
				String line = null;

				//ignore first line
				bfr.readLine();

				while ((line = bfr.readLine()) != null) {
					String[] values = line.split("\t");
					for (int i=0; i<values.length; i++) {
						if (objMax[i])
							output.append("-"+values[i]);
						else
							output.append(values[i]);
						output.append(" ");
					}
					output.append("\n");
				}
				
				
				String name = f.getParent() +"/FUN." + n++; 
				
				FileUtil.saveToFile(name, output.subSequence(0, output.length()-1).toString(), false);
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(-1);
			}


		}	
	}

}
