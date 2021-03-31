// model of randomised consensus

mdp

const int N = 2; // num processes
const int MAX = 4; // num rounds (R)
const int K = 2; // Parameter for coins

// need to turn these into local copies later so the reading phase is complete?
formula leaders_agree1 = (p1=1 | r1<max(r1,r2)) & (p2=1 | r2<max(r1,r2));
formula leaders_agree2 = (p1=2 | r1<max(r1,r2)) & (p2=2 | r2<max(r1,r2));

formula decide1 = leaders_agree1 & (p1=1 | r1<max(r1,r2)-1) & (p2=1 | r2<max(r1,r2)-1);
formula decide2 = leaders_agree2 & (p1=2 | r1<max(r1,r2)-1) & (p2=2 | r2<max(r1,r2)-1);

module process1

	s1 : [0..5]; // local state
	// 0 initialise/read registers
	// 1 finish reading registers (make a decision)
	// 1 warn of change
	// 2 enter shared coin protocol
	// 4 finished
	// 5 error (reached max round and cannot decide)
	r1 : [0..MAX]; // round of the process
	p1 : [0..2]; // preference (0 corresponds to null)

	// nondeterministic choice as to initial preference
	[] s1=0 & r1=0 -> (p1'=1) & (r1'=1);
	[] s1=0 & r1=0 -> (p1'=2) & (r1'=1);
	
	// read registers (currently does nothing because read vs from other processes
	[] s1=0 & r1>0 & r1<=MAX -> (s1'=1);
	// maxke a decision
	[] s1=1 & decide1 -> (s1'=4) & (p1'=1);
	[] s1=1 & decide2 -> (s1'=4) & (p1'=2);
	[] s1=1 & r1<MAX & leaders_agree1 & !decide1 -> (s1'=0) & (p1'=1) & (r1'=r1+1);
	[] s1=1 & r1<MAX & leaders_agree2 & !decide2 -> (s1'=0) & (p1'=2) & (r1'=r1+1);
	[] s1=1 & r1<MAX & !(leaders_agree1 | leaders_agree2) -> (s1'=2) & (p1'=0);
	[] s1=1 & r1=MAX & !(decide1 | decide2) -> (s1'=5); // run out of rounds so error
	// enter the coin procotol for the current round
	[coin1_s1_start] s1=2 & r1=1 -> (s1'=3);
	[coin2_s1_start] s1=2 & r1=2 -> (s1'=3);
	[coin3_s1_start] s1=2 & r1=3 -> (s1'=3);
	// get response from the coin protocol
	[coin1_s1_p1] s1=3 & r1=1 -> (s1'=0) & (p1'=1) & (r1'=r1+1);
	[coin1_s1_p2] s1=3 & r1=1 -> (s1'=0) & (p1'=2) & (r1'=r1+1);
	[coin2_s1_p1] s1=3 & r1=2 -> (s1'=0) & (p1'=1) & (r1'=r1+1);
	[coin2_s1_p2] s1=3 & r1=2 -> (s1'=0) & (p1'=2) & (r1'=r1+1);
	[coin3_s1_p1] s1=3 & r1=3 -> (s1'=0) & (p1'=1) & (r1'=r1+1);
	[coin3_s1_p2] s1=3 & r1=3 -> (s1'=0) & (p1'=2) & (r1'=r1+1);
	// done so loop
	[done] s1>=4 -> true; 

endmodule

module process2 = process1[ s1=s2,
											p1=p2,p2=p1,
											r1=r2,r2=r1,
											coin1_s1_start=coin1_s2_start,coin2_s1_start=coin2_s2_start,coin3_s1_start=coin3_s2_start,
											coin1_s1_p1=coin1_s2_p1,coin2_s1_p1=coin2_s2_p1,coin3_s1_p1=coin3_s2_p1,
											coin1_s1_p2=coin1_s2_p2,coin2_s1_p2=coin2_s2_p2,coin3_s1_p2=coin3_s2_p2 ]
endmodule

module coin1_error
	
	c1 : [0..1]; // 1 is the error state
	v1 : [0..2]; // value of the coin returned the first time
	
	// first returned value (any processes)
	[coin1_s1_p1] v1=0 -> (v1'=1);
	[coin1_s2_p1] v1=0 -> (v1'=1);
	[coin1_s1_p2] v1=0 -> (v1'=2);
	[coin1_s2_p2] v1=0 -> (v1'=2);
	// later values returned
	[coin1_s1_p1] v1=1 -> true; // good behaviour
	[coin1_s2_p1] v1=1 -> true; // good behaviour
	[coin1_s1_p2] v1=2 -> true; // good behaviour
	[coin1_s2_p2] v1=2 -> true; // good behaviour
	[coin1_s1_p1] v1=2 -> (c1'=1); // error
	[coin1_s2_p1] v1=2 -> (c1'=1); // error
	[coin1_s1_p2] v1=1 -> (c1'=1); // error
	[coin1_s2_p2] v1=1 -> (c1'=1); // error

endmodule

// could do with renaming
module coin2_error
	
	c2 : [0..1]; // 1 is the error state
	v2 : [0..2]; // value of the coin returned the first time
	
	// first returned value (any processes)
	[coin2_s1_p1] v2=0 -> (v2'=1);
	[coin2_s2_p1] v2=0 -> (v2'=1);
	[coin2_s1_p2] v2=0 -> (v2'=2);
	[coin2_s2_p2] v2=0 -> (v2'=2);
	// later values returned
	[coin2_s1_p1] v2=1 -> true; // good behaviour
	[coin2_s2_p1] v2=1 -> true; // good behaviour
	[coin2_s1_p2] v2=2 -> true; // good behaviour
	[coin2_s2_p2] v2=2 -> true; // good behaviour
	[coin2_s1_p1] v2=2 -> (c2'=1); // error
	[coin2_s2_p1] v2=2 -> (c2'=1); // error
	[coin2_s1_p2] v2=1 -> (c2'=1); // error
	[coin2_s2_p2] v2=1 -> (c2'=1); // error

endmodule

// coin 3 is of no use because of number of rounds

// Labels
label "one_proc_err" = (s1=5 | s2=5);
label "one_coin_ok" = (c1=0 | c2=0);
