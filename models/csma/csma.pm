// CSMA/CD protocol - probabilistic version of kronos model (3 stations)
// gxn/dxp 04/12/01

mdp

// simplified parameters scaled
const int sigma=1; // time for messages to propagate along the bus
const int lambda=30; // time to send a message


// note made changes since cannot have strict inequalities
// in digital clocks approach and suppose a station only sends one message

// actual parameters
const int N = 2; // number of processes
const int K = 2; // exponential backoff limit
const int slot = 2*sigma; // length of slot
const int M = floor(pow(2, K))-1 ; // max number of slots to wait
//const int lambda=782;
//const int sigma=26;


//----------------------------------------------------------------------------------------------------------------------------
// the bus
module bus
	
	b : [0..2];
	// b=0 - idle
	// b=1 - active
	// b=2 - collision
	
	// clocks of bus
	y1 : [0..sigma+1]; // time since first send (used find time until channel sensed busy)
	y2 : [0..sigma+1]; // time since second send (used to find time until collision detected)
	
	// a sender sends (ok - no other message being sent)
	[send1] (b=0) -> (b'=1);
	[send2] (b=0) -> (b'=1);
	[send3] (b=0) -> (b'=1);
	
	// a sender sends (bus busy - collision)
	[send1] (b=1|b=2) & (y1<sigma) -> (b'=2);
	[send2] (b=1|b=2) & (y1<sigma) -> (b'=2);
	[send3] (b=1|b=2) & (y1<sigma) -> (b'=2);
	
	// finish sending
	[end1] (b=1) -> (b'=0) & (y1'=0);
	[end2] (b=1) -> (b'=0) & (y1'=0);
	[end3] (b=1) -> (b'=0) & (y1'=0);
	
	// bus busy
	[busy1] (b=1|b=2) & (y1>=sigma) -> (b'=b);  
	[busy2] (b=1|b=2) & (y1>=sigma) -> (b'=b);  
	[busy3] (b=1|b=2) & (y1>=sigma) -> (b'=b);  
	
	// collision detected
	[cd] (b=2) & (y2<=sigma) -> (b'=0) & (y1'=0) & (y2'=0);
	
	// time passage
	[time] (b=0) -> (y1'=0); // value of y1/y2 does not matter in state 0
	[time] (b=1) -> (y1'=min(y1+1,sigma+1)); // no invariant in state 1
	[time] (b=2) & (y2<sigma) -> (y1'=min(y1+1,sigma+1)) & (y2'=min(y2+1,sigma+1)); // invariant in state 2 (time until collision detected)
	
endmodule

//----------------------------------------------------------------------------------------------------------------------------
// model of first sender
module station1
	
	// LOCAL STATE
	s1 : [0..5];
	// s1=0 - initial state
	// s1=1 - transmit
	// s1=2 - collision (set backoff)
	// s1=3 - wait (bus busy)
	// s1=4 - successfully sent
	
	// LOCAL CLOCK
	x1 : [0..max(lambda,slot)];
	
	// BACKOFF COUNTER (number of slots to wait)
	bc1 : [0..M];
	
	// COLLISION COUNTER
	cd1 : [0..K];
	
	// start sending
	[send1] (s1=0) -> (s1'=1) & (x1'=0); // start sending
	[busy1] (s1=0) -> (s1'=2) & (x1'=0) & (cd1'=min(K,cd1+1)); // detects channel is busy so go into backoff
	
	// transmitting
	[time] (s1=1) & (x1<lambda) -> (x1'=min(x1+1,lambda)); // let time pass
	[end1]  (s1=1) & (x1=lambda) -> (s1'=4) & (x1'=0); // finished
	[cd]   (s1=1) -> (s1'=2) & (x1'=0) & (cd1'=min(K,cd1+1)); // collision detected (increment backoff counter)
	[cd] !(s1=1) -> (s1'=s1); // add loop for collision detection when not important
	
	// set backoff (no time can pass in this state)
	// probability depends on which transmission this is (cd1)
	[] s1=2 & cd1=1 ->  1/2 : (s1'=3) & (bc1'=0) + 1/2 : (s1'=3) & (bc1'=1) ;
	[] s1=2 & cd1=2 ->  1/4 : (s1'=3) & (bc1'=0) + 1/4 : (s1'=3) & (bc1'=1) + 1/4 : (s1'=3) & (bc1'=2) + 1/4 : (s1'=3) & (bc1'=3) ;
	
	// wait until backoff counter reaches 0 then send again
	[time] (s1=3) & (x1<slot) -> (x1'=x1+1); // let time pass (in slot)
	[time] (s1=3) & (x1=slot) & (bc1>0) -> (x1'=1) & (bc1'=bc1-1); // let time pass (move slots)
	[send1] (s1=3) & (x1=slot) & (bc1=0) -> (s1'=1) & (x1'=0); // finished backoff (bus appears free)
	[busy1] (s1=3) & (x1=slot) & (bc1=0) -> (s1'=2) & (x1'=0) & (cd1'=min(K,cd1+1)); // finished backoff (bus busy)
	
	// once finished nothing matters
	[time] (s1>=4) -> (x1'=0);

endmodule

//----------------------------------------------------------------------------------------------------------------------------

// construct further stations through renaming
module station2=station1[s1=s2,x1=x2,cd1=cd2,bc1=bc2,send1=send2,busy1=busy2,end1=end2] endmodule
module station3=station1[s1=s3,x1=x3,cd1=cd3,bc1=bc3,send1=send3,busy1=busy3,end1=end3] endmodule

//----------------------------------------------------------------------------------------------------------------------------

// reward structure for expected time
rewards "time"
	[time] true : 1;
endrewards

//----------------------------------------------------------------------------------------------------------------------------

// labels/formulae
label "all_delivered" = s1=4&s2=4&s3=4;
label "one_delivered" = s1=4|s2=4|s3=4;
label "collision_max_backoff" = (cd1=K & s1=1 & b=2)|(cd2=K & s2=1 & b=2)|(cd3=K & s3=1 & b=2);
formula min_backoff_after_success = min(s1=4?cd1:K+1,s2=4?cd2:K+1,s3=4?cd3:K+1);
formula min_collisions = min(cd1,cd2,cd3);
formula max_collisions = max(cd1,cd2,cd3);
