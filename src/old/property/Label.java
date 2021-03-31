package old.property;

public class Label {

	private boolean propertyLabel = false;
	private String key = null;
	private String value = null;

	public Label(String key, String value, boolean propertyLabel) {
		this.key = key;
		this.value = value;
		this.propertyLabel = propertyLabel;
	}

	public Label(String key, String value) {
		this.key = key;
		this.value = value;
		this.propertyLabel = false;
	}

	public String getLabelKey() {
		return key;
	}

	public String getLabelValue() {
		return value;
	}

	public boolean isPropertyLabel() {
		return propertyLabel;
	}
}
