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
const locNull=12+100; // Only auxiliary constants to define the range of variable loc

// Excavation Locations
const xloc1=1;
const xloc2=2;
const xloc3=3;
const xloc4=4;
const xloc5=5;
const xloc6=6;

// Dump Locations
const dloc1=6;
const dloc2=7;
const dloc3=8;
const dloc4=9;
const dloc5=10;
const dloc6=11;
const dloc7=12;


// Possible states of the mission (to keep track of progress)
const START=0;
const DONE_EXCAVATING=1;
const DONE_DUMPING=2;
const FAILED=100;

formula tried_all_xloc =  tried_xloc1 &  tried_xloc2 &  tried_xloc3 &  tried_xloc4 &  tried_xloc5 &  tried_xloc6 &  true; // Have we tried all excavation locations?
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
	tried_xloc5: bool init false;
	succ_xloc5: bool init false;
	tried_xloc6: bool init false;
	succ_xloc6: bool init false;

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
	[try_xloc6] (s=START) & (!tried_xloc6) & (tried<MAX_TRIED) -> ex_loc6: (s'=DONE_EXCAVATING) & (tried_xloc6'=true) &  (tried'=tried+1)  & (loc'=xloc6) & (succ_xloc6'=true) 
				  	       + (1-ex_loc6): (tried_xloc6'=true) &  (tried'=tried+1) & (loc'=xloc6);
	[select_xloc6] (succ_xloc6) -> (succ_xloc6'=false) & (s'=DONE_EXCAVATING);

	
	// If all excavation locations have been tried (or maximum number of excavation attempts has been reached) and state is not DONE_EXCAVATING, mission fails
	[] (s=START) & (tried_all_xloc | tried>= MAX_TRIED) -> (s'=FAILED); 

	// Dump behavior
	// These commands just update the state to DONE_DUMPING (no probability of failure), and update arm location

	[select_dloc1] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc1);
	[select_dloc2] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc2);
	[select_dloc3] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc3);
	[select_dloc4] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc4);
	[select_dloc5] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc5);
	[select_dloc6] (s=DONE_EXCAVATING) -> (s'=DONE_DUMPING) & (loc'=dloc6);


endmodule


// stopping condition label for PCTL formula checking
label "done" = (s=DONE_DUMPING);



// Script-generated rewards and constants start here


// Science value reward
// The estimated science value for the different excavation locations has to be provided by a different model
rewards "SV"
	[select_xloc1] true: 0.422116575583;
	[select_xloc2] true: 0.0290407875749;
	[select_xloc3] true: 0.221691666273;
	[select_xloc4] true: 0.437887593651;
	[select_xloc5] true: 0.495812241382;
	[select_xloc6] true: 0.233084450258;
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
	[select_xloc1] loc=xloc6 :2.95295805868;
	[select_dloc1] loc=xloc1 :3.94491224017;
	[select_dloc1] loc=xloc2 :2.51731330661;
	[select_dloc1] loc=xloc3 :3.20226951621;
	[select_dloc1] loc=xloc4 :2.33886431395;
	[select_dloc1] loc=xloc5 :4.45230475207;
	[select_dloc1] loc=xloc6 :3.63280763599;
	[select_xloc2] loc=xloc1 :3.03734527162;
	[select_xloc2] loc=xloc3 :3.30492341939;
	[select_xloc2] loc=xloc4 :3.4361537455;
	[select_xloc2] loc=xloc5 :3.67234956419;
	[select_xloc2] loc=xloc6 :2.61924130932;
	[select_dloc2] loc=xloc1 :3.63032196506;
	[select_dloc2] loc=xloc2 :4.0286872969;
	[select_dloc2] loc=xloc3 :5.21083871793;
	[select_dloc2] loc=xloc4 :4.53466882575;
	[select_dloc2] loc=xloc5 :4.1761133357;
	[select_dloc2] loc=xloc6 :4.44621820821;
	[select_xloc3] loc=xloc1 :4.01297210127;
	[select_xloc3] loc=xloc2 :3.30492341939;
	[select_xloc3] loc=xloc4 :2.74379550805;
	[select_xloc3] loc=xloc5 :4.21484164523;
	[select_xloc3] loc=xloc6 :3.33753858542;
	[select_dloc3] loc=xloc1 :2.74050361063;
	[select_dloc3] loc=xloc2 :1.5142081304;
	[select_dloc3] loc=xloc3 :2.93763383454;
	[select_dloc3] loc=xloc4 :3.67726240862;
	[select_dloc3] loc=xloc5 :3.43089566477;
	[select_dloc3] loc=xloc6 :2.26832951251;
	[select_xloc4] loc=xloc1 :4.58613332359;
	[select_xloc4] loc=xloc2 :3.4361537455;
	[select_xloc4] loc=xloc3 :2.74379550805;
	[select_xloc4] loc=xloc5 :5.02924486224;
	[select_xloc4] loc=xloc6 :4.3205992176;
	[select_dloc4] loc=xloc1 :3.45710609665;
	[select_dloc4] loc=xloc2 :3.5473178342;
	[select_dloc4] loc=xloc3 :4.84829687879;
	[select_dloc4] loc=xloc4 :4.1129507461;
	[select_dloc4] loc=xloc5 :4.02644602424;
	[select_dloc4] loc=xloc6 :4.015220895;
	[select_xloc5] loc=xloc1 :2.06414268466;
	[select_xloc5] loc=xloc2 :3.67234956419;
	[select_xloc5] loc=xloc3 :4.21484164523;
	[select_xloc5] loc=xloc4 :5.02924486224;
	[select_xloc5] loc=xloc6 :2.8280401858;
	[select_dloc5] loc=xloc1 :5.30185711796;
	[select_dloc5] loc=xloc2 :4.34559807165;
	[select_dloc5] loc=xloc3 :3.83114849986;
	[select_dloc5] loc=xloc4 :2.84395500016;
	[select_dloc5] loc=xloc5 :5.68949680745;
	[select_dloc5] loc=xloc6 :5.07391837112;
	[select_xloc6] loc=xloc1 :2.95295805868;
	[select_xloc6] loc=xloc2 :2.61924130932;
	[select_xloc6] loc=xloc3 :3.33753858542;
	[select_xloc6] loc=xloc4 :4.3205992176;
	[select_xloc6] loc=xloc5 :2.8280401858;
	[select_dloc6] loc=xloc1 :4.28071913904;
	[select_dloc6] loc=xloc2 :3.01646979901;
	[select_dloc6] loc=xloc3 :4.19121686904;
	[select_dloc6] loc=xloc4 :3.31310731162;
	[select_dloc6] loc=xloc5 :4.75239322552;
	[select_dloc6] loc=xloc6 :3.99493618031;
endrewards
rewards "T"
	[select_xloc1] loc=xloc2 :5.2188095349;
	[select_xloc1] loc=xloc3 :6.89514533007;
	[select_xloc1] loc=xloc4 :7.87995903566;
	[select_xloc1] loc=xloc5 :3.54663910777;
	[select_xloc1] loc=xloc6 :5.07381423403;
	[select_dloc1] loc=xloc1 :6.77820391569;
	[select_dloc1] loc=xloc2 :4.32528326946;
	[select_dloc1] loc=xloc3 :5.5021847008;
	[select_dloc1] loc=xloc4 :4.01866969045;
	[select_dloc1] loc=xloc5 :7.65001289433;
	[select_dloc1] loc=xloc6 :6.24194137767;
	[select_xloc2] loc=xloc1 :5.2188095349;
	[select_xloc2] loc=xloc3 :5.67856608678;
	[select_xloc2] loc=xloc4 :5.90404788616;
	[select_xloc2] loc=xloc5 :6.30988287707;
	[select_xloc2] loc=xloc6 :4.50041740299;
	[select_dloc2] loc=xloc1 :6.23767046278;
	[select_dloc2] loc=xloc2 :6.92214740112;
	[select_dloc2] loc=xloc3 :8.95333666544;
	[select_dloc2] loc=xloc4 :7.79153200876;
	[select_dloc2] loc=xloc5 :7.17545690273;
	[select_dloc2] loc=xloc6 :7.63955490872;
	[select_xloc3] loc=xloc1 :6.89514533007;
	[select_xloc3] loc=xloc2 :5.67856608678;
	[select_xloc3] loc=xloc4 :4.71442818604;
	[select_xloc3] loc=xloc5 :7.24200043103;
	[select_xloc3] loc=xloc6 :5.7346059256;
	[select_dloc3] loc=xloc1 :4.70877200141;
	[select_dloc3] loc=xloc2 :2.60173379122;
	[select_dloc3] loc=xloc3 :5.04748393573;
	[select_dloc3] loc=xloc4 :6.31832419573;
	[select_dloc3] loc=xloc5 :5.89501337759;
	[select_dloc3] loc=xloc6 :3.89747579863;
	[select_xloc4] loc=xloc1 :7.87995903566;
	[select_xloc4] loc=xloc2 :5.90404788616;
	[select_xloc4] loc=xloc3 :4.71442818604;
	[select_xloc4] loc=xloc5 :8.64131953838;
	[select_xloc4] loc=xloc6 :7.42371458525;
	[select_dloc4] loc=xloc1 :5.94004851176;
	[select_dloc4] loc=xloc2 :6.09505159307;
	[select_dloc4] loc=xloc3 :8.33041215811;
	[select_dloc4] loc=xloc4 :7.06693004938;
	[select_dloc4] loc=xloc5 :6.91829641478;
	[select_dloc4] loc=xloc6 :6.89900923921;
	[select_xloc5] loc=xloc1 :3.54663910777;
	[select_xloc5] loc=xloc2 :6.30988287707;
	[select_xloc5] loc=xloc3 :7.24200043103;
	[select_xloc5] loc=xloc4 :8.64131953838;
	[select_xloc5] loc=xloc6 :4.85917858093;
	[select_dloc5] loc=xloc1 :9.10972576562;
	[select_dloc5] loc=xloc2 :7.46666796926;
	[select_dloc5] loc=xloc3 :6.58273345067;
	[select_dloc5] loc=xloc4 :4.8865236397;
	[select_dloc5] loc=xloc5 :9.7757737538;
	[select_dloc5] loc=xloc6 :8.71807819215;
	[select_xloc6] loc=xloc1 :5.07381423403;
	[select_xloc6] loc=xloc2 :4.50041740299;
	[select_xloc6] loc=xloc3 :5.7346059256;
	[select_xloc6] loc=xloc4 :7.42371458525;
	[select_xloc6] loc=xloc5 :4.85917858093;
	[select_dloc6] loc=xloc1 :7.35519207113;
	[select_dloc6] loc=xloc2 :5.18294100309;
	[select_dloc6] loc=xloc3 :7.20140800698;
	[select_dloc6] loc=xloc4 :5.69262776597;
	[select_dloc6] loc=xloc5 :8.16562914685;
	[select_dloc6] loc=xloc6 :6.86415575601;
endrewards

// Excavatability probabilities for excavation locations
const double ex_loc1=0.577883424417;
const double ex_loc2=0.970959212425;
const double ex_loc3=0.778308333727;
const double ex_loc4=0.562112406349;
const double ex_loc5=0.504187758618;
const double ex_loc6=0.766915549742;
