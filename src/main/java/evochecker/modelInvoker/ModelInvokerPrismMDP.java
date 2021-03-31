//==============================================================================
//	
//	Copyright (c) 2020-
//	Authors:
//	* Simos Gerasimou (University of York)
//  * Faisal Alhwikem (University of York)
//	
//------------------------------------------------------------------------------
//	
//	This file is part of EvoChecker.
//	
//==============================================================================
package evochecker.modelInvoker;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import org.spg.PrismAPI.PrismAPI;

import evochecker.exception.EvoCheckerException;
import parser.Values;
import parser.ast.ConstantList;
import parser.ast.ExpressionLiteral;
import parser.ast.ModulesFile;
import prism.Prism;
import prism.PrismLangException;

public class ModelInvokerPrismMDP extends ModelInvokerPrism{	
	/**
	 * Default class constructor
	 */
	
	PrismAPI api = new PrismAPI();
	Prism prism  = null;
	ModulesFile modulesFile = null;
	ConstantList constantsList = null;
	
	public ModelInvokerPrismMDP() {
		
	}
	

	public List<String> invoke(String model, String propertyFile, Map<String, Object> chromosome) throws EvoCheckerException{
		if (model != null) {
			//parse model and properties 
			api.parseModelAndProperties(model, propertyFile);
		
			//build model
			api.buildModel();		
			
			prism = api.getPrism();
			
			modulesFile 	= api.getMofulesFile();
			constantsList 	= modulesFile.getConstantList(); 

			//Run prob. model checking
			List<Object> res = api.runPrism();
			return res.stream().map(op -> op.toString()).collect(Collectors.toList());
		}
		else {
			Values v = new Values();
//				ModulesFile modulesFile = prism.getMofulesFile();
//				constantsList = modules
			for (Entry<String, Object> c :  chromosome.entrySet()) {
				int index = constantsList.getConstantIndex(c.getKey());
				constantsList.setConstant(index, new ExpressionLiteral(constantsList.getConstantType(index), c.getValue()));
				v.setValue(c.getKey(), c.getValue());
			}
			try {
				modulesFile.setUndefinedConstants(v);
			} catch (PrismLangException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			api.buildModel();

			//Run prob. model checking
			List<Object> res = api.runPrism();
			return res.stream().map(op -> op.toString()).collect(Collectors.toList());
		}
	}
}
