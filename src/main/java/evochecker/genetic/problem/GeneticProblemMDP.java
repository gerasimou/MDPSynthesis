//==============================================================================
//	
//	Copyright (c) 2015-
//	Authors:
//	* Simos Gerasimou (University of York)
//	
//------------------------------------------------------------------------------
//	
//	This file is part of EvoChecker.
//	
//==============================================================================

package evochecker.genetic.problem;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.util.List;

import evochecker.exception.EvoCheckerException;
import evochecker.genetic.genes.AbstractGene;
import evochecker.language.parser.IModelInstantiator;
import evochecker.modelInvoker.ModelInvokerPrism;
import evochecker.modelInvoker.ModelInvokerPrismMDP;
import evochecker.properties.Property;

public class GeneticProblemMDP extends GeneticProblem {

	private static final long serialVersionUID = -2679872853510614319L;
	
	boolean first = true;

	/**
	 * Class constructor: create a new Genetic Problem instance
	 * @param genes
	 * @param properties
	 * @param instantiator
	 * @param numOfConstraints
	 */
	public GeneticProblemMDP(List<AbstractGene> genes, IModelInstantiator instantiator,
						  List<Property> objectivesList, List<Property> constraintsList, String problemName){
		super(genes, instantiator, objectivesList, constraintsList, problemName);
		modelInvoker = new ModelInvokerPrismMDP();
	}
	
	
	/**
	 * Copy constructor
	 * @param aProblem
	 * @throws EvoCheckerException
	 */
	public GeneticProblemMDP (GeneticProblemMDP aProblem) throws EvoCheckerException{		
		super(aProblem);
	}

	@Override
	protected List<String> evaluateByInvocation(PrintWriter out, BufferedReader in) throws Exception {
		//Prepare model
		//System.out.println(genes.get(0).getAllele() +"\t"+ genes.get(1).getAllele() );
		String model 		= null;//modelInstantiator.getConcreteModel(this.genes);
		String propertyFile = null;//modelInstantiator.getPropertyFileName();
//		System.out.println(model);
		
		if (first) {
			model = modelInstantiator.getConcreteModel(this.genes);
			propertyFile = modelInstantiator.getPropertyFileName();
			first = false;
		}
		
		return ((ModelInvokerPrismMDP)modelInvoker).invoke(model, propertyFile, modelInstantiator.getChromosome(genes));
		
//		return modelInvoker.invoke(model, propertyFile, objectivesList, constraintsList, out, in);
	}
}
