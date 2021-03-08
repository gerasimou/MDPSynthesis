package property;

public class Constraint extends Property {

	/**
	 * Construct a new constraint QoS property.
	 * 
	 */
	public Constraint() {
		super();
	}

	/**
	 * Construct a new constraint QoS property.
	 * 
	 * @param maximization
	 */
	public Constraint(boolean maximization) {
		super(maximization);
	}
}
