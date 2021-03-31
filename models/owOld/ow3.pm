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
const locNull=6+100; // Only auxiliary constants to define the range of variable loc

// Excavation Locations
const xloc1=1;
const xloc2=2;
const xloc3=3;

// Dump Locations
const dloc1=3;
const dloc2=4;
const dloc3=5;
const dloc4=6;


// Possible states of the mission (to keep track of progress)
const START=0;
const DONE_EXCAVATING=1;
const DONE_DUMPING=2;
const FAILED=100;

formula tried_all_xloc =  tried_xloc1 &  tried_xloc2 &  tried_xloc3 &  true; // Have we tried all excavation locations?

// Module that is in charge of selecting an excavation location
// It tries one location first, and if it does not succeed, it goes to the next one.
// If all locations have been tried and state is still START (unsuccessful excavation), it fails
module autonomy
	s:[START..FAILED] init START; // State of mission
	loc:[locOrig..locNull] init curLoc;
	
	tried_xloc1: bool init false;
	tried_xloc2: bool init false;
	tried_xloc3: bool init false;

	// Excavation behavior
	// In the following command, we have:
	// * A guard that checks: (1) that we are at the START of the mission
	// 			  (2) that we have not tried to excavate location A
	// * An update with probability ex_locA (excavatability of excavation location A) that:
	//			  (1) updates the state to successful excavation (DONE_EXCAVATING)
	//			  (2) updates the variable saying that we have tried location A (not needed but left for clarity)
	//			  (3) updates the arm location variable to location A	
	// * Another update with probability 1-ex_locA that:
	//			  (1) updates the variable saying that we have tried location A
	//			  (2) updates the arm location variable to location A (even if we have not succeeded excavating)
	
	[select_xloc1] (s=START) & (!tried_xloc1) -> ex_loc1: (s'=DONE_EXCAVATING) & (tried_xloc1'=true) & (loc'=xloc1) 
				  	       + (1-ex_loc1): (tried_xloc1'=true) & (loc'=xloc1);
	[select_xloc2] (s=START) & (!tried_xloc2) -> ex_loc2: (s'=DONE_EXCAVATING) & (tried_xloc2'=true) & (loc'=xloc2) 
				  	       + (1-ex_loc2): (tried_xloc2'=true) & (loc'=xloc2);
	[select_xloc3] (s=START) & (!tried_xloc3) -> ex_loc3: (s'=DONE_EXCAVATING) & (tried_xloc3'=true) & (loc'=xloc3) 
				  	       + (1-ex_loc3): (tried_xloc3'=true) & (loc'=xloc3);

	
	// If all excavation locations have been tried and state is not DONE_EXCAVATING, mission fails
	[] (s=START) & (tried_all_xloc) -> (s'=FAILED);

	// Dump behavior
	// These commands just update the state to DONE_DUMPING (no probability of failure), and update arm location

	[select_dloc1] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc1);
	[select_dloc2] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc2);
	[select_dloc3] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc3);


endmodule


// stopping condition label for PCTL formula checking
label "done" = (s=DONE_DUMPING);



// Script-generated rewards and constants start here


// Science value reward
// The estimated science value for the different excavation locations has to be provided by a different model
rewards "SV"
	[select_xloc1] true: 0.00210605335111;
	[select_xloc2] true: 0.445387194055;
	[select_xloc3] true: 0.721540032341;
endrewards

// Energy consumption cost
// The values for the energy costs have to be provided by a different model
// the reward structure below considers both the cost of excavation and moving to the arm to a location
// the cost of excavation is fixed, but the cost of movement from another location varies, depending on the
// original location of the arm (there is one line of the reward structure per alternative original location
// NOTE: cost of moving the arm A->B and B<-A are the same here, but these costs might be different due to different
// trajectories computed by lower-level control
rewards "EC"
	[select_xloc1] loc=2 :3.03734527162;
	[select_xloc1] loc=3 :4.01297210127;
	[select_dloc1] loc=1 :3.94491224017;
	[select_dloc1] loc=2 :2.51731330661;
	[select_dloc1] loc=3 :3.20226951621;
	[select_xloc2] loc=1 :3.03734527162;
	[select_xloc2] loc=3 :3.30492341939;
	[select_dloc2] loc=1 :3.63032196506;
	[select_dloc2] loc=2 :4.0286872969;
	[select_dloc2] loc=3 :5.21083871793;
	[select_xloc3] loc=1 :4.01297210127;
	[select_xloc3] loc=3 :3.30492341939;
	[select_dloc3] loc=1 :2.74050361063;
	[select_dloc3] loc=2 :1.5142081304;
	[select_dloc3] loc=3 :2.93763383454;
endrewards

// Excavatability probabilities for excavation locations
const double ex_loc1=0.997893946649;
const double ex_loc2=0.554612805945;
const double ex_loc3=0.278459967659;
