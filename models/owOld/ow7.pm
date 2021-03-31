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
const locNull=14+100; // Only auxiliary constants to define the range of variable loc

// Excavation Locations
const xloc1=1;
const xloc2=2;
const xloc3=3;
const xloc4=4;
const xloc5=5;
const xloc6=6;
const xloc7=7;

// Dump Locations
const dloc1=7;
const dloc2=8;
const dloc3=9;
const dloc4=10;
const dloc5=11;
const dloc6=12;
const dloc7=13;
const dloc8=14;


// Possible states of the mission (to keep track of progress)
const START=0;
const DONE_EXCAVATING=1;
const DONE_DUMPING=2;
const FAILED=100;

formula tried_all_xloc =  tried_xloc1 &  tried_xloc2 &  tried_xloc3 &  tried_xloc4 &  tried_xloc5 &  tried_xloc6 &  tried_xloc7 &  true; // Have we tried all excavation locations?

// Module that is in charge of selecting an excavation location
// It tries one location first, and if it does not succeed, it goes to the next one.
// If all locations have been tried and state is still START (unsuccessful excavation), it fails
module autonomy
	s:[START..FAILED] init START; // State of mission
	loc:[locOrig..locNull] init curLoc;
	
	tried_xloc1: bool init false;
	tried_xloc2: bool init false;
	tried_xloc3: bool init false;
	tried_xloc4: bool init false;
	tried_xloc5: bool init false;
	tried_xloc6: bool init false;
	tried_xloc7: bool init false;

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
	[select_xloc4] (s=START) & (!tried_xloc4) -> ex_loc4: (s'=DONE_EXCAVATING) & (tried_xloc4'=true) & (loc'=xloc4) 
				  	       + (1-ex_loc4): (tried_xloc4'=true) & (loc'=xloc4);
	[select_xloc5] (s=START) & (!tried_xloc5) -> ex_loc5: (s'=DONE_EXCAVATING) & (tried_xloc5'=true) & (loc'=xloc5) 
				  	       + (1-ex_loc5): (tried_xloc5'=true) & (loc'=xloc5);
	[select_xloc6] (s=START) & (!tried_xloc6) -> ex_loc6: (s'=DONE_EXCAVATING) & (tried_xloc6'=true) & (loc'=xloc6) 
				  	       + (1-ex_loc6): (tried_xloc6'=true) & (loc'=xloc6);
	[select_xloc7] (s=START) & (!tried_xloc7) -> ex_loc7: (s'=DONE_EXCAVATING) & (tried_xloc7'=true) & (loc'=xloc7) 
				  	       + (1-ex_loc7): (tried_xloc7'=true) & (loc'=xloc7);

	
	// If all excavation locations have been tried and state is not DONE_EXCAVATING, mission fails
	[] (s=START) & (tried_all_xloc) -> (s'=FAILED);

	// Dump behavior
	// These commands just update the state to DONE_DUMPING (no probability of failure), and update arm location

	[select_dloc1] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc1);
	[select_dloc2] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc2);
	[select_dloc3] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc3);
	[select_dloc4] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc4);
	[select_dloc5] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc5);
	[select_dloc6] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc6);
	[select_dloc7] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc7);


endmodule


// stopping condition label for PCTL formula checking
label "done" = (s=DONE_DUMPING);



// Script-generated rewards and constants start here


// Science value reward
// The estimated science value for the different excavation locations has to be provided by a different model
rewards "SV"
	[select_xloc1] true: 0.495812241382;
	[select_xloc2] true: 0.233084450258;
	[select_xloc3] true: 0.230866541541;
	[select_xloc4] true: 0.218781037338;
	[select_xloc5] true: 0.459603465738;
	[select_xloc6] true: 0.28978161459;
	[select_xloc7] true: 0.0214897052659;
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
	[select_xloc1] loc=4 :4.58613332359;
	[select_xloc1] loc=5 :2.06414268466;
	[select_xloc1] loc=6 :2.95295805868;
	[select_xloc1] loc=7 :4.5782533636;
	[select_dloc1] loc=1 :3.94491224017;
	[select_dloc1] loc=2 :2.51731330661;
	[select_dloc1] loc=3 :3.20226951621;
	[select_dloc1] loc=4 :2.33886431395;
	[select_dloc1] loc=5 :4.45230475207;
	[select_dloc1] loc=6 :3.63280763599;
	[select_dloc1] loc=7 :3.38053602417;
	[select_xloc2] loc=1 :3.03734527162;
	[select_xloc2] loc=3 :3.30492341939;
	[select_xloc2] loc=4 :3.4361537455;
	[select_xloc2] loc=5 :3.67234956419;
	[select_xloc2] loc=6 :2.61924130932;
	[select_xloc2] loc=7 :3.42562951329;
	[select_dloc2] loc=1 :3.63032196506;
	[select_dloc2] loc=2 :4.0286872969;
	[select_dloc2] loc=3 :5.21083871793;
	[select_dloc2] loc=4 :4.53466882575;
	[select_dloc2] loc=5 :4.1761133357;
	[select_dloc2] loc=6 :4.44621820821;
	[select_dloc2] loc=7 :2.78947419621;
	[select_xloc3] loc=1 :4.01297210127;
	[select_xloc3] loc=2 :3.30492341939;
	[select_xloc3] loc=4 :2.74379550805;
	[select_xloc3] loc=5 :4.21484164523;
	[select_xloc3] loc=6 :3.33753858542;
	[select_xloc3] loc=7 :4.65645292741;
	[select_dloc3] loc=1 :2.74050361063;
	[select_dloc3] loc=2 :1.5142081304;
	[select_dloc3] loc=3 :2.93763383454;
	[select_dloc3] loc=4 :3.67726240862;
	[select_dloc3] loc=5 :3.43089566477;
	[select_dloc3] loc=6 :2.26832951251;
	[select_dloc3] loc=7 :3.66743013859;
	[select_xloc4] loc=1 :4.58613332359;
	[select_xloc4] loc=2 :3.4361537455;
	[select_xloc4] loc=3 :2.74379550805;
	[select_xloc4] loc=5 :5.02924486224;
	[select_xloc4] loc=6 :4.3205992176;
	[select_xloc4] loc=7 :3.8849626871;
	[select_dloc4] loc=1 :3.45710609665;
	[select_dloc4] loc=2 :3.5473178342;
	[select_dloc4] loc=3 :4.84829687879;
	[select_dloc4] loc=4 :4.1129507461;
	[select_dloc4] loc=5 :4.02644602424;
	[select_dloc4] loc=6 :4.015220895;
	[select_dloc4] loc=7 :3.00146985623;
	[select_xloc5] loc=1 :2.06414268466;
	[select_xloc5] loc=2 :3.67234956419;
	[select_xloc5] loc=3 :4.21484164523;
	[select_xloc5] loc=4 :5.02924486224;
	[select_xloc5] loc=6 :2.8280401858;
	[select_xloc5] loc=7 :5.02206022305;
	[select_dloc5] loc=1 :5.30185711796;
	[select_dloc5] loc=2 :4.34559807165;
	[select_dloc5] loc=3 :3.83114849986;
	[select_dloc5] loc=4 :2.84395500016;
	[select_dloc5] loc=5 :5.68949680745;
	[select_dloc5] loc=6 :5.07391837112;
	[select_dloc5] loc=7 :2.67381469776;
	[select_xloc6] loc=1 :2.95295805868;
	[select_xloc6] loc=2 :2.61924130932;
	[select_xloc6] loc=3 :3.33753858542;
	[select_xloc6] loc=4 :4.3205992176;
	[select_xloc6] loc=5 :2.8280401858;
	[select_xloc6] loc=7 :4.31223406122;
	[select_dloc6] loc=1 :4.28071913904;
	[select_dloc6] loc=2 :3.01646979901;
	[select_dloc6] loc=3 :4.19121686904;
	[select_dloc6] loc=4 :3.31310731162;
	[select_dloc6] loc=5 :4.75239322552;
	[select_dloc6] loc=6 :3.99493618031;
	[select_dloc6] loc=7 :2.02885559414;
	[select_xloc7] loc=1 :4.5782533636;
	[select_xloc7] loc=2 :3.42562951329;
	[select_xloc7] loc=3 :4.65645292741;
	[select_xloc7] loc=4 :3.8849626871;
	[select_xloc7] loc=5 :5.02206022305;
	[select_xloc7] loc=6 :4.31223406122;
	[select_dloc7] loc=1 :4.14791801286;
	[select_dloc7] loc=2 :2.82484646351;
	[select_dloc7] loc=3 :3.26646082277;
	[select_dloc7] loc=4 :2.0199375044;
	[select_dloc7] loc=5 :4.6331316476;
	[select_dloc7] loc=6 :3.85229575433;
	[select_dloc7] loc=7 :3.31855202739;
endrewards

// Excavatability probabilities for excavation locations
const double ex_loc1=0.504187758618;
const double ex_loc2=0.766915549742;
const double ex_loc3=0.769133458459;
const double ex_loc4=0.781218962662;
const double ex_loc5=0.540396534262;
const double ex_loc6=0.71021838541;
const double ex_loc7=0.978510294734;
