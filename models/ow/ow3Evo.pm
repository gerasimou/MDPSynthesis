dtmc

module M
	x : [0..38];

	[try_xloc1]	x=0&o0=0->0.002106053351:(x'=1)+0.997893946649:(x'=5);
	[try_xloc2]	x=0&o0=1->0.445387194055:(x'=2)+0.554612805945:(x'=7);
	[try_xloc3]	x=0&o0=2->0.721540032341:(x'=3)+0.278459967659:(x'=9);
	[]	x=1->1.000000:(x'=36);
	[]	x=2->1.000000:(x'=37);
	[]	x=3->1.000000:(x'=38);
	[select_dloc1]	x=4&o4=0->1:(x'=22);
	[select_dloc2]	x=4&o4=1->1:(x'=28);
	[select_dloc3]	x=4&o4=2->1:(x'=34);
	[select_xloc1]	x=5&o5=0->1:(x'=4);
	[select_dloc1]	x=5&o5=1->1:(x'=23);
	[select_dloc2]	x=5&o5=2->1:(x'=29);
	[select_dloc3]	x=5&o5=3->1:(x'=35);
	[select_dloc1]	x=6&o6=0->1:(x'=20);
	[select_dloc2]	x=6&o6=1->1:(x'=26);
	[select_dloc3]	x=6&o6=2->1:(x'=32);
	[select_xloc2]	x=7&o7=0->1:(x'=6);
	[select_dloc1]	x=7&o7=1->1:(x'=21);
	[select_dloc2]	x=7&o7=2->1:(x'=27);
	[select_dloc3]	x=7&o7=3->1:(x'=33);
	[select_dloc1]	x=8&o8=0->1:(x'=18);
	[select_dloc2]	x=8&o8=1->1:(x'=24);
	[select_dloc3]	x=8&o8=2->1:(x'=30);
	[select_xloc3]	x=9&o9=0->1:(x'=8);
	[select_dloc1]	x=9&o9=1->1:(x'=19);
	[select_dloc2]	x=9&o9=2->1:(x'=25);
	[select_dloc3]	x=9&o9=3->1:(x'=31);
	[select_dloc1]	x=10&o10=0->1:(x'=20);
	[select_dloc2]	x=10&o10=1->1:(x'=26);
	[select_dloc3]	x=10&o10=2->1:(x'=32);
	[select_dloc1]	x=11&o11=0->1:(x'=22);
	[select_dloc2]	x=11&o11=1->1:(x'=28);
	[select_dloc3]	x=11&o11=2->1:(x'=34);
	[select_dloc1]	x=12&o12=0->1:(x'=18);
	[select_dloc2]	x=12&o12=1->1:(x'=24);
	[select_dloc3]	x=12&o12=2->1:(x'=30);
	[select_dloc1]	x=13&o13=0->1:(x'=20);
	[select_dloc2]	x=13&o13=1->1:(x'=26);
	[select_dloc3]	x=13&o13=2->1:(x'=32);
	[select_dloc1]	x=14&o14=0->1:(x'=22);
	[select_dloc2]	x=14&o14=1->1:(x'=28);
	[select_dloc3]	x=14&o14=2->1:(x'=34);
	[select_dloc1]	x=15&o15=0->1:(x'=18);
	[select_dloc2]	x=15&o15=1->1:(x'=24);
	[select_dloc3]	x=15&o15=2->1:(x'=30);
	[select_dloc1]	x=16&o16=0->1:(x'=20);
	[select_dloc2]	x=16&o16=1->1:(x'=26);
	[select_dloc3]	x=16&o16=2->1:(x'=32);
	[select_dloc1]	x=17&o17=0->1:(x'=22);
	[select_dloc2]	x=17&o17=1->1:(x'=28);
	[select_dloc3]	x=17&o17=2->1:(x'=34);
	[]	x=18->1.000000:(x'=18);
	[select_xloc3]	x=19->1.000000:(x'=8);
	[]	x=20->1.000000:(x'=20);
	[select_xloc2]	x=21->1.000000:(x'=10);
	[]	x=22->1.000000:(x'=22);
	[select_xloc1]	x=23->1.000000:(x'=11);
	[]	x=24->1.000000:(x'=24);
	[select_xloc3]	x=25->1.000000:(x'=12);
	[]	x=26->1.000000:(x'=26);
	[select_xloc2]	x=27->1.000000:(x'=13);
	[]	x=28->1.000000:(x'=28);
	[select_xloc1]	x=29->1.000000:(x'=14);
	[]	x=30->1.000000:(x'=30);
	[select_xloc3]	x=31->1.000000:(x'=15);
	[]	x=32->1.000000:(x'=32);
	[select_xloc2]	x=33->1.000000:(x'=16);
	[]	x=34->1.000000:(x'=34);
	[select_xloc1]	x=35->1.000000:(x'=17);
	[]	x=36->1.000000:(x'=36);
	[]	x=37->1.000000:(x'=37);
	[]	x=38->1.000000:(x'=38);
endmodule

evolve int o0 [0..2];
evolve int o4 [0..2];
evolve int o5 [0..3];
evolve int o6 [0..2];
evolve int o7 [0..3];
evolve int o8 [0..2];
evolve int o9 [0..3];
evolve int o10 [0..2];
evolve int o11 [0..2];
evolve int o12 [0..2];
evolve int o13 [0..2];
evolve int o14 [0..2];
evolve int o15 [0..2];
evolve int o16 [0..2];
evolve int o17 [0..2];




rewards "SV" 
	[select_xloc1] true : 0.00210605335111;
	[select_xloc2] true : 0.445387194055;
	[select_xloc3] true : 0.721540032341;

endrewards

rewards "EC" 
	[select_xloc1] x=2|x=6|x=7|x=37 : 3.03734527162;
	[select_xloc1] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 4.01297210127;
	[select_dloc1] x=1|x=4|x=5|x=36 : 3.94491224017;
	[select_dloc1] x=2|x=6|x=7|x=37 : 2.51731330661;
	[select_dloc1] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 3.20226951621;
	[select_xloc2] x=1|x=4|x=5|x=36 : 3.03734527162;
	[select_xloc2] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 3.30492341939;
	[select_dloc2] x=1|x=4|x=5|x=36 : 3.63032196506;
	[select_dloc2] x=2|x=6|x=7|x=37 : 4.0286872969;
	[select_dloc2] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 5.21083871793;
	[select_xloc3] x=1|x=4|x=5|x=36 : 4.01297210127;
	[select_xloc3] x=2|x=6|x=7|x=37 : 3.30492341939;
	[select_dloc3] x=1|x=4|x=5|x=36 : 2.74050361063;
	[select_dloc3] x=2|x=6|x=7|x=37 : 1.5142081304;
	[select_dloc3] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 2.93763383454;

endrewards

rewards "T" 
	[select_xloc1] x=2|x=6|x=7|x=37 : 5.17124072472;
	[select_xloc1] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 6.83229692428;
	[select_dloc1] x=1|x=4|x=5|x=36 : 6.71642141658;
	[select_dloc1] x=2|x=6|x=7|x=37 : 4.28585884183;
	[select_dloc1] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 5.45203296066;
	[select_xloc2] x=1|x=4|x=5|x=36 : 5.17124072472;
	[select_xloc2] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 5.62680665189;
	[select_dloc2] x=1|x=4|x=5|x=36 : 6.18081485994;
	[select_dloc2] x=2|x=6|x=7|x=37 : 6.85905287475;
	[select_dloc2] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 8.87172809752;
	[select_xloc3] x=1|x=4|x=5|x=36 : 6.83229692428;
	[select_xloc3] x=2|x=6|x=7|x=37 : 5.62680665189;
	[select_dloc3] x=1|x=4|x=5|x=36 : 4.66585212092;
	[select_dloc3] x=2|x=6|x=7|x=37 : 2.57801930614;
	[select_dloc3] x=3|x=8|x=9|x=10|x=11|x=18|x=19|x=20|x=21|x=22|x=23|x=38 : 5.00147673742;

endrewards


 const int curLoc = 0;
const int locOrig = 0;
const int locNull = 6+100;
const int xloc1 = 1;
const int xloc2 = 2;
const int xloc3 = 3;
const int dloc1 = 3;
const int dloc2 = 4;
const int dloc3 = 5;
const int dloc4 = 6;
const int START = 0;
const int DONE_EXCAVATING = 1;
const int DONE_DUMPING = 2;
const int FAILED = 100;
const int MAX_TRIED = 1;
const double ex_loc1 = 0.997893946649;
const double ex_loc2 = 0.554612805945;
const double ex_loc3 = 0.278459967659;

