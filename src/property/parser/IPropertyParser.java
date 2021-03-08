package property.parser;

import java.util.List;

import property.Label;
import property.Property;

public interface IPropertyParser {

	public void parse(String path) throws Exception;

	public void readFileForLabels(String path) throws Exception;

	public List<Property> getListProperties();

	public List<Label> getListLabels();

	public Label getLabelByString(String rawProperty);

	public List<Integer> getSatisfyingStates(String rawProperty);

	public String getPropertyFileName();

	public String getModelFileName();
}
