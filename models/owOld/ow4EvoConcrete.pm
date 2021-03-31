dtmc

const int o0;
const int o1;
const int o2;
const int o3;
const int o5;
const int o9;
const int o10;
const int o11;
const int o13;
const int o17;
const int o18;
const int o19;
const int o21;
const int o25;
const int o26;
const int o27;
const int o29;
const int o33;
const int o34;
const int o35;
const int o36;
const int o37;
const int o38;
const int o39;
const int o40;
const int o41;
const int o42;
const int o43;
const int o44;
const int o45;
const int o46;
const int o47;
const int o48;
const int o49;
const int o50;
const int o51;
const int o52;
const int o53;
const int o54;
const int o55;
const int o56;
const int o57;
const int o58;
const int o59;
const int o60;
const int o61;
const int o62;
const int o63;
const int o64;



const int curLoc = 0;
const int locOrig = 0;
const int locNull = 8+100;
const int xloc1 = 1;
const int xloc2 = 2;
const int xloc3 = 3;
const int xloc4 = 4;
const int dloc1 = 4;
const int dloc2 = 5;
const int dloc3 = 6;
const int dloc4 = 7;
const int dloc5 = 8;
const int START = 0;
const int DONE_EXCAVATING = 1;
const int DONE_DUMPING = 2;
const int FAILED = 100;
const double ex_loc1 = 0.0547293044461;
const double ex_loc2 = 0.0985725423885;
const double ex_loc3 = 0.969410016966;
const double ex_loc4 = 0.974554139007;

module M
	x:[0..128];

	[select_xloc1]	x = 0&o0=0 -> 0.945270695554:(x' = 1) + 0.0547293044461:(x' = 33);
	[select_xloc2]	x = 0&o0=1 -> 0.901427457612:(x' = 9) + 0.0985725423885:(x' = 41);
	[select_xloc3]	x = 0&o0=2 -> 0.030589983034:(x' = 17) + 0.969410016966:(x' = 49);
	[select_xloc4]	x = 0&o0=3 -> 0.025445860993:(x' = 25) + 0.974554139007:(x' = 57);
	[select_xloc2]	x = 1&o1=0 -> 0.901427457612:(x' = 13) + 0.0985725423885:(x' = 45);
	[select_xloc3]	x = 1&o1=1 -> 0.030589983034:(x' = 21) + 0.969410016966:(x' = 53);
	[select_xloc4]	x = 1&o1=2 -> 0.025445860993:(x' = 29) + 0.974554139007:(x' = 61);
	[select_xloc2]	x = 2&o2=0 -> 0.901427457612:(x' = 14) + 0.0985725423885:(x' = 46);
	[select_xloc3]	x = 2&o2=1 -> 0.030589983034:(x' = 22) + 0.969410016966:(x' = 54);
	[select_xloc2]	x = 3&o3=0 -> 0.901427457612:(x' = 15) + 0.0985725423885:(x' = 47);
	[select_xloc4]	x = 3&o3=1 -> 0.025445860993:(x' = 30) + 0.974554139007:(x' = 62);
	[select_xloc2]	x = 4 -> 0.901427:(x' = 16) + 0.098573:(x' = 48);
	[select_xloc3]	x = 5&o5=0 -> 0.030589983034:(x' = 23) + 0.969410016966:(x' = 55);
	[select_xloc4]	x = 5&o5=1 -> 0.025445860993:(x' = 31) + 0.974554139007:(x' = 63);
	[select_xloc3]	x = 6 -> 0.030590:(x' = 24) + 0.969410:(x' = 56);
	[select_xloc4]	x = 7 -> 0.025446:(x' = 32) + 0.974554:(x' = 64);
	[]	x = 8 -> 1.000000:(x' = 125);
	[select_xloc1]	x = 9&o9=0 -> 0.945270695554:(x' = 5) + 0.0547293044461:(x' = 37);
	[select_xloc3]	x = 9&o9=1 -> 0.030589983034:(x' = 19) + 0.969410016966:(x' = 51);
	[select_xloc4]	x = 9&o9=2 -> 0.025445860993:(x' = 27) + 0.974554139007:(x' = 59);
	[select_xloc1]	x = 10&o10=0 -> 0.945270695554:(x' = 6) + 0.0547293044461:(x' = 38);
	[select_xloc3]	x = 10&o10=1 -> 0.030589983034:(x' = 20) + 0.969410016966:(x' = 52);
	[select_xloc1]	x = 11&o11=0 -> 0.945270695554:(x' = 7) + 0.0547293044461:(x' = 39);
	[select_xloc4]	x = 11&o11=1 -> 0.025445860993:(x' = 28) + 0.974554139007:(x' = 60);
	[select_xloc1]	x = 12 -> 0.945271:(x' = 8) + 0.054729:(x' = 40);
	[select_xloc3]	x = 13&o13=0 -> 0.030589983034:(x' = 23) + 0.969410016966:(x' = 55);
	[select_xloc4]	x = 13&o13=1 -> 0.025445860993:(x' = 31) + 0.974554139007:(x' = 63);
	[select_xloc3]	x = 14 -> 0.030590:(x' = 24) + 0.969410:(x' = 56);
	[select_xloc4]	x = 15 -> 0.025446:(x' = 32) + 0.974554:(x' = 64);
	[]	x = 16 -> 1.000000:(x' = 126);
	[select_xloc1]	x = 17&o17=0 -> 0.945270695554:(x' = 3) + 0.0547293044461:(x' = 35);
	[select_xloc2]	x = 17&o17=1 -> 0.901427457612:(x' = 11) + 0.0985725423885:(x' = 43);
	[select_xloc4]	x = 17&o17=2 -> 0.025445860993:(x' = 26) + 0.974554139007:(x' = 58);
	[select_xloc1]	x = 18&o18=0 -> 0.945270695554:(x' = 4) + 0.0547293044461:(x' = 36);
	[select_xloc2]	x = 18&o18=1 -> 0.901427457612:(x' = 12) + 0.0985725423885:(x' = 44);
	[select_xloc1]	x = 19&o19=0 -> 0.945270695554:(x' = 7) + 0.0547293044461:(x' = 39);
	[select_xloc4]	x = 19&o19=1 -> 0.025445860993:(x' = 28) + 0.974554139007:(x' = 60);
	[select_xloc1]	x = 20 -> 0.945271:(x' = 8) + 0.054729:(x' = 40);
	[select_xloc2]	x = 21&o21=0 -> 0.901427457612:(x' = 15) + 0.0985725423885:(x' = 47);
	[select_xloc4]	x = 21&o21=1 -> 0.025445860993:(x' = 30) + 0.974554139007:(x' = 62);
	[select_xloc2]	x = 22 -> 0.901427:(x' = 16) + 0.098573:(x' = 48);
	[select_xloc4]	x = 23 -> 0.025446:(x' = 32) + 0.974554:(x' = 64);
	[]	x = 24 -> 1.000000:(x' = 127);
	[select_xloc1]	x = 25&o25=0 -> 0.945270695554:(x' = 2) + 0.0547293044461:(x' = 34);
	[select_xloc2]	x = 25&o25=1 -> 0.901427457612:(x' = 10) + 0.0985725423885:(x' = 42);
	[select_xloc3]	x = 25&o25=2 -> 0.030589983034:(x' = 18) + 0.969410016966:(x' = 50);
	[select_xloc1]	x = 26&o26=0 -> 0.945270695554:(x' = 4) + 0.0547293044461:(x' = 36);
	[select_xloc2]	x = 26&o26=1 -> 0.901427457612:(x' = 12) + 0.0985725423885:(x' = 44);
	[select_xloc1]	x = 27&o27=0 -> 0.945270695554:(x' = 6) + 0.0547293044461:(x' = 38);
	[select_xloc3]	x = 27&o27=1 -> 0.030589983034:(x' = 20) + 0.969410016966:(x' = 52);
	[select_xloc1]	x = 28 -> 0.945271:(x' = 8) + 0.054729:(x' = 40);
	[select_xloc2]	x = 29&o29=0 -> 0.901427457612:(x' = 14) + 0.0985725423885:(x' = 46);
	[select_xloc3]	x = 29&o29=1 -> 0.030589983034:(x' = 22) + 0.969410016966:(x' = 54);
	[select_xloc2]	x = 30 -> 0.901427:(x' = 16) + 0.098573:(x' = 48);
	[select_xloc3]	x = 31 -> 0.030590:(x' = 24) + 0.969410:(x' = 56);
	[]	x = 32 -> 1.000000:(x' = 128);
	[select_dloc1]	x = 33&o33=0 -> 1:(x' = 72);
	[select_dloc2]	x = 33&o33=1 -> 1:(x' = 87);
	[select_dloc3]	x = 33&o33=2 -> 1:(x' = 102);
	[select_dloc4]	x = 33&o33=3 -> 1:(x' = 117);
	[select_dloc1]	x = 34&o34=0 -> 1:(x' = 73);
	[select_dloc2]	x = 34&o34=1 -> 1:(x' = 88);
	[select_dloc3]	x = 34&o34=2 -> 1:(x' = 103);
	[select_dloc4]	x = 34&o34=3 -> 1:(x' = 118);
	[select_dloc1]	x = 35&o35=0 -> 1:(x' = 74);
	[select_dloc2]	x = 35&o35=1 -> 1:(x' = 89);
	[select_dloc3]	x = 35&o35=2 -> 1:(x' = 104);
	[select_dloc4]	x = 35&o35=3 -> 1:(x' = 119);
	[select_dloc1]	x = 36&o36=0 -> 1:(x' = 75);
	[select_dloc2]	x = 36&o36=1 -> 1:(x' = 90);
	[select_dloc3]	x = 36&o36=2 -> 1:(x' = 105);
	[select_dloc4]	x = 36&o36=3 -> 1:(x' = 120);
	[select_dloc1]	x = 37&o37=0 -> 1:(x' = 76);
	[select_dloc2]	x = 37&o37=1 -> 1:(x' = 91);
	[select_dloc3]	x = 37&o37=2 -> 1:(x' = 106);
	[select_dloc4]	x = 37&o37=3 -> 1:(x' = 121);
	[select_dloc1]	x = 38&o38=0 -> 1:(x' = 77);
	[select_dloc2]	x = 38&o38=1 -> 1:(x' = 92);
	[select_dloc3]	x = 38&o38=2 -> 1:(x' = 107);
	[select_dloc4]	x = 38&o38=3 -> 1:(x' = 122);
	[select_dloc1]	x = 39&o39=0 -> 1:(x' = 78);
	[select_dloc2]	x = 39&o39=1 -> 1:(x' = 93);
	[select_dloc3]	x = 39&o39=2 -> 1:(x' = 108);
	[select_dloc4]	x = 39&o39=3 -> 1:(x' = 123);
	[select_dloc1]	x = 40&o40=0 -> 1:(x' = 79);
	[select_dloc2]	x = 40&o40=1 -> 1:(x' = 94);
	[select_dloc3]	x = 40&o40=2 -> 1:(x' = 109);
	[select_dloc4]	x = 40&o40=3 -> 1:(x' = 124);
	[select_dloc1]	x = 41&o41=0 -> 1:(x' = 68);
	[select_dloc2]	x = 41&o41=1 -> 1:(x' = 83);
	[select_dloc3]	x = 41&o41=2 -> 1:(x' = 98);
	[select_dloc4]	x = 41&o41=3 -> 1:(x' = 113);
	[select_dloc1]	x = 42&o42=0 -> 1:(x' = 69);
	[select_dloc2]	x = 42&o42=1 -> 1:(x' = 84);
	[select_dloc3]	x = 42&o42=2 -> 1:(x' = 99);
	[select_dloc4]	x = 42&o42=3 -> 1:(x' = 114);
	[select_dloc1]	x = 43&o43=0 -> 1:(x' = 70);
	[select_dloc2]	x = 43&o43=1 -> 1:(x' = 85);
	[select_dloc3]	x = 43&o43=2 -> 1:(x' = 100);
	[select_dloc4]	x = 43&o43=3 -> 1:(x' = 115);
	[select_dloc1]	x = 44&o44=0 -> 1:(x' = 71);
	[select_dloc2]	x = 44&o44=1 -> 1:(x' = 86);
	[select_dloc3]	x = 44&o44=2 -> 1:(x' = 101);
	[select_dloc4]	x = 44&o44=3 -> 1:(x' = 116);
	[select_dloc1]	x = 45&o45=0 -> 1:(x' = 76);
	[select_dloc2]	x = 45&o45=1 -> 1:(x' = 91);
	[select_dloc3]	x = 45&o45=2 -> 1:(x' = 106);
	[select_dloc4]	x = 45&o45=3 -> 1:(x' = 121);
	[select_dloc1]	x = 46&o46=0 -> 1:(x' = 77);
	[select_dloc2]	x = 46&o46=1 -> 1:(x' = 92);
	[select_dloc3]	x = 46&o46=2 -> 1:(x' = 107);
	[select_dloc4]	x = 46&o46=3 -> 1:(x' = 122);
	[select_dloc1]	x = 47&o47=0 -> 1:(x' = 78);
	[select_dloc2]	x = 47&o47=1 -> 1:(x' = 93);
	[select_dloc3]	x = 47&o47=2 -> 1:(x' = 108);
	[select_dloc4]	x = 47&o47=3 -> 1:(x' = 123);
	[select_dloc1]	x = 48&o48=0 -> 1:(x' = 79);
	[select_dloc2]	x = 48&o48=1 -> 1:(x' = 94);
	[select_dloc3]	x = 48&o48=2 -> 1:(x' = 109);
	[select_dloc4]	x = 48&o48=3 -> 1:(x' = 124);
	[select_dloc1]	x = 49&o49=0 -> 1:(x' = 66);
	[select_dloc2]	x = 49&o49=1 -> 1:(x' = 81);
	[select_dloc3]	x = 49&o49=2 -> 1:(x' = 96);
	[select_dloc4]	x = 49&o49=3 -> 1:(x' = 111);
	[select_dloc1]	x = 50&o50=0 -> 1:(x' = 67);
	[select_dloc2]	x = 50&o50=1 -> 1:(x' = 82);
	[select_dloc3]	x = 50&o50=2 -> 1:(x' = 97);
	[select_dloc4]	x = 50&o50=3 -> 1:(x' = 112);
	[select_dloc1]	x = 51&o51=0 -> 1:(x' = 70);
	[select_dloc2]	x = 51&o51=1 -> 1:(x' = 85);
	[select_dloc3]	x = 51&o51=2 -> 1:(x' = 100);
	[select_dloc4]	x = 51&o51=3 -> 1:(x' = 115);
	[select_dloc1]	x = 52&o52=0 -> 1:(x' = 71);
	[select_dloc2]	x = 52&o52=1 -> 1:(x' = 86);
	[select_dloc3]	x = 52&o52=2 -> 1:(x' = 101);
	[select_dloc4]	x = 52&o52=3 -> 1:(x' = 116);
	[select_dloc1]	x = 53&o53=0 -> 1:(x' = 74);
	[select_dloc2]	x = 53&o53=1 -> 1:(x' = 89);
	[select_dloc3]	x = 53&o53=2 -> 1:(x' = 104);
	[select_dloc4]	x = 53&o53=3 -> 1:(x' = 119);
	[select_dloc1]	x = 54&o54=0 -> 1:(x' = 75);
	[select_dloc2]	x = 54&o54=1 -> 1:(x' = 90);
	[select_dloc3]	x = 54&o54=2 -> 1:(x' = 105);
	[select_dloc4]	x = 54&o54=3 -> 1:(x' = 120);
	[select_dloc1]	x = 55&o55=0 -> 1:(x' = 78);
	[select_dloc2]	x = 55&o55=1 -> 1:(x' = 93);
	[select_dloc3]	x = 55&o55=2 -> 1:(x' = 108);
	[select_dloc4]	x = 55&o55=3 -> 1:(x' = 123);
	[select_dloc1]	x = 56&o56=0 -> 1:(x' = 79);
	[select_dloc2]	x = 56&o56=1 -> 1:(x' = 94);
	[select_dloc3]	x = 56&o56=2 -> 1:(x' = 109);
	[select_dloc4]	x = 56&o56=3 -> 1:(x' = 124);
	[select_dloc1]	x = 57&o57=0 -> 1:(x' = 65);
	[select_dloc2]	x = 57&o57=1 -> 1:(x' = 80);
	[select_dloc3]	x = 57&o57=2 -> 1:(x' = 95);
	[select_dloc4]	x = 57&o57=3 -> 1:(x' = 110);
	[select_dloc1]	x = 58&o58=0 -> 1:(x' = 67);
	[select_dloc2]	x = 58&o58=1 -> 1:(x' = 82);
	[select_dloc3]	x = 58&o58=2 -> 1:(x' = 97);
	[select_dloc4]	x = 58&o58=3 -> 1:(x' = 112);
	[select_dloc1]	x = 59&o59=0 -> 1:(x' = 69);
	[select_dloc2]	x = 59&o59=1 -> 1:(x' = 84);
	[select_dloc3]	x = 59&o59=2 -> 1:(x' = 99);
	[select_dloc4]	x = 59&o59=3 -> 1:(x' = 114);
	[select_dloc1]	x = 60&o60=0 -> 1:(x' = 71);
	[select_dloc2]	x = 60&o60=1 -> 1:(x' = 86);
	[select_dloc3]	x = 60&o60=2 -> 1:(x' = 101);
	[select_dloc4]	x = 60&o60=3 -> 1:(x' = 116);
	[select_dloc1]	x = 61&o61=0 -> 1:(x' = 73);
	[select_dloc2]	x = 61&o61=1 -> 1:(x' = 88);
	[select_dloc3]	x = 61&o61=2 -> 1:(x' = 103);
	[select_dloc4]	x = 61&o61=3 -> 1:(x' = 118);
	[select_dloc1]	x = 62&o62=0 -> 1:(x' = 75);
	[select_dloc2]	x = 62&o62=1 -> 1:(x' = 90);
	[select_dloc3]	x = 62&o62=2 -> 1:(x' = 105);
	[select_dloc4]	x = 62&o62=3 -> 1:(x' = 120);
	[select_dloc1]	x = 63&o63=0 -> 1:(x' = 77);
	[select_dloc2]	x = 63&o63=1 -> 1:(x' = 92);
	[select_dloc3]	x = 63&o63=2 -> 1:(x' = 107);
	[select_dloc4]	x = 63&o63=3 -> 1:(x' = 122);
	[select_dloc1]	x = 64&o64=0 -> 1:(x' = 79);
	[select_dloc2]	x = 64&o64=1 -> 1:(x' = 94);
	[select_dloc3]	x = 64&o64=2 -> 1:(x' = 109);
	[select_dloc4]	x = 64&o64=3 -> 1:(x' = 124);
	[]	x = 65 -> 1.000000:(x' = 65);
	[]	x = 66 -> 1.000000:(x' = 66);
	[]	x = 67 -> 1.000000:(x' = 67);
	[]	x = 68 -> 1.000000:(x' = 68);
	[]	x = 69 -> 1.000000:(x' = 69);
	[]	x = 70 -> 1.000000:(x' = 70);
	[]	x = 71 -> 1.000000:(x' = 71);
	[]	x = 72 -> 1.000000:(x' = 72);
	[]	x = 73 -> 1.000000:(x' = 73);
	[]	x = 74 -> 1.000000:(x' = 74);
	[]	x = 75 -> 1.000000:(x' = 75);
	[]	x = 76 -> 1.000000:(x' = 76);
	[]	x = 77 -> 1.000000:(x' = 77);
	[]	x = 78 -> 1.000000:(x' = 78);
	[]	x = 79 -> 1.000000:(x' = 79);
	[]	x = 80 -> 1.000000:(x' = 80);
	[]	x = 81 -> 1.000000:(x' = 81);
	[]	x = 82 -> 1.000000:(x' = 82);
	[]	x = 83 -> 1.000000:(x' = 83);
	[]	x = 84 -> 1.000000:(x' = 84);
	[]	x = 85 -> 1.000000:(x' = 85);
	[]	x = 86 -> 1.000000:(x' = 86);
	[]	x = 87 -> 1.000000:(x' = 87);
	[]	x = 88 -> 1.000000:(x' = 88);
	[]	x = 89 -> 1.000000:(x' = 89);
	[]	x = 90 -> 1.000000:(x' = 90);
	[]	x = 91 -> 1.000000:(x' = 91);
	[]	x = 92 -> 1.000000:(x' = 92);
	[]	x = 93 -> 1.000000:(x' = 93);
	[]	x = 94 -> 1.000000:(x' = 94);
	[]	x = 95 -> 1.000000:(x' = 95);
	[]	x = 96 -> 1.000000:(x' = 96);
	[]	x = 97 -> 1.000000:(x' = 97);
	[]	x = 98 -> 1.000000:(x' = 98);
	[]	x = 99 -> 1.000000:(x' = 99);
	[]	x = 100 -> 1.000000:(x' = 100);
	[]	x = 101 -> 1.000000:(x' = 101);
	[]	x = 102 -> 1.000000:(x' = 102);
	[]	x = 103 -> 1.000000:(x' = 103);
	[]	x = 104 -> 1.000000:(x' = 104);
	[]	x = 105 -> 1.000000:(x' = 105);
	[]	x = 106 -> 1.000000:(x' = 106);
	[]	x = 107 -> 1.000000:(x' = 107);
	[]	x = 108 -> 1.000000:(x' = 108);
	[]	x = 109 -> 1.000000:(x' = 109);
	[]	x = 110 -> 1.000000:(x' = 110);
	[]	x = 111 -> 1.000000:(x' = 111);
	[]	x = 112 -> 1.000000:(x' = 112);
	[]	x = 113 -> 1.000000:(x' = 113);
	[]	x = 114 -> 1.000000:(x' = 114);
	[]	x = 115 -> 1.000000:(x' = 115);
	[]	x = 116 -> 1.000000:(x' = 116);
	[]	x = 117 -> 1.000000:(x' = 117);
	[]	x = 118 -> 1.000000:(x' = 118);
	[]	x = 119 -> 1.000000:(x' = 119);
	[]	x = 120 -> 1.000000:(x' = 120);
	[]	x = 121 -> 1.000000:(x' = 121);
	[]	x = 122 -> 1.000000:(x' = 122);
	[]	x = 123 -> 1.000000:(x' = 123);
	[]	x = 124 -> 1.000000:(x' = 124);
	[]	x = 125 -> 1.000000:(x' = 125);
	[]	x = 126 -> 1.000000:(x' = 126);
	[]	x = 127 -> 1.000000:(x' = 127);
	[]	x = 128 -> 1.000000:(x' = 128);
endmodule 

rewards "SV"
	[select_xloc1]true:0.945270695554;
	[select_xloc2]true:0.901427457611;
	[select_xloc3]true:0.0305899830336;
	[select_xloc4]true:0.0254458609935;
endrewards

rewards "EC"
	[select_xloc1]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:3.03734527162;
	[select_xloc1]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:4.01297210127;
	[select_xloc1]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:4.58613332359;
	[select_dloc1]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:3.94491224017;
	[select_dloc1]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:2.51731330661;
	[select_dloc1]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:3.20226951621;
	[select_dloc1]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:2.33886431395;
	[select_xloc2]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:3.03734527162;
	[select_xloc2]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:3.30492341939;
	[select_xloc2]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:3.4361537455;
	[select_dloc2]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:3.63032196506;
	[select_dloc2]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:4.0286872969;
	[select_dloc2]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:5.21083871793;
	[select_dloc2]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:4.53466882575;
	[select_xloc3]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:4.01297210127;
	[select_xloc3]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:3.30492341939;
	[select_xloc3]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:2.74379550805;
	[select_dloc3]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:2.74050361063;
	[select_dloc3]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:1.5142081304;
	[select_dloc3]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:2.93763383454;
	[select_dloc3]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:3.67726240862;
	[select_xloc4]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:4.58613332359;
	[select_xloc4]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:3.4361537455;
	[select_xloc4]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:2.74379550805;
	[select_dloc4]x=1|x=2|x=3|x=4|x=5|x=6|x=7|x=8|x=33|x=34|x=35|x=36|x=37|x=38|x=39|x=40|x=125:3.45710609665;
	[select_dloc4]x=9|x=10|x=11|x=12|x=13|x=14|x=15|x=16|x=41|x=42|x=43|x=44|x=45|x=46|x=47|x=48|x=126:3.5473178342;
	[select_dloc4]x=17|x=18|x=19|x=20|x=21|x=22|x=23|x=24|x=49|x=50|x=51|x=52|x=53|x=54|x=55|x=56|x=127:4.84829687879;
	[select_dloc4]x=25|x=26|x=27|x=28|x=29|x=30|x=31|x=32|x=57|x=58|x=59|x=60|x=61|x=62|x=63|x=64|x=65|x=66|x=67|x=68|x=69|x=70|x=71|x=72|x=73|x=74|x=75|x=76|x=77|x=78|x=79|x=128:4.1129507461;
endrewards

//const int o0 (int)[0:3];
//const int o1 (int)[0:2];
//const int o2 (int)[0:1];
//const int o3 (int)[0:1];
//const int o5 (int)[0:1];
//const int o9 (int)[0:2];
//const int o10 (int)[0:1];
//const int o11 (int)[0:1];
//const int o13 (int)[0:1];
//const int o17 (int)[0:2];
//const int o18 (int)[0:1];
//const int o19 (int)[0:1];
//const int o21 (int)[0:1];
//const int o25 (int)[0:2];
//const int o26 (int)[0:1];
//const int o27 (int)[0:1];
//const int o29 (int)[0:1];
//const int o33 (int)[0:3];
//const int o34 (int)[0:3];
//const int o35 (int)[0:3];
//const int o36 (int)[0:3];
//const int o37 (int)[0:3];
//const int o38 (int)[0:3];
//const int o39 (int)[0:3];
//const int o40 (int)[0:3];
//const int o41 (int)[0:3];
//const int o42 (int)[0:3];
//const int o43 (int)[0:3];
//const int o44 (int)[0:3];
//const int o45 (int)[0:3];
//const int o46 (int)[0:3];
//const int o47 (int)[0:3];
//const int o48 (int)[0:3];
//const int o49 (int)[0:3];
//const int o50 (int)[0:3];
//const int o51 (int)[0:3];
//const int o52 (int)[0:3];
//const int o53 (int)[0:3];
//const int o54 (int)[0:3];
//const int o55 (int)[0:3];
//const int o56 (int)[0:3];
//const int o57 (int)[0:3];
//const int o58 (int)[0:3];
//const int o59 (int)[0:3];
//const int o60 (int)[0:3];
//const int o61 (int)[0:3];
//const int o62 (int)[0:3];
//const int o63 (int)[0:3];
//const int o64 (int)[0:3];

