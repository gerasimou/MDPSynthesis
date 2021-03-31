package old.property;

public class Property {

	private boolean maximization = false;
	private double result;
	private Double threshold = null;
	private String expression = null;
	private String rawExpression = null;

	public Property() {
	}

	public Property(boolean maximization) {
		this.maximization = maximization;
	}

	public void setMaximization(boolean state) {
		maximization = state;
	}

	public boolean isMaximization() {
		return maximization;
	}

	public double getResult() {
		return result;
	}

	public void setResult(double result) {
		this.result = result;
	}

	public double getThreshold() {
		return threshold;
	}

	public void setThreshold(double threshold) {
		this.threshold = threshold;
	}

	public void setActualExpression(String expression) {
		this.expression = expression;
	}

	public String getActualExpression() {
		return expression;
	}

	public void setRawExpression(String rawExpression) {
		this.rawExpression = rawExpression;
	}

	public String getRawExpression() {
		return this.rawExpression;
	}
}
