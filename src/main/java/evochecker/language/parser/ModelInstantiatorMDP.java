package evochecker.language.parser;

import java.util.Collection;
import java.util.List;

import evochecker.evolvables.Evolvable;
import evochecker.exception.EvoCheckerException;
import evochecker.genetic.genes.AbstractGene;
import evochecker.genetic.genes.AlternativeModuleGene;
import evochecker.genetic.genes.DistributionGene;
import evochecker.genetic.genes.DoubleGene;
import evochecker.genetic.genes.IntegerGene;

public class ModelInstantiatorMDP extends ModelInstantiator{// Parametric {
	
	
	String flattenedMDP = null;
	String evoTemplateFileName;
	String evoPropertiesFileName;
	List<Evolvable> mdpEvolvables;

	public ModelInstantiatorMDP(String modelFilename, String propertiesFilename, List<Evolvable> evolvables, String internalModelRepresentation) {
		super(modelFilename, propertiesFilename, new ModelParserMDP(modelFilename, propertiesFilename, evolvables, internalModelRepresentation));
//		init(modelFilename, propertiesFilename);
	}
	
	
	/**
	 * Copy constructor
	 * @param aParser
	 * @throws EvoCheckerException
	 */
	public ModelInstantiatorMDP (ModelInstantiatorMDP aParser) throws EvoCheckerException{
		super(aParser);
	}
	
	@Override
	public String getConcreteModel(Collection<AbstractGene> genes) {
//		StringBuilder concreteModel = new StringBuilder("dtmc\n\n" + getInternalModelRepresentation() + "\n\n");
		StringBuilder concreteModel = new StringBuilder(getInternalModelRepresentation() + "\n\n");
		
		for (AbstractGene gene : genes) {
			if (gene instanceof IntegerGene) {
				concreteModel.append(elementsMap.get(gene).getConcreteCommand(gene.getAllele()));
			} 
			else if (gene instanceof DoubleGene) {
				concreteModel.append(elementsMap.get(gene).getConcreteCommand(gene.getAllele()));
			} 
			else if (gene instanceof DistributionGene) {
				concreteModel.append(elementsMap.get(gene)
										.getConcreteCommand((double[]) 
												gene.getAllele()));
			} 
			else if (gene instanceof AlternativeModuleGene) {
				concreteModel.append(elementsMap.get(gene).getConcreteCommand(gene.getAllele()));
			}	
		}
//		concreteModel.append("\n endmodule \n\n");
//		System.out.println(concreteModel);
		return concreteModel.toString();
	}
	
	
	protected String getInternalModelRepresentation() {
		//return flattenedMDP;
		return super.getInternalModelRepresentation();
	}
	
	@Override
	public String getPropertyFileName() {
		//return evoPropertiesFileName;
		return super.getPropertyFileName();
	}
	
	/**
	 * Get list of evolvable elements
	 * @return
	 */
	@Override
	public List<Evolvable> getEvolvableList (){
		//return this.mdpEvolvables;
		return super.getEvolvableList();
	}
}
