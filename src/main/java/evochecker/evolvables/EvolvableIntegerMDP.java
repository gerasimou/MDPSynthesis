package evochecker.evolvables;

import java.util.HashMap;
import java.util.Map;

public class EvolvableIntegerMDP extends EvolvableInteger {

	protected Map<Integer, String> commands;
	
	public EvolvableIntegerMDP(String name, Integer maxValue, Map<Integer, String> commands){
		super(name, 0, maxValue, false);
		this.commands = commands;
	}
	
	
	/**
	 * Get command
	 */
	@Override
	public String getConcreteCommand(Object variable) {
		return commands.get(variable);
	}
}
