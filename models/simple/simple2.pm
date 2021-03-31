mdp

module simple
	s: [0..3] init 0;

	
	[a] s=0 -> 0.5:(s'=2) + 0.25:(s'=3) + 0.25:(s'=1);
	[] s=1 -> 1.0:(s'=1);
	[b] s=1 -> 0.5:(s'=1) + 0.4:(s'=2) + 0.1:(s'=0);
	[] s=2 -> 1.0:(s'=2);
	[] s=3 -> 1.0:(s'=2);
	[] s=3 -> 1.0:(s'=3);
endmodule

module simple2
	ss:[0..1] init 0;

	[a] ss=0  -> 0.5:(ss'=0) + 0.5:(ss'=1);
	[]  ss=1 -> 0.5:(ss'=0) + 0.5:(ss'=1);
endmodule

rewards "time"
	true : 1;
endrewards

rewards "cost"
	s=1: 1;
endrewards

