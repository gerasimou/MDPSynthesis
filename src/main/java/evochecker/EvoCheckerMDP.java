package evochecker;

import java.util.List;

import evochecker.evolvables.Evolvable;
import evochecker.genetic.GenotypeFactory;
import evochecker.genetic.genes.AbstractGene;
import evochecker.genetic.problem.GeneticProblemMDP;
import evochecker.language.parser.IModelInstantiator;
import evochecker.language.parser.ModelInstantiatorMDP;
import evochecker.properties.Property;
import jmetal.core.Problem;

public class EvoCheckerMDP extends EvoChecker {

	List<Evolvable> evolvables = null;
	String internalModelRepresentation = null;
	
	public EvoCheckerMDP(String internalModelRepresentation, List<Evolvable> evolvables) {
		this.evolvables 					= evolvables;
		this.internalModelRepresentation	= internalModelRepresentation; 
	}
	
	/**
	 * Initialise the problem and the properties associated with the problem
	 * Note that in the next iteration of this code, 
	 * the initialisation should be done by reading the properties file
	 * @throws Exception
	 */
	protected void initializeProblem() throws Exception {
		//1 Get model and properties filenames
		String modelFilename		= getModelFileName();
		String propertiesFilename	= getPropertiesFileName();
		String problemName   		= getAlgorithmName();
		
		//2) parse model template
		IModelInstantiator mdpModelInstantiator = new ModelInstantiatorMDP(modelFilename, propertiesFilename, evolvables, internalModelRepresentation);
		setModelInstantiator(mdpModelInstantiator);

		//3) create chromosome
		setGenes(GenotypeFactory.createChromosome(mdpModelInstantiator.getEvolvableList(), false));
		List<AbstractGene> genes = getGenes();

		//4) create (gene,evolvable element) pairs
		mdpModelInstantiator.createMapping();
		
		//5) create properties list
		initialiseProperties();
		List<Property> objectivesList  = getObjectives();
		List<Property> constraintsList = getConstraints();
		
		//6) instantiate the problem
		Problem problemMDP =  new GeneticProblemMDP(genes, mdpModelInstantiator, objectivesList, constraintsList, problemName);
		setProblem(problemMDP);
	}	
	
}

