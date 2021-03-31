dtmc

const int o0;
const int o1;
const int o5;
const int o9;
const int o13;
const int o14;
const int o15;
const int o16;
const int o17;
const int o18;
const int o19;
const int o20;
const int o21;
const int o22;
const int o23;
const int o24;



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
const double ex_loc1 = 0.997893946649;
const double ex_loc2 = 0.554612805945;
const double ex_loc3 = 0.278459967659;

module M
	x:[0..48];

	[select_xloc1]	x = 0&o0=0 -> 0.002106053351:(x' = 1) + 0.997893946649:(x' = 13);
	[select_xloc2]	x = 0&o0=1 -> 0.445387194055:(x' = 5) + 0.554612805945:(x' = 17);
	[select_xloc3]	x = 0&o0=2 -> 0.721540032341:(x' = 9) + 0.278459967659:(x' = 21);
	[select_xloc2]	x = 1&o1=0 -> 0.445387194055:(x' = 7) + 0.554612805945:(x' = 19);
	[select_xloc3]	x = 1&o1=1 -> 0.721540032341:(x' = 11) + 0.278459967659:(x' = 23);
	[select_xloc2]	x = 2 -> 0.445387:(x' = 8) + 0.554613:(x' = 20);
	[select_xloc3]	x = 3 -> 0.721540:(x' = 12) + 0.278460:(x' = 24);
	[]	x = 4 -> 1.000000:(x' = 46);
	[select_xloc1]	x = 5&o5=0 -> 0.002106053351:(x' = 3) + 0.997893946649:(x' = 15);
	[select_xloc3]	x = 5&o5=1 -> 0.721540032341:(x' = 10) + 0.278459967659:(x' = 22);
	[select_xloc1]	x = 6 -> 0.002106:(x' = 4) + 0.997894:(x' = 16);
	[select_xloc3]	x = 7 -> 0.721540:(x' = 12) + 0.278460:(x' = 24);
	[]	x = 8 -> 1.000000:(x' = 47);
	[select_xloc1]	x = 9&o9=0 -> 0.002106053351:(x' = 2) + 0.997893946649:(x' = 14);
	[select_xloc2]	x = 9&o9=1 -> 0.445387194055:(x' = 6) + 0.554612805945:(x' = 18);
	[select_xloc1]	x = 10 -> 0.002106:(x' = 4) + 0.997894:(x' = 16);
	[select_xloc2]	x = 11 -> 0.445387:(x' = 8) + 0.554613:(x' = 20);
	[]	x = 12 -> 1.000000:(x' = 48);
	[select_dloc1]	x = 13&o13=0 -> 1:(x' = 28);
	[select_dloc2]	x = 13&o13=1 -> 1:(x' = 35);
	[select_dloc3]	x = 13&o13=2 -> 1:(x' = 42);
	[select_dloc1]	x = 14&o14=0 -> 1:(x' = 29);
	[select_dloc2]	x = 14&o14=1 -> 1:(x' = 36);
	[select_dloc3]	x = 14&o14=2 -> 1:(x' = 43);
	[select_dloc1]	x = 15&o15=0 -> 1:(x' = 30);
	[select_dloc2]	x = 15&o15=1 -> 1:(x' = 37);
	[select_dloc3]	x = 15&o15=2 -> 1:(x' = 44);
	[select_dloc1]	x = 16&o16=0 -> 1:(x' = 31);
	[select_dloc2]	x = 16&o16=1 -> 1:(x' = 38);
	[select_dloc3]	x = 16&o16=2 -> 1:(x' = 45);
	[select_dloc1]	x = 17&o17=0 -> 1:(x' = 26);
	[select_dloc2]	x = 17&o17=1 -> 1:(x' = 33);
	[select_dloc3]	x = 17&o17=2 -> 1:(x' = 40);
	[select_dloc1]	x = 18&o18=0 -> 1:(x' = 27);
	[select_dloc2]	x = 18&o18=1 -> 1:(x' = 34);
	[select_dloc3]	x = 18&o18=2 -> 1:(x' = 41);
	[select_dloc1]	x = 19&o19=0 -> 1:(x' = 30);
	[select_dloc2]	x = 19&o19=1 -> 1:(x' = 37);
	[select_dloc3]	x = 19&o19=2 -> 1:(x' = 44);
	[select_dloc1]	x = 20&o20=0 -> 1:(x' = 31);
	[select_dloc2]	x = 20&o20=1 -> 1:(x' = 38);
	[select_dloc3]	x = 20&o20=2 -> 1:(x' = 45);
	[select_dloc1]	x = 21&o21=0 -> 1:(x' = 25);
	[select_dloc2]	x = 21&o21=1 -> 1:(x' = 32);
	[select_dloc3]	x = 21&o21=2 -> 1:(x' = 39);
	[select_dloc1]	x = 22&o22=0 -> 1:(x' = 27);
	[select_dloc2]	x = 22&o22=1 -> 1:(x' = 34);
	[select_dloc3]	x = 22&o22=2 -> 1:(x' = 41);
	[select_dloc1]	x = 23&o23=0 -> 1:(x' = 29);
	[select_dloc2]	x = 23&o23=1 -> 1:(x' = 36);
	[select_dloc3]	x = 23&o23=2 -> 1:(x' = 43);
	[select_dloc1]	x = 24&o24=0 -> 1:(x' = 31);
	[select_dloc2]	x = 24&o24=1 -> 1:(x' = 38);
	[select_dloc3]	x = 24&o24=2 -> 1:(x' = 45);
	[]	x = 25 -> 1.000000:(x' = 25);
	[]	x = 26 -> 1.000000:(x' = 26);
	[]	x = 27 -> 1.000000:(x' = 27);
	[]	x = 28 -> 1.000000:(x' = 28);
	[]	x = 29 -> 1.000000:(x' = 29);
	[]	x = 30 -> 1.000000:(x' = 30);
	[]	x = 31 -> 1.000000:(x' = 31);
	[]	x = 32 -> 1.000000:(x' = 32);
	[]	x = 33 -> 1.000000:(x' = 33);
	[]	x = 34 -> 1.000000:(x' = 34);
	[]	x = 35 -> 1.000000:(x' = 35);
	[]	x = 36 -> 1.000000:(x' = 36);
	[]	x = 37 -> 1.000000:(x' = 37);
	[]	x = 38 -> 1.000000:(x' = 38);
	[]	x = 39 -> 1.000000:(x' = 39);
	[]	x = 40 -> 1.000000:(x' = 40);
	[]	x = 41 -> 1.000000:(x' = 41);
	[]	x = 42 -> 1.000000:(x' = 42);
	[]	x = 43 -> 1.000000:(x' = 43);
	[]	x = 44 -> 1.000000:(x' = 44);
	[]	x = 45 -> 1.000000:(x' = 45);
	[]	x = 46 -> 1.000000:(x' = 46);
	[]	x = 47 -> 1.000000:(x' = 47);
	[]	x = 48 -> 1.000000:(x' = 48);
endmodule 

rewards "SV"
	[select_xloc1]true:0.00210605335111;
	[select_xloc2]true:0.445387194055;
	[select_xloc3]true:0.721540032341;
endrewards

rewards "EC"
	[select_xloc1]x=5|x=6|x=7|x=8|x=17|x=18|x=19|x=20|x=47:3.03734527162;
	[select_xloc1]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:4.01297210127;
	[select_dloc1]x=1|x=2|x=3|x=4|x=13|x=14|x=15|x=16|x=46:3.94491224017;
	[select_dloc1]x=5|x=6|x=7|x=8|x=17|x=18|x=19|x=20|x=47:2.51731330661;
	[select_dloc1]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:3.20226951621;
	[select_xloc2]x=1|x=2|x=3|x=4|x=13|x=14|x=15|x=16|x=46:3.03734527162;
	[select_xloc2]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:3.30492341939;
	[select_dloc2]x=1|x=2|x=3|x=4|x=13|x=14|x=15|x=16|x=46:3.63032196506;
	[select_dloc2]x=5|x=6|x=7|x=8|x=17|x=18|x=19|x=20|x=47:4.0286872969;
	[select_dloc2]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:5.21083871793;
	[select_xloc3]x=1|x=2|x=3|x=4|x=13|x=14|x=15|x=16|x=46:4.01297210127;
	[select_xloc3]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:3.30492341939;
	[select_dloc3]x=1|x=2|x=3|x=4|x=13|x=14|x=15|x=16|x=46:2.74050361063;
	[select_dloc3]x=5|x=6|x=7|x=8|x=17|x=18|x=19|x=20|x=47:1.5142081304;
	[select_dloc3]x=9|x=10|x=11|x=12|x=21|x=22|x=23|x=24|x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=48:2.93763383454;
endrewards

//const int o0 (int)[0:2];
//const int o1 (int)[0:1];
//const int o5 (int)[0:1];
//const int o9 (int)[0:1];
//const int o13 (int)[0:2];
//const int o14 (int)[0:2];
//const int o15 (int)[0:2];
//const int o16 (int)[0:2];
//const int o17 (int)[0:2];
//const int o18 (int)[0:2];
//const int o19 (int)[0:2];
//const int o20 (int)[0:2];
//const int o21 (int)[0:2];
//const int o22 (int)[0:2];
//const int o23 (int)[0:2];
//const int o24 (int)[0:2];

