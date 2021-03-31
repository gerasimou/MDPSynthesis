dtmc

evolve int o3 [0..1];
evolve int o4 [0..2];
evolve int o6 [0..1];
evolve int o7 [0..1];
evolve int o8 [0..2];

module M
	u:[0..7] init 0;

	[] u=0->0.125:(u'=2)+0.125:(u'=3)+0.25:(u'=4)+0.25:(u'=5)+0.125:(u'=6)+0.125:(u'=7);
	
	[] u=1->0.5:(u'=0)+0.5:(u'=1);
	
	[] u=2&o3=0->1:(u'=2);
	[] u=2&o3=1->0.1:(u'=0)+0.5:(u'=2)+0.4:(u'=4);
	
	[] u=3&o4=0->1:(u'=3);
	[] u=3&o4=1->0.5:(u'=2)+0.5:(u'=3);
	[] u=3&o4=2->0.1:(u'=1)+0.5:(u'=3)+0.4:(u'=5);
	
	[] u=4->1:(u'=4);
	
	[] u=5&o6=0->1:(u'=5);
	[] u=5&o6=1->0.5:(u'=4)+0.5:(u'=5);
	
	[] u=6&o7=0->1:(u'=4);
	[] u=6&o7=1->1:(u'=6);
	
	[] u=7&o8=0->1:(u'=5);
	[] u=7&o8=1->1:(u'=7);
	[] u=7&o8=2->0.5:(u'=6)+0.5:(u'=7);
endmodule


//reward structures
rewards "cost"
// no rewards are called in this reward structure
endrewards

rewards "time"
// no rewards are called in this reward structure
endrewards


