//FOREX dtmc model (Simplified: 4 operations with 3 services for each operation)
mdp

//Evoxxx defined params
//Which services are enabled
//evolve int op1Code [1..7]; //possible combinations for services implementing operation 1
const int op1Code = 7;
//evolve int op2Code [1..7]; //possible combinations for services implementing operation 2
const int op2Code = 7;

//Sequence of service execution
//evolve int seqOp1  [1..6]; //(#services op1)!
//const int seqOp1 = 1;
//evolve int seqOp2  [1..6]; //(#services op2)!
//const int seqOp2 = 1;

//distribution for probabilistic selection
//evolve distribution probOp1 [3];
const double probOp11 = 0.4;
const double probOp12 = 0.4;
const double probOp13 = 0.2;
//evolve distribution probOp2 [3];
const double probOp21 = 0.4;
const double probOp22 = 0.4;
const double probOp23 = 0.2;


//flag indicating whether a service is selected or not (will be assembled based on the chromosome value)
formula op1S1 = mod(op1Code,2)>0?1:0;
//const int 
formula op1S2 = mod(op1Code,4)>1?1:0;
formula op1S3 = mod(op1Code,8)>3?1:0;
const int op2S1 = mod(op2Code,2)>0?1:0;
const int op2S2 = mod(op2Code,4)>1?1:0;
const int op2S3 = mod(op2Code,8)>3?1:0;

// // user-defined params parameters
const double op1S1Fail=0.011; //failure probability of service 1 op1
const double op1S2Fail=0.004; //failure probability of service 2 op1
const double op1S3Fail=0.007; //failure probability of service 3 op1

const double op2S1Fail=0.003; //failure probability of service 1 op1
const double op2S2Fail=0.005; //failure probability of service 2 op1
const double op2S3Fail=0.006; //failure probability of service 3 op1

const double op4S1Fail=0.009; //failure probability of service 1 op1
const double op4S2Fail=0.011; //failure probability of service 2 op1
const double op4S3Fail=0.006; //failure probability of service 3 op1

const double op5S1Fail=0.005; //failure probability of service 1 op1
const double op5S2Fail=0.004; //failure probability of service 2 op1
const double op5S3Fail=0.002; //failure probability of service 3 op1


const int STEPMAX  = 4;

/////////////
//Workflow
/////////////
module forex
	//local state
	state : [0..17] init 0;
	srv1  : [0..2]  init 0;
	srv2  : [0..2]  init 0;
	seqOp1:  [0..6] init 0;
	//seqOp2:  [0..6] init 0;


	//Init
	[fxStart]	state = 0 	->	0.66 : (state'=1) + 0.34 : (state'=9);

	//Op1: Market watch
	[selectOp11]		state = 1	->	1.0  : (state'=16) & (srv1'=1);  //invoke op1
	[selectOp12]		state = 1	->	1.0  : (state'=2) & (srv1'=2);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=1);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=2);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=3);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=4);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=5);  //invoke op1
	[]				state = 16	->	1.0  : (state'=2) & (seqOp1'=6);  //invoke op1
	[endOp1Fail1]	state = 2 	->	1.0  : (state'=5) & (srv1'=0);	//failed op1
	[endOp1Succ1] 	state = 2	->	1.0  : (state'=3) & (srv1'=0) & (seqOp1'=0);  	//succ   op1
	[endOp1Fail2]	state = 2 	->	1.0  : (state'=5) & (srv1'=0);	//failed op1
	[endOp1Succ2] 	state = 2	->	1.0  : (state'=3) & (srv1'=0) & (seqOp1'=0);  	//succ   op1

	//Op2: Technical Analysis
	[selectOp21]		state = 3	->	1.0  : (state'=17) & (srv2'=1);	//invoke op2
	[selectOp22]		state = 3	->	1.0  : (state'=4) & (srv2'=2);	//invoke op2
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=1);  //invoke op1
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=2);  //invoke op1
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=3);  //invoke op1
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=4);  //invoke op1
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=5);  //invoke op1
	[]				state = 17	->	1.0  : (state'=4) & (seqOp1'=6);  //invoke op1
	[endOp2Fail1]	state = 4   ->	1.0  : (state'=5) & (srv2'=0);	//failed op2
	[endOp2Succ1] 	state = 4	->	1.0  : (state'=6) & (srv2'=0);  	//succ   op2
	[endOp2Fail2]	state = 4   ->	1.0  : (state'=5) & (srv2'=0);	//failed op2
	[endOp2Succ2] 	state = 4	->	1.0  : (state'=6) & (srv2'=0);  	//succ   op2


	//Technical analysis result
	[taResult]		state=6 	->	0.61 : (state'=1) & (srv1'=0) & (srv2'=0) & (seqOp1'=0)+ 0.28 : (state'=11) + 0.11 : (state'=7);

	//Op3: Alarm
	[startOp3]		state=7		->	1.0  : (state'=8);
	[endOp3Fail]	state=8		->	1.0  : (state'=5);
	[endOp3Succ]	state=8		->	1.0  : (state'=13);

	//Op4: Fundamental Analysis
	[startOp4]		state=9		-> 	1.0  : (state'=10);
	[endOp4Fail]	state = 10 	->	1.0  : (state'=5);	//failed op4
	[endOp4Succ]	state=10	->	0.53  : (state'=0) + 0.27 : (state'=11) + 0.20 : (state'=9); //succ op4

	//Op5: Place Order
	[startOp5]		state=11	->	1.0  : (state'=12);
	[endOp5Fail]	state = 12 	->	1.0  : (state'=5);	//failed op2
	[endOp5Succ]	state=12	->	1.0  : (state'=13);

	//Op6: Notify trader
	[startOp6]		state=13	->	1.0  : (state'=14);
	[endOp6Fail]	state=14	->	1.0  : (state'=5);
	[endOp6Succ]	state=14	->	1.0  : (state'=15);

	//End
	[fxFail]		state = 5	->	1.0  : (state'=5);	//failed fx
	[fxSucc]		state = 15	->	1.0  : (state'=0) & (srv1'=0) & (srv2'=0) & (seqOp1'=0);	//succ   fx
endmodule


/////////////
//Operation 1: Market watch
/////////////

//SEQ
module strategyOp11
	operation11 : [0..7] init 0;
	stepOp1	 : [1..4] init 1;

	[]	operation11=0 & srv1=1 & seqOp1>0	-> 1.0 : (operation11'=1);


	[]	operation11 = 1 & stepOp1=1 & seqOp1>0	-> ((seqOp1=1 | seqOp1=2)? 1 : 0) : (operation11'=2) +
                                           ((seqOp1=3 | seqOp1=4)? 1 : 0) : (operation11'=3) +
                                           ((seqOp1=5 | seqOp1=6)? 1 : 0) : (operation11'=4) ;

	[]	operation11=1 & stepOp1=2 & seqOp1>0	-> ((seqOp1=3 | seqOp1=5)? 1 : 0) : (operation11'=2) +
                                           ((seqOp1=1 | seqOp1=6)? 1 : 0) : (operation11'=3) +
                                           ((seqOp1=2 | seqOp1=4)? 1 : 0) : (operation11'=4) ;

	[]	operation11=1 & stepOp1=3 & seqOp1>0 -> ((seqOp1=4 | seqOp1=6)? 1 : 0) : (operation11'=2) +
                                           ((seqOp1=2 | seqOp1=5)? 1 : 0) : (operation11'=3) +
                                           ((seqOp1=1 | seqOp1=3)? 1 : 0) : (operation11'=4) ;

	[]	operation11 = 1 & stepOp1 > 3 -> 1.0 : (operation11'=5);

	[]	operation11 = 2	-> (op1S1=1?1.0:0)*(1-op1S1Fail) : (operation11'=6) + (op1S1=0?1.0:op1S1Fail) : (operation11'=1) & (stepOp1'=min(STEPMAX,stepOp1+1));
	[]	operation11 = 3	-> (op1S2=1?1.0:0)*(1-op1S2Fail) : (operation11'=6) + (op1S2=0?1.0:op1S2Fail) : (operation11'=1) & (stepOp1'=min(STEPMAX,stepOp1+1));
	[]	operation11 = 4	-> (op1S3=1?1.0:0)*(1-op1S3Fail) : (operation11'=6) + (op1S3=0?1.0:op1S3Fail) : (operation11'=1) & (stepOp1'=min(STEPMAX,stepOp1+1));	

	[endOp1Fail1]	operation11 = 5	->	1.0 : (operation11'=0);//failed
	[endOp1Succ1]	operation11 = 6	->	1.0 : (operation11'=0); //succ
endmodule


//PROB
module strategyOp12
	operation12 : [0..8] init 0;

	//select a service probabilistically
	[] 	operation12 = 0 & (srv1=2) & seqOp1=0	 	->	probOp11 : (operation12'=1) + probOp12 : (operation12'=5) + probOp13 : (operation12'=6); 

	[]	operation12 = 1	->	(1) : (operation12'=2);// + (1-op1S1) : (operation12'=7); //service1 start
	[]     	operation12 = 2  ->	1-op1S1Fail : (operation12'=8) + op1S1Fail : (operation12'=7); 		

	[]	operation12 = 5	->	(1) : (operation12'=3);// + (1-op1S2) : (operation12'=7); //service1 start
	[]     	operation12 = 3  ->	1-op1S2Fail : (operation12'=8) + op1S2Fail : (operation12'=7); 		

	[]	operation12 = 6	->	(1) : (operation12'=4);// + (1-op1S3) : (operation12'=7); //service1 start
	[]     	operation12 = 4  ->	1-op1S3Fail : (operation12'=8) + op1S3Fail : (operation12'=7); 		

	[endOp1Fail2]	operation12 = 7	->	1.0 : (operation12'=0);//failed
	[endOp1Succ2]	operation12 = 8	->	1.0 : (operation12'=0); //succ
endmodule


/////////////
//Operation 2: Technical Analysis
/////////////


//SEQ
module strategyOp21
	operation21 : [0..6] init 0;
	stepOp2	 : [1..4] init 1;

	[]	operation21=0 & (srv2=1)& seqOp1>0				-> 1.0 : (operation21'=1);

	[]	operation21=1 & stepOp2=1 & seqOp1>0 	-> ((seqOp1=1 | seqOp1=2)? 1 : 0) : (operation21'=2) +
                                           	   	   ((seqOp1=3 | seqOp1=4)? 1 : 0) : (operation21'=3) +
                                           	   	   ((seqOp1=5 | seqOp1=6)? 1 : 0) : (operation21'=4) ;

	[]	operation21=1 & stepOp2=2 & seqOp1>0	-> ((seqOp1=3 | seqOp1=5)? 1 : 0) : (operation21'=2) +
                                           	   	   ((seqOp1=1 | seqOp1=6)? 1 : 0) : (operation21'=3) +
                                           	   	   ((seqOp1=2 | seqOp1=4)? 1 : 0) : (operation21'=4) ;

	[]	operation21=1 & stepOp2=3 & seqOp1>0	-> ((seqOp1=4 | seqOp1=6)? 1 : 0) : (operation21'=2) +
                                           	   	   ((seqOp1=2 | seqOp1=5)? 1 : 0) : (operation21'=3) +
                                           	   	   ((seqOp1=1 | seqOp1=3)? 1 : 0) : (operation21'=4) ;
	[]	operation21=1 & stepOp2>3 -> 1.0 : (operation21'=5);

	[]	operation21 = 2		-> (op2S1=1?1.0:0)*(1-op2S1Fail) : (operation21'=6) + (op2S1=0?1.0:op2S1Fail) : (operation21'=1) & (stepOp2'=min(STEPMAX,stepOp2+1));
	[]	operation21 = 3		-> (op2S2=1?1.0:0)*(1-op2S2Fail) : (operation21'=6) + (op2S2=0?1.0:op2S2Fail) : (operation21'=1) & (stepOp2'=min(STEPMAX,stepOp2+1));
	[]	operation21 = 4		-> (op2S3=1?1.0:0)*(1-op2S3Fail) : (operation21'=6) + (op2S3=0?1.0:op2S3Fail) : (operation21'=1) & (stepOp2'=min(STEPMAX,stepOp2+1));	

	[endOp2Fail1]	operation21 = 5		->	1.0 : (operation21'=0);//failed
	[endOp2Succ1]	operation21 = 6		->	1.0 : (operation21'=0); //succ
endmodule



//PROB
module strategyOp2 
	operation22 : [0..8] init 0;

	//select a service probabilistically
	[] 	operation22=0 & (srv2=2)& seqOp1=0	 	->	probOp21 : (operation22'=1) + probOp22 : (operation22'=5) + probOp23 : (operation22'=6); 

	[]	operation22 = 1	->	(1) : (operation22'=2);// + (1-op2S1) : (operation22'=7); //service1 start
	[]     	operation22 = 2  ->	1-op2S1Fail : (operation22'=8) + op2S1Fail : (operation22'=7); 		

	[]	operation22 = 5	->	(1) : (operation22'=3);// + (1-op2S2) : (operation22'=7); //service1 start
	[]     	operation22 = 3  ->	1-op2S2Fail : (operation22'=8) + op2S2Fail : (operation22'=7); 		

	[]	operation22 = 6	->	(1) : (operation22'=4);// + (1-op2S3) : (operation22'=7); //service1 start
	[]     	operation22 = 4  ->	1-op2S3Fail : (operation22'=8) + op2S3Fail : (operation22'=7); 		

	[endOp2Fail2]	operation22 = 7	->	1.0 : (operation22'=0);//failed
	[endOp2Succ2]	operation22 = 8	->	1.0 : (operation22'=0); //succ
endmodule



/////////////
//Operation 3: Alarm
/////////////

//PROB
module strategyOp3
	operation3 : [0..2] init 0;

	//select a service probabilistically
	[startOp3] 	operation3 = 0 	->	0.00001 : (operation3'=1) + 0.99999 : (operation3'=2);

	[endOp3Fail]	operation3 = 1	->	1.0 : (operation3'=0);//failed
	[endOp3Succ]	operation3 = 2	->	1.0 : (operation3'=0); //succ
endmodule





/////////////
//Operation 4: Fundamental Analysis
/////////////

//PROB
module strategyOp4
	operation4 : [0..2] init 0;

	//select a service probabilistically
	[startOp4] 	operation4 = 0 	->	0.00001 : (operation4'=1) + 0.99999 : (operation4'=2);

	[endOp4Fail]	operation4 = 1	->	1.0 : (operation4'=0);//failed
	[endOp4Succ]	operation4 = 2	->	1.0 : (operation4'=0); //succ
endmodule






/////////////
//Operation 5: 
/////////////

//PROB
module strategyOp5
	operation5 : [0..2] init 0;

	//select a service probabilistically
	[startOp5] 	operation5 = 0 	->	0.00001 : (operation5'=1) + 0.99999 : (operation5'=2);

	[endOp5Fail]	operation5 = 1	->	1.0 : (operation5'=0);//failed
	[endOp5Succ]	operation5 = 2	->	1.0 : (operation5'=0); //succ
endmodule



/////////////
//Operation 6: Notify trader
/////////////

//PROB
module strategyOp6
	operation6 : [0..2] init 0;

	//select a service probabilistically
	[startOp6] 		operation6 = 0 	->	0.00001 : (operation6'=1) + 0.99999 : (operation6'=2); 

	[endOp6Fail]	operation6 = 1	->	1.0 : (operation6'=0);//failed
	[endOp6Succ]	operation6 = 2	->	1.0 : (operation6'=0); //succ
endmodule



rewards "cost"
	//OP1: SEQ
	operation11 = 2 : 3  *op1S1;
	operation11 = 3 : 15 *op1S2;
	operation11 = 4 : 8  *op1S3;
	//OP1: PROB
	operation12 = 2 : 3;
	operation12 = 3 : 15;
	operation12 = 4 : 8;
	//OP1: PAR cost
	// operation1 = 1 & STRATEGYOP1=0 : 20 * op1S1 + 15 * op1S2 + 50 * op1S3;
	
	//OP2: SEQ
	operation21 = 2 : 13 *op2S1;
	operation21 = 3 : 6  *op2S2;
	operation21 = 4 : 4  *op2S3;
	//OP2: ROB
	operation22 = 2 : 13  ;
	operation22 = 3 : 6 ;
	operation22 = 4 : 4 ;
	//OP2: PAR cost
	// operation2 = 1 & STRATEGYOP2=0 : 3 * op2S1 + 25 * op2S2 + 15 * op2S3;

	//OP3: 
	operation3 = 1 | operation3 = 2: 7;

	//OP4: 
	operation4 = 1 | operation4 = 2: 3.8;

	//OP5: 
	operation5 = 1 | operation5 = 2: 5;

	//OP6: 
	operation6 = 1 | operation6 = 2: 11;

endrewards


////////////
//Rewards
////////////
rewards "time"
	//OP1: SEQ
	operation11 = 2 : 2.5 *op1S1;
	operation11 = 3 : 1.8 *op1S2;
	operation11 = 4 : 2.1 *op1S3;
	//OP1: PROB
	operation12 = 2 : 2.5;
	operation12 = 3 : 1.8;
	operation12 = 4 : 2.1;

	//OP2: SEQ
	operation21 = 2 : 2.2 *op2S1;
	operation21 = 3 : 3.2 *op2S2;
	operation21 = 4 : 3.8 *op2S3;
	//OP2: ROB
	operation22 = 2 : 2.2 ;
	operation22 = 3 : 3.2 ;
	operation22 = 4 : 3.8 ;

	//OP3
	operation3 = 1 | operation3 = 2 : 1.5 ;

	//OP4
	operation4 = 1 | operation4 = 2 : 3.7;

	//OP5
	operation5 = 1 | operation5 = 2 : 4.1 ;

	//OP6
	operation6 = 1 | operation6 = 2 : 2.5 ;
endrewards



