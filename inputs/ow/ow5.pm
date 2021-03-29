// autonomy-excavate
// RASPBERRY-SI Planning model prototype for Ocean Worlds Autonomy Testbed
// Javier Camara, Univerity of York
// javier.camaramoreno@york.ac.uk

mdp


 // Number of excavation locations
 // Number of dump locations

// Parameters
const curLoc=0; // Current location of arm when planner is called (here we have a hardcoded value, but this will be provided to the planner)

// Special Locations
const locOrig=0;
const locNull=10+100; // Only auxiliary constants to define the range of variable loc

// Excavation Locations
const xloc1=1;
const xloc2=2;
const xloc3=3;
const xloc4=4;
const xloc5=5;

// Dump Locations
const dloc1=5;
const dloc2=6;
const dloc3=7;
const dloc4=8;
const dloc5=9;
const dloc6=10;


// Possible states of the mission (to keep track of progress)
const START=0;
const DONE_EXCAVATING=1;
const DONE_DUMPING=2;
const FAILED=100;

formula tried_all_xloc =  tried_xloc1 &  tried_xloc2 &  tried_xloc3 &  tried_xloc4 &  tried_xloc5 &  true; // Have we tried all excavation locations?
const int MAX_TRIED=2; // Maximum number of excavation attempts (can be 1 by default, number of excavation locations upper bound)

// Module that is in charge of selecting an excavation location
// It tries one location first, and if it does not succeed, it goes to the next one.
// If all locations have been tried and state is still START (unsuccessful excavation), it fails
module autonomy
	s:[START..FAILED] init START; // State of mission
	loc:[locOrig..locNull] init curLoc;
	tried:[0..MAX_TRIED] init 0; // Keeps track of excavation attempts

	
	tried_xloc1: bool init false;
	succ_xloc1: bool init false;
	tried_xloc2: bool init false;
	succ_xloc2: bool init false;
	tried_xloc3: bool init false;
	succ_xloc3: bool init false;
	tried_xloc4: bool init false;
	succ_xloc4: bool init false;
	tried_xloc5: bool init false;
	succ_xloc5: bool init false;

	// Excavation behavior
	// In the following commands, we have:
	// Command 1:
	// * A guard that checks: (1) that we are at the START of the mission
	// 			  (2) that we have not tried to excavate location A
	//			  (3) that the maximum number of excavation attempts has not been reached
	// * An update with probability ex_locA (excavatability of excavation location A) that:
	//			  (1) updates the variable saying that we have tried location A (not needed but left for clarity)
	// 			  (2) updates the variable that keeps track of excavation attempts
	//			  (3) updates the arm location variable to location A
	//            (4) updates the variable for excavation success in the current location to true	
	// * Another update with probability 1-ex_locA that:
	//			  (1) updates the variable saying that we have tried location A
	//			  (2) updates the arm location variable to location A (even if we have not succeeded excavating)
	// 			  (3) updates the variable that keeps track of excavation attempts
	// Command 2:
	// * A guard that checks: (1) that there is success in the current excavation location
	// * An update that: (1) sets the excavation success back to false
   	//			         (2) updates the state to successful excavation (DONE_EXCAVATING)

	
	[try_xloc1] (s=START) & (!tried_xloc1) & (tried<MAX_TRIED) -> ex_loc1: (s'=DONE_EXCAVATING) & (tried_xloc1'=true) &  (tried'=tried+1)  & (loc'=xloc1) & (succ_xloc1'=true) 
				  	       + (1-ex_loc1): (tried_xloc1'=true) &  (tried'=tried+1) & (loc'=xloc1);
	[select_xloc1] (succ_xloc1) -> (succ_xloc1'=false) & (s'=DONE_EXCAVATING);
	[try_xloc2] (s=START) & (!tried_xloc2) & (tried<MAX_TRIED) -> ex_loc2: (s'=DONE_EXCAVATING) & (tried_xloc2'=true) &  (tried'=tried+1)  & (loc'=xloc2) & (succ_xloc2'=true) 
				  	       + (1-ex_loc2): (tried_xloc2'=true) &  (tried'=tried+1) & (loc'=xloc2);
	[select_xloc2] (succ_xloc2) -> (succ_xloc2'=false) & (s'=DONE_EXCAVATING);
	[try_xloc3] (s=START) & (!tried_xloc3) & (tried<MAX_TRIED) -> ex_loc3: (s'=DONE_EXCAVATING) & (tried_xloc3'=true) &  (tried'=tried+1)  & (loc'=xloc3) & (succ_xloc3'=true) 
				  	       + (1-ex_loc3): (tried_xloc3'=true) &  (tried'=tried+1) & (loc'=xloc3);
	[select_xloc3] (succ_xloc3) -> (succ_xloc3'=false) & (s'=DONE_EXCAVATING);
	[try_xloc4] (s=START) & (!tried_xloc4) & (tried<MAX_TRIED) -> ex_loc4: (s'=DONE_EXCAVATING) & (tried_xloc4'=true) &  (tried'=tried+1)  & (loc'=xloc4) & (succ_xloc4'=true) 
				  	       + (1-ex_loc4): (tried_xloc4'=true) &  (tried'=tried+1) & (loc'=xloc4);
	[select_xloc4] (succ_xloc4) -> (succ_xloc4'=false) & (s'=DONE_EXCAVATING);
	[try_xloc5] (s=START) & (!tried_xloc5) & (tried<MAX_TRIED) -> ex_loc5: (s'=DONE_EXCAVATING) & (tried_xloc5'=true) &  (tried'=tried+1)  & (loc'=xloc5) & (succ_xloc5'=true) 
				  	       + (1-ex_loc5): (tried_xloc5'=true) &  (tried'=tried+1) & (loc'=xloc5);
	[select_xloc5] (succ_xloc5) -> (succ_xloc5'=false) & (s'=DONE_EXCAVATING);

	
	// If all excavation locations have been tried (or maximum number of excavation attempts has been reached) and state is not DONE_EXCAVATING, mission fails
	[] (s=START) & (tried_all_xloc | tried>= MAX_TRIED) -> (s'=FAILED); 

	// Dump behavior
	// These commands just update the state to DONE_DUMPING (no probability of failure), and update arm location

	[select_dloc1] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc1);
	[select_dloc2] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc2);
	[select_dloc3] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc3);
	[select_dloc4] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc4);
	[select_dloc5] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc5);


endmodule


// stopping condition label for PCTL formula checking
label "done" = (s=DONE_DUMPING);



// Script-generated rewards and constants start here


// Science value reward
// The estimated science value for the different excavation locations has to be provided by a different model
rewards "SV"
	[select_xloc1] true: 0.541412472793;
	[select_xloc2] true: 0.939149162779;
	[select_xloc3] true: 0.381204237688;
	[select_xloc4] true: 0.216599397131;
	[select_xloc5] true: 0.422116575583;
endrewards

// Energy consumption cost
// The values for the energy costs have to be provided by a different model
// the reward structure below considers both the cost of excavation and moving to the arm to a location
// the cost of excavation is fixed, but the cost of movement from another location varies, depending on the
// original location of the arm (there is one line of the reward structure per alternative original location
// NOTE: cost of moving the arm A->B and B<-A are the same here, but these costs might be different due to different
// trajectories computed by lower-level control
rewards "EC"
	[select_xloc1] loc=xloc2 :3.03734527162;
	[select_xloc1] loc=xloc3 :4.01297210127;
	[select_xloc1] loc=xloc4 :4.58613332359;
	[select_xloc1] loc=xloc5 :2.06414268466;
	[select_dloc1] loc=xloc1 :3.94491224017;
	[select_dloc1] loc=xloc2 :2.51731330661;
	[select_dloc1] loc=xloc3 :3.20226951621;
	[select_dloc1] loc=xloc4 :2.33886431395;
	[select_dloc1] loc=xloc5 :4.45230475207;
	[select_xloc2] loc=xloc1 :3.03734527162;
	[select_xloc2] loc=xloc3 :3.30492341939;
	[select_xloc2] loc=xloc4 :3.4361537455;
	[select_xloc2] loc=xloc5 :3.67234956419;
	[select_dloc2] loc=xloc1 :3.63032196506;
	[select_dloc2] loc=xloc2 :4.0286872969;
	[select_dloc2] loc=xloc3 :5.21083871793;
	[select_dloc2] loc=xloc4 :4.53466882575;
	[select_dloc2] loc=xloc5 :4.1761133357;
	[select_xloc3] loc=xloc1 :4.01297210127;
	[select_xloc3] loc=xloc2 :3.30492341939;
	[select_xloc3] loc=xloc4 :2.74379550805;
	[select_xloc3] loc=xloc5 :4.21484164523;
	[select_dloc3] loc=xloc1 :2.74050361063;
	[select_dloc3] loc=xloc2 :1.5142081304;
	[select_dloc3] loc=xloc3 :2.93763383454;
	[select_dloc3] loc=xloc4 :3.67726240862;
	[select_dloc3] loc=xloc5 :3.43089566477;
	[select_xloc4] loc=xloc1 :4.58613332359;
	[select_xloc4] loc=xloc2 :3.4361537455;
	[select_xloc4] loc=xloc3 :2.74379550805;
	[select_xloc4] loc=xloc5 :5.02924486224;
	[select_dloc4] loc=xloc1 :3.45710609665;
	[select_dloc4] loc=xloc2 :3.5473178342;
	[select_dloc4] loc=xloc3 :4.84829687879;
	[select_dloc4] loc=xloc4 :4.1129507461;
	[select_dloc4] loc=xloc5 :4.02644602424;
	[select_xloc5] loc=xloc1 :2.06414268466;
	[select_xloc5] loc=xloc2 :3.67234956419;
	[select_xloc5] loc=xloc3 :4.21484164523;
	[select_xloc5] loc=xloc4 :5.02924486224;
	[select_dloc5] loc=xloc1 :5.30185711796;
	[select_dloc5] loc=xloc2 :4.34559807165;
	[select_dloc5] loc=xloc3 :3.83114849986;
	[select_dloc5] loc=xloc4 :2.84395500016;
	[select_dloc5] loc=xloc5 :5.68949680745;
endrewards
rewards "T"
	[select_xloc1] loc=xloc2 :0.656475979954;
	[select_xloc1] loc=xloc3 :0.867342879101;
	[select_xloc1] loc=xloc4 :0.991222959055;
	[select_xloc1] loc=xloc5 :0.446133043991;
	[select_dloc1] loc=xloc1 :0.852632775372;
	[select_dloc1] loc=xloc2 :0.544078980831;
	[select_dloc1] loc=xloc3 :0.692121846792;
	[select_dloc1] loc=xloc4 :0.505509945421;
	[select_dloc1] loc=xloc5 :0.962297948964;
	[select_xloc2] loc=xloc1 :0.656475979954;
	[select_xloc2] loc=xloc3 :0.714308926513;
	[select_xloc2] loc=xloc4 :0.742672365382;
	[select_xloc2] loc=xloc5 :0.793722498861;
	[select_dloc2] loc=xloc1 :0.784638872582;
	[select_dloc2] loc=xloc2 :0.870739479597;
	[select_dloc2] loc=xloc3 :1.12624352776;
	[select_dloc2] loc=xloc4 :0.980099690665;
	[select_dloc2] loc=xloc5 :0.902603375413;
	[select_xloc3] loc=xloc1 :0.867342879101;
	[select_xloc3] loc=xloc2 :0.714308926513;
	[select_xloc3] loc=xloc4 :0.593029663691;
	[select_xloc3] loc=xloc5 :0.910973910428;
	[select_dloc3] loc=xloc1 :0.592318170137;
	[select_dloc3] loc=xloc2 :0.327273055043;
	[select_dloc3] loc=xloc3 :0.634924869523;
	[select_dloc3] loc=xloc4 :0.794784335454;
	[select_dloc3] loc=xloc5 :0.741535911211;
	[select_xloc4] loc=xloc1 :0.991222959055;
	[select_xloc4] loc=xloc2 :0.742672365382;
	[select_xloc4] loc=xloc3 :0.593029663691;
	[select_xloc4] loc=xloc5 :1.08699477805;
	[select_dloc4] loc=xloc1 :0.74720089738;
	[select_dloc4] loc=xloc2 :0.766698792258;
	[select_dloc4] loc=xloc3 :1.04788562379;
	[select_dloc4] loc=xloc4 :0.888951742426;
	[select_dloc4] loc=xloc5 :0.870255062603;
	[select_xloc5] loc=xloc1 :0.446133043991;
	[select_xloc5] loc=xloc2 :0.793722498861;
	[select_xloc5] loc=xloc3 :0.910973910428;
	[select_xloc5] loc=xloc4 :1.08699477805;
	[select_dloc5] loc=xloc1 :1.14591577047;
	[select_dloc5] loc=xloc2 :0.939234923086;
	[select_dloc5] loc=xloc3 :0.828044473343;
	[select_dloc5] loc=xloc4 :0.614677614404;
	[select_dloc5] loc=xloc5 :1.22969819303;
endrewards

// Excavatability probabilities for excavation locations
const double ex_loc1=0.458587527207;
const double ex_loc2=0.0608508372215;
const double ex_loc3=0.618795762312;
const double ex_loc4=0.783400602869;
const double ex_loc5=0.577883424417;
