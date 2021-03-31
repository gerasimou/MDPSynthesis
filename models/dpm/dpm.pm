// power manager example
mdp

const int QMAX =2; // max queue size

// to model the pm making a choice and then a move being made we need
// two clock ticks for each transition
// first the pm decides tick1 and then the system moves tick2

module timer

	c : [0..1];

	[tick1] c=0 -> (c'=1);
	[tick2] c=1 -> (c'=0);
	
endmodule

//-------------------------------------------------------------------------

// POWER MANAGER
module PM

	pm : [0..4] init 4;
	// 0 - go to active 
	// 1 - go to idle 
	// 2 - go to idlelp 
	// 3 - go to stby  
	// 4 - go to sleep 

	[tick1] true -> (pm'=0);
	[tick1] true -> (pm'=1);
	[tick1] true -> (pm'=2);
	[tick1] true -> (pm'=3);
	[tick1] true -> (pm'=4);
	
endmodule


//-------------------------------------------------------------------------

// SERVICE REQUESTER
module SR

	sr : [0..1] init 0;
	// 0 idle
	// 1 1req
	
	[tick2] sr=0 -> 0.898: (sr'=0) + 0.102: (sr'=1);
	[tick2] sr=1 -> 0.454: (sr'=0) + 0.546: (sr'=1);

endmodule

//-------------------------------------------------------------------------

// SERVICE PROVIDER

module SP 

	sp : [0..10] init 9;
	// 0 active
	// 1 idle
	// 2 active_idlelp
	// 3 idlelp
	// 4 idlelp_active
	// 5 active_stby
	// 6 stby
	// 7 stby_active
    // 8 active_sleep
	// 9 sleep
	// 10 sleep_active
	
	// states where PM has no control (transient states)
	[tick2] sp=2  ->   0.75   : (sp'=2) + 0.25   : (sp'=3);   // active_idlelp
	[tick2] sp=4  ->   0.25   : (sp'=0) + 0.75   : (sp'=4);  // idlelp_active
	[tick2] sp=5  ->   0.995  : (sp'=5) + 0.005  : (sp'=6);  // active_stby
	[tick2] sp=7  ->   0.005  : (sp'=0) + 0.995  : (sp'=7);  // stby_active
	[tick2] sp=8  ->   0.9983 : (sp'=8) + 0.0017 : (sp'=9);  // active_sleep
	[tick2] sp=10 ->   0.0017 : (sp'=0) + 0.9983 : (sp'=10); // sleep_active

	// states where PM has control
	// goto_active
	[tick2] sp=0 & pm=0 -> (sp'=0); // active
	[tick2] sp=1 & pm=0 -> (sp'=0); // idle
	[tick2] sp=3 & pm=0 -> (sp'=4); // idlelp
	[tick2] sp=6 & pm=0 -> (sp'=7); // stby
	[tick2] sp=9 & pm=0 -> (sp'=10); // sleep
	// goto_idle
	[tick2] sp=0 & pm=1 -> (sp'=1); // active
	[tick2] sp=1 & pm=1 -> (sp'=1); // idle
	[tick2] sp=3 & pm=1 -> (sp'=3); // idlelp
	[tick2] sp=6 & pm=1 -> (sp'=6); // stby
	[tick2] sp=9 & pm=1 -> (sp'=9); // sleep
	// goto_idlelp
	[tick2] sp=0 & pm=2 -> (sp'=2); // active
	[tick2] sp=1 & pm=2 -> (sp'=2); // idle
	[tick2] sp=3 & pm=2 -> (sp'=3); // idlelp
	[tick2] sp=6 & pm=2 -> (sp'=6); // stby
	[tick2] sp=9 & pm=2 -> (sp'=9); // sleep
	// goto_stby
	[tick2] sp=0 & pm=3 -> (sp'=5); // active
	[tick2] sp=1 & pm=3 -> (sp'=5); // idle
	[tick2] sp=3 & pm=3 -> (sp'=5); // idlelp
	[tick2] sp=6 & pm=3 -> (sp'=6); // stby
	[tick2] sp=9 & pm=3 -> (sp'=9); // sleep
	// goto_sleep
	[tick2] sp=0 & pm=4 -> (sp'=8); // active
	[tick2] sp=1 & pm=4 -> (sp'=8); // idle
	[tick2] sp=3 & pm=4 -> (sp'=8); // idlelp
	[tick2] sp=6 & pm=4 -> (sp'=8); // stby
	[tick2] sp=9 & pm=4 -> (sp'=9); // sleep
	  
endmodule


//-------------------------------------------------------------------------

// SQ
module SQ

	q : [0..QMAX] init 0;
	
	// serve if busy
	[tick2] sr=0 & sp=0 -> (q'=max(q-1,0));
	[tick2] sr=1 & sp=0 -> (q'=q);
	
	// otherwise do nothing
	[tick2] sr=0 & sp>0 -> (q'=q);
	[tick2] sr=1 & sp>0 -> (q'=min(q+1,QMAX));

endmodule

//-------------------------------------------------------------------------
//rewards "time"
//	[tick2] bat=1 : 1;
//endrewards

rewards "power"
	[tick2] sp=0  & c=1  : 2.5;
	[tick2] sp=1  & c=1  : 1.5;
	[tick2] sp=2  & c=1  : 2.5;
	[tick2] sp=3  & c=1  : 0.8;
	[tick2] sp=4  & c=1  : 2.5;
	[tick2] sp=5  & c=1  : 2.5;
	[tick2] sp=6  & c=1  : 0.3;
	[tick2] sp=7  & c=1  : 2.5;
	[tick2] sp=8  & c=1  : 2.5;
	[tick2] sp=9  & c=1  : 0.1;
	[tick2] sp=10 & c=1  : 2.5;
endrewards

// is an instantaneous property but I suppose we can look at average size
// i.e. divide by the expected number of time steps
rewards "queue"
	[tick2] c=1  : 1;
endrewards

rewards "lost"
	[tick2] sr=1 & sp>0 & q=2  : 1;
endrewards
