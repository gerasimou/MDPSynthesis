package old.property.parser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import old.property.Constraint;
import old.property.Label;
import old.property.Objective;
import old.property.Property;

public class PCTLParser implements IPropertyParser {

	private List<Property> propertyList;
	private List<Label> labelList;
	private Map<String, Label> cachedLabel;
	private String propertyFileName;
	private String modelFileName;

	public PCTLParser(List<Label> labelList) {
		propertyList 	= new ArrayList<Property>();
		this.labelList 	= labelList;
		cachedLabel 	= new LinkedHashMap<String, Label>();
	}

	@SuppressWarnings("resource")
	@Override
	public void parse(String propertyFilePath) throws Exception {
		propertyFileName = propertyFilePath;
		BufferedReader read = null;
		String line;
		read = new BufferedReader(new FileReader(new File(propertyFileName)));
		while ((line = read.readLine()) != null) {
			if (line.startsWith("//")) {
				String s[] = line.replace("//", "").split(",");

				Property p = null;
				if (s[0] != null) {
					if (s[0].trim().equals("objective") || s[0].trim().equals("Objective")) {
						p = new Objective();
						propertyList.add((Objective) p);
					}

					if (s[0].trim().equals("constraint") || s[0].trim().equals("Constraint")) {
						p = new Constraint();
						propertyList.add((Constraint) p);
					}
				}
				if (p != null && s.length > 1) {

					if (s[1] != null) {
						if (s[1].trim().equals("max") || s[1].trim().equals("maximum")) {
							p.setMaximization(true);
						}
					}
				}

				if (p != null && s.length > 2) {
					if (s[2] != null) {
						// threshold
						double d = Double.parseDouble(s[2].trim());
						p.setThreshold(d);
					}
				}

				if (p != null) {
					// read the following line which must be expression
					line = read.readLine();
					if (line != null && line.length() >= 2 && !line.startsWith("//"))
						p.setRawExpression(line);
					else if (line.startsWith("//")) {
						propertyList.remove(p);
					} else
						throw new Exception("no constraint/objective expression found");
				}
			}
		}
		read.close();

		// process raw expression of all properties and obtain actual expression
		for (Property p : propertyList) {
			getExpressionForProperty(p);
		}
	}

	public void readFileForLabels(String modelFilePath) throws Exception {
		modelFileName = modelFilePath;
		BufferedReader read = null;
		String line;
		read = new BufferedReader(new FileReader(new File(modelFileName)));
		while ((line = read.readLine()) != null) {
			if (line.startsWith("label ")) {
				// read chars after label to first equal sign for label
				String str = line.replace("label \"", "");
				String key = str.substring(0, str.lastIndexOf("\""));
				str = line.substring(0, line.indexOf("=") + 1);
				str = line.replace(str, "");
				str = str.substring(0, str.length() - 1);
				Label l = new Label(key, str, true);
				labelList.add(l);
			}
		}
	}

	@Override
	public List<Property> getListProperties() {
		return propertyList;
	}

	@Override
	public List<Label> getListLabels() {
		return labelList;
	}

	@Override
	public Label getLabelByString(String labelKey) {
		Label l = cachedLabel.get(labelKey);
		if (l != null)
			return l;

		for (Label ll : labelList) {
			if (labelKey.equals(ll.getLabelKey())) {
				// store in cache
				cachedLabel.put(labelKey, ll);
				return ll;
			}
		}
		return null;
	}

	@Override
	public List<Integer> getSatisfyingStates(String rawProperty) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Accepts a property instance and update its raw expression string with actual
	 * expression if this property contains labels
	 * 
	 * @param p
	 * @return an update raw property string with labels replaced with actuall
	 *         expression string
	 */
	private void getExpressionForProperty(Property p) {

		String rawPropertyExp = p.getRawExpression();
		String rawExp = rawPropertyExp.trim();
		// 1. Substring expression: starting from first "[" and ends with "]"
		int i = rawExp.indexOf("[");
		int j = rawExp.lastIndexOf("]");
		rawExp = rawExp.substring(i + 1, j);
		rawExp = rawExp.trim();
		// 2. replace all strings starting with "{" and ending with "}" to empty string
		while (rawExp.contains("{") && rawExp.contains("}")) {
			i = rawExp.indexOf("{");
			j = i + 1;
			for (; j < rawExp.length(); j++) {
				if (rawExp.charAt(j) == '}') {
					break;
				}
			}
			rawExp = rawExp.replace(rawExp.substring(i + 1, j), "");
		}
		rawExp = rawExp.trim();
		// 3. decide whether it is "U" (bounded until) or "F" final
		if (rawExp.startsWith("F")) {
			// resolve all labels and get corresponding expressions
			rawPropertyExp = replaceAllLabelsWithExpressions(rawExp, p);
			p.setRawExpression(rawPropertyExp);
			i = rawPropertyExp.indexOf("[");
			j = rawPropertyExp.lastIndexOf("]");
			rawPropertyExp = rawPropertyExp.substring(i + 1, j);
			rawPropertyExp = rawPropertyExp.trim();
			rawPropertyExp = rawPropertyExp.replace("F", "");
			p.setActualExpression(rawPropertyExp);
			// System.out.println(rawPropertyExp);
		} else if (rawExp.startsWith("true") || rawExp.startsWith("false")) {
			// 3.1. if U and there exists true keywords then ...
		} else if (rawExp.startsWith("C")) {
			return;
		} else {
			rawPropertyExp = replaceAllLabelsWithExpressions(rawExp, p);
			p.setRawExpression(rawPropertyExp);
			i = rawPropertyExp.indexOf("[");
			j = rawPropertyExp.lastIndexOf("]");
			rawPropertyExp = rawPropertyExp.substring(i + 1, j);
			rawPropertyExp = rawPropertyExp.trim();
			p.setActualExpression(rawPropertyExp);
			// System.out.println(rawPropertyExp);
		}
	}

	private String replaceAllLabelsWithExpressions(String rawExp, Property p) {
		String returnStr = p.getRawExpression();
		while (rawExp.contains("\"")) {
			String value = null;
			int i = rawExp.indexOf("\"");
			int j = i + 1;
			for (; j < rawExp.length(); j++) {
				if (rawExp.charAt(j) == '\"') {
					break;
				}
			}
			String label_key = rawExp.substring(i + 1, j);
			// look for the label in label list and then
			// obtain the corresponding expression
			Label l = getLabelByString(label_key);
			if (l != null)
				value = l.getLabelValue();

			if (value != null) {
				label_key = "\"" + label_key + "\"";
				value = "(" + value + ")";
				rawExp = rawExp.replace(label_key, "");
				returnStr = returnStr.replaceAll(label_key, value);
			}
			// System.out.println(returnStr);
		}
		return returnStr;
	}

	@Override
	public String getPropertyFileName() {
		return propertyFileName;
	}

	@Override
	public String getModelFileName() {
		return modelFileName;
	}
}
