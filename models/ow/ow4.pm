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
const locNull=8+100; // Only auxiliary constants to define the range of variable loc

// Excavation Locations
const xloc1=1;
const xloc2=2;
const xloc3=3;
const xloc4=4;

// Dump Locations
const dloc1=4;
const dloc2=5;
const dloc3=6;
const dloc4=7;
const dloc5=8;


// Possible states of the mission (to keep track of progress)
const START=0;
const DONE_EXCAVATING=1;
const DONE_DUMPING=2;
const FAILED=100;

formula tried_all_xloc =  tried_xloc1 &  tried_xloc2 &  tried_xloc3 &  tried_xloc4 &  true; // Have we tried all excavation locations?
const int MAX_TRIED=3; // Maximum number of excavation attempts (can be 1 by default, number of excavation locations upper bound)

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

	
	// If all excavation locations have been tried (or maximum number of excavation attempts has been reached) and state is not DONE_EXCAVATING, mission fails
	[] (s=START) & (tried_all_xloc | tried>= MAX_TRIED) -> (s'=FAILED); 

	// Dump behavior
	// These commands just update the state to DONE_DUMPING (no probability of failure), and update arm location

	[select_dloc1] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc1);
	[select_dloc2] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc2);
	[select_dloc3] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc3);
	[select_dloc4] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc4);


endmodule


// stopping condition label for PCTL formula checking
label "done" = (s=DONE_DUMPING);



// Script-generated rewards and constants start here


// Science value reward
// The estimated science value for the different excavation locations has to be provided by a different model
rewards "SV"
	[select_xloc1] true: 0.945270695554;
	[select_xloc2] true: 0.901427457611;
	[select_xloc3] true: 0.0305899830336;
	[select_xloc4] true: 0.0254458609935;
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
	[select_dloc1] loc=xloc1 :3.94491224017;
	[select_dloc1] loc=xloc2 :2.51731330661;
	[select_dloc1] loc=xloc3 :3.20226951621;
	[select_dloc1] loc=xloc4 :2.33886431395;
	[select_xloc2] loc=xloc1 :3.03734527162;
	[select_xloc2] loc=xloc3 :3.30492341939;
	[select_xloc2] loc=xloc4 :3.4361537455;
	[select_dloc2] loc=xloc1 :3.63032196506;
	[select_dloc2] loc=xloc2 :4.0286872969;
	[select_dloc2] loc=xloc3 :5.21083871793;
	[select_dloc2] loc=xloc4 :4.53466882575;
	[select_xloc3] loc=xloc1 :4.01297210127;
	[select_xloc3] loc=xloc2 :3.30492341939;
	[select_xloc3] loc=xloc4 :2.74379550805;
	[select_dloc3] loc=xloc1 :2.74050361063;
	[select_dloc3] loc=xloc2 :1.5142081304;
	[select_dloc3] loc=xloc3 :2.93763383454;
	[select_dloc3] loc=xloc4 :3.67726240862;
	[select_xloc4] loc=xloc1 :4.58613332359;
	[select_xloc4] loc=xloc2 :3.4361537455;
	[select_xloc4] loc=xloc3 :2.74379550805;
	[select_dloc4] loc=xloc1 :3.45710609665;
	[select_dloc4] loc=xloc2 :3.5473178342;
	[select_dloc4] loc=xloc3 :4.84829687879;
	[select_dloc4] loc=xloc4 :4.1129507461;
endrewards
rewards "T"
	[select_xloc1] loc=xloc2 :12.238796304;
	[select_xloc1] loc=xloc3 :16.1700247186;
	[select_xloc1] loc=xloc4 :18.4795426766;
	[select_dloc1] loc=xloc1 :15.8957816867;
	[select_dloc1] loc=xloc2 :10.1433594267;
	[select_dloc1] loc=xloc3 :12.9033484226;
	[select_dloc1] loc=xloc4 :9.42431016605;
	[select_xloc2] loc=xloc1 :12.238796304;
	[select_xloc2] loc=xloc3 :13.3169860234;
	[select_xloc2] loc=xloc4 :13.845770566;
	[select_dloc2] loc=xloc1 :14.6281594864;
	[select_dloc2] loc=xloc2 :16.2333481347;
	[select_dloc2] loc=xloc3 :20.9967547113;
	[select_dloc2] loc=xloc4 :18.2721696421;
	[select_xloc3] loc=xloc1 :16.1700247186;
	[select_xloc3] loc=xloc2 :13.3169860234;
	[select_xloc3] loc=xloc4 :11.0559555532;
	[select_dloc3] loc=xloc1 :11.0426910547;
	[select_dloc3] loc=xloc2 :6.10140870156;
	[select_dloc3] loc=xloc3 :11.8370151898;
	[select_dloc3] loc=xloc4 :14.8173031219;
	[select_xloc4] loc=xloc1 :18.4795426766;
	[select_xloc4] loc=xloc2 :13.845770566;
	[select_xloc4] loc=xloc3 :11.0559555532;
	[select_dloc4] loc=xloc1 :13.9301967786;
	[select_dloc4] loc=xloc2 :14.2936994368;
	[select_dloc4] loc=xloc3 :19.5359146276;
	[select_dloc4] loc=xloc4 :16.5728825301;
endrewards

// Excavatability probabilities for excavation locations
const double ex_loc1=0.0547293044461;
const double ex_loc2=0.0985725423885;
const double ex_loc3=0.969410016966;
const double ex_loc4=0.974554139007;
