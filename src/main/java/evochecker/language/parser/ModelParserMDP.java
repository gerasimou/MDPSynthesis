package evochecker.language.parser;

import java.util.List;

import evochecker.evolvables.Evolvable;

public class ModelParserMDP extends ModelParser {

	public ModelParserMDP(String modelFilename, String propertiesFilename, List<Evolvable> evolvables, String internalModelRepresentation) {
		super(modelFilename, propertiesFilename);
		
		this.evolvableList = evolvables;

		//set internal model representation
		this.internalModelRepresentation = internalModelRepresentation;
		
		//get model type
		this.modelType = MODEL_TYPE.DTMC;
	}
	
	
	@Override
	protected void parse() {
	}
}
