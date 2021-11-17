package mdpSynthesis.test;

import java.util.List;

import parser.State;
import parser.VarList;
import parser.type.Type;
import prism.ModelGenerator;
import prism.ModelType;
import prism.PrismException;
import prism.RewardGenerator;

public class DTMCModelGenerator implements ModelGenerator, RewardGenerator{
	
	
	
	public DTMCModelGenerator () {
		
	}

	@Override
	public VarList createVarList() throws PrismException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ModelType getModelType() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<String> getVarNames() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Type> getVarTypes() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public State computeTransitionTarget(int arg0, int arg1) throws PrismException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void exploreState(State arg0) throws PrismException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public State getInitialState() throws PrismException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getNumChoices() throws PrismException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getNumTransitions(int arg0) throws PrismException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Object getTransitionAction(int arg0, int arg1) throws PrismException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public double getTransitionProbability(int arg0, int arg1) throws PrismException {
		// TODO Auto-generated method stub
		return 0;
	}
}
