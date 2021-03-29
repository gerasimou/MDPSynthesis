package mdpSynthesis;

import java.util.ArrayList;
import java.util.BitSet;
import java.util.Iterator;
import java.util.List;

import explicit.MDPSparse;
import parser.State;
import parser.Values;
import parser.VarList;
import parser.ast.Expression;
import parser.ast.ExpressionBinaryOp;
import parser.ast.ExpressionFormula;
import parser.ast.ExpressionLabel;
import parser.ast.ExpressionProb;
import parser.ast.ExpressionQuant;
import parser.ast.ExpressionReward;
import parser.ast.ExpressionTemporal;
import parser.ast.ExpressionUnaryOp;
import parser.ast.ExpressionVar;
import parser.ast.ModulesFile;
import parser.visitor.ASTTraverse;
import prism.PrismLangException;

public class PropertiesVisitor extends ASTTraverse{
	
	MDPSparse mdpModel = null;
	ModulesFile modulesFile = null;
	
	ExpressionBinaryOpVisitor v  = new ExpressionBinaryOpVisitor();
	ExpressionTemporalVisitor vv = new ExpressionTemporalVisitor();
	
	List<String> varList = new ArrayList<>();
	String exprString;
	
	List<String> evoProperties;

	public PropertiesVisitor(MDPSparse model, ModulesFile mFile) {
		mdpModel 	= model;
		modulesFile	= mFile;
		
		evoProperties = new ArrayList<>();
	}

	public void visitPost(ExpressionReward e) throws PrismLangException {
//		System.out.println(e.toString());
		
		Expression e1 = e.getExpression();
		if (e1 instanceof ExpressionTemporal && e1!=null) {
			((ExpressionTemporal)e1).accept(vv);
		}
		else {
			exprString = "";
		}
		evoProperties.add(toString(e));
	}
	
	
	public void visitPost(ExpressionProb e) throws PrismLangException {
//		System.out.println(e.toString());
		Expression e1 = e.getExpression();
		if (e1 instanceof ExpressionTemporal) {
			((ExpressionTemporal)e1).accept(vv);
		}
		evoProperties.add(toString(e));	
	}
	

	private String toString(ExpressionProb e) {
		String s = "";
//		if (e.getBound() == null) {//an objective			
//			s += "P" + e. getModifierString() + e.getRelOp();
//			s += (e.getBound() == null) ? "?" : e.getBound().toString();
//		}
//		else {//a constraint
			s += "P" + e. getModifierString() + "=?";
//		}
		
		Expression e1 = e.getExpression();
		String symbol ="";
//		if (e1 instanceof ExpressionTemporal) {
//			int operator = ((ExpressionTemporal)e1).getOperator();
//			if (operator == ExpressionTemporal.P_U)
//				symbol = ExpressionTemporal.opSymbols[ExpressionTemporal.P_F];
//			else
//				symbol = ((ExpressionTemporal)e1).getOperatorSymbol();
//		}
//		s += " [ " + symbol +" "+ exprString +" ]";

		s += " [ " + exprString +" ]";

		String req = getRequirementType(e);
		return req +"\n"+ s;
	}
	
	
	private String toString (ExpressionReward e) {
		String s = "";	
		s += "R" + e.getModifierString();
		if (e.getRewardStructIndex() != null) {
			if (e.getRewardStructIndex() instanceof Expression) s += "{"+e.getRewardStructIndex()+"}";
			else if (e.getRewardStructIndex() instanceof String) s += "{\""+e.getRewardStructIndex()+"\"}";
//			if (e.rewardStructIndexDiv != null) {
//				s += "/";
//				if (e.rewardStructIndexDiv instanceof Expression) s += "{"+e.rewardStructIndexDiv+"}";
//				else if (e.rewardStructIndexDiv instanceof String) s += "{\""+e.rewardStructIndexDiv+"\"}";
//			}
		}
		
		s += "=?";
		
//		if (e.getBound() == null) {//an objective			
//			s += e.getRelOp();
//			s += e.getBound().toString();
//		}
//		else {//a constraint
//			s += "=?";
//		}

		
		Expression e1 = e.getExpression();
		String symbol ="";
		if (e1 instanceof ExpressionTemporal) {
			int operator = ((ExpressionTemporal)e1).getOperator();
			if (operator == ExpressionTemporal.R_C) {
//				s += " [ " + e1 +" ]";
				s += " [ " + exprString +" ]";
			}
			else {
				symbol = ((ExpressionTemporal)e1).getOperatorSymbol();
				s += " [ " + exprString +" ]";
			}
		}
		
		String req = getRequirementType(e);
		return req +"\n"+ s;
	}

	private String getRequirementType(ExpressionQuant e) {
		//Specify whether it is a constraint: CONSTRAINT, MAX/MIN, 0.9
		//or objective: OBJETIVE, MAX/MIN
		String req = "//";
		if (e.getBound() == null) {//it is an objective
			req += "OBJECTIVE,";
			req += e.getRelOp().name().substring(0, e.getRelOp().name().length());
		}
		else {
			req += "CONSTRAINT, ";
			if (e.getRelOp().isLowerBound())
				req += "MIN, ";
			else
				req += "MAX, ";

//			req += e.getRelOp().name().substring(0, e.getRelOp().name().length());
			req += e.getBound().toString();
		}
//		req += (e.getBound() == null) ? "OBJECTIVE, " : "CONSTRAINT, ";
//		req += e.getRelOp().name().substring(0, e.getRelOp().name().length());
//		req += (e.getBound() == null) ? "" : e.getBound().toString();

		return req;
	}
	

	public void visitPreA(ExpressionBinaryOp e) throws PrismLangException{
//		List<Integer> validStates = new ArrayList<Integer>();
//		List<State> statesList = mdpModel.getStatesList();
//		int numStates = statesList.size();
//		
//		for (int i = 0; i < numStates; i++) {
//			boolean b = e.evaluateBoolean(statesList.get(i));
//			if (b)
//				validStates.add(i);
//		}
//		StringBuilder sb = new StringBuilder();
//		Iterator<Integer> it = validStates.iterator();
//		while (it.hasNext()) {
//			sb.append("x="+it.next());
//			if (it.hasNext())
//				sb.append("|");
//		}
//		
////		e.setOperand1(null);
////		e.setOperand2(new ExpressionLiteral(TypeInt.getInstance(), sb.toString()));
////		e.setOperator(ExpressionBinaryOp.OR);
////		e = new ExpressionBinaryOp(ExpressionBinaryOp.OR, null, new ExpressionBinaryOp());
////		e.setOperand1(new ExpressionVar(((ExpressionVar) e1).getName()+"s", e1.getType()));
////		e.setOperand2(new ExpressionLiteral(e2.getType(), "0"));
//
//		exprString = sb.toString();
//		
////		String s = e.toString();
////		System.out.println(s);
	}
	
	
	public List<String> getEvoProperties(){
		return this.evoProperties;
	}
	
	
	
	public class ExpressionTemporalVisitor extends ASTTraverse{

		@Override
		public void visitPre(ExpressionTemporal e) throws PrismLangException{
			String s = "";
			//Check whether it is a complex expression (e.g., and parse its component
			Expression e1 = e.getOperand1();
			Expression e2 = e.getOperand2();
			
			if (e1==null && e2==null) {
				exprString = e.toString();
				return;
			}
			
			if (e1 instanceof ExpressionBinaryOp || e1 instanceof ExpressionUnaryOp || e1 instanceof ExpressionFormula) {
				s += evaluate (e1);
			}
			else if (e1 != null)
				throw new PrismLangException("Unsupported expression: " + e);

			if (e2 instanceof ExpressionBinaryOp || e2 instanceof ExpressionUnaryOp || e2 instanceof ExpressionFormula) {
				s += " "+ e.getOperatorSymbol() +" "+ evaluate(e2);
			}
			else if (e2 instanceof ExpressionLabel) {
				String label = ((ExpressionLabel)e2).getName();
//				modulesFile.getl
				BitSet bitS = mdpModel.getLabelStates(label);
				System.out.println(String.join(bitS.toString(), "-"));
			}
			else if (e2 != null)
				throw new PrismLangException("Unsupported expression: " + e);

			exprString = s; 
		}
		
		
		private String evaluate (Expression e) throws PrismLangException {
			List<Integer> validStates = new ArrayList<Integer>();
			List<State> statesList = mdpModel.getStatesList();
			int numStates = statesList.size();
			
			Values constantValues = mdpModel.getConstantValues();
			
			for (int i = 0; i < numStates; i++) {
				boolean b = e.evaluateBoolean(constantValues, statesList.get(i));
				if (b)
					validStates.add(i);
			}
			StringBuilder sb = new StringBuilder();
			Iterator<Integer> it = validStates.iterator();
			while (it.hasNext()) {
				sb.append("x="+it.next());
				if (it.hasNext())
					sb.append("|");
			}
			return sb.toString();
		}
	}
	
	
	
	private String findValidStates(ExpressionBinaryOp e) throws PrismLangException{
		exprString 		= e.toString();

		//Check whether it is a complex expression (e.g., and parse its component
		Expression e1 = e.getOperand1();
		Expression e2 = e.getOperand2();
		if (e1 instanceof ExpressionBinaryOp)
			e1.accept(v);
		if (e2 instanceof ExpressionBinaryOp)
			e2.accept(v);
		
		//if it is a si
		if (e1 instanceof ExpressionVar) {

//			e.setOperand1(new ExpressionVar(((ExpressionVar) e1).getName()+"s", e1.getType()));
//			e.setOperand2(new ExpressionLiteral(e2.getType(), "0"));
		}
		
		String varsToSearchStr = null;
		if (varList.isEmpty()) {
			varsToSearchStr = e1.toString();
			varList.add(e1.toString());
		}
		else
			varsToSearchStr = String.join(",", varList);

		org.mariuszgromada.math.mxparser.Function f = 
				new org.mariuszgromada.math.mxparser.Function("f("+varsToSearchStr+") = "+ exprString);
		
		List<Integer> indexes = new ArrayList<>();
		VarList varL = mdpModel.getVarList();
		for (String varName : varList) {
			int index = varL.getIndex(varName);
			if (index!=-1)
				indexes.add(index);
		}

		List<Integer> validStates = new ArrayList<Integer>();
		List<State> statesList = mdpModel.getStatesList();
		int numStates = statesList.size();
		for (int i = 0; i < numStates; i++) {
			String valuesIndexes = "";
			for (Integer j : indexes) {
				valuesIndexes += statesList.get(i).varValues[j] +",";
			}
			valuesIndexes = valuesIndexes.substring(0,valuesIndexes.length()-1);
			org.mariuszgromada.math.mxparser.Expression expr = 
					new org.mariuszgromada.math.mxparser.Expression ("f("+ valuesIndexes +")", f);

			if (expr.calculate()>=1.0)
				validStates.add(i);
		}
		

		StringBuilder sb = new StringBuilder();
		Iterator<Integer> it = validStates.iterator();
		while (it.hasNext()) {
			sb.append("x="+it.next());
			if (it.hasNext())
				sb.append("|");
		}
		
		return sb.toString();
	}
	
	class ExpressionBinaryOpVisitor extends ASTTraverse{

		public Object visit(ExpressionBinaryOp e) throws PrismLangException{
			Expression e1 = e.getOperand1();
			Expression e2 = e.getOperand2();
			if (e1 instanceof ExpressionBinaryOp)
				e1.accept(v);
			if (e2 instanceof ExpressionBinaryOp)
				e2.accept(v);
			if (e1 instanceof ExpressionVar) {
				varList.add(((ExpressionVar) e1).getName());
			}
			return null;
		}
	}
}
