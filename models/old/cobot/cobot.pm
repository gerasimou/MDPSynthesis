mdp

//const int dummy;
const double pf_rngDetEnterCell = .05; 
const double pf_rngDetApproachWeldspot = .05; 
const double pf_lgtBar = .05; 

// evolve int dpSC [0 .. 1]; 
// evolve int dpMaint [0 .. 1]; 
// evolve int dpHCmit [0 .. 2]; 
// evolve int dpHCres [0 .. 1]; 
// evolve double pf_opExitPlant [0.5 .. 0.9]; 

const int dpSC = 1; 
const int dpMaint = 1; 
const int dpHCmit = 2; 
const int dpHCres = 1; 
const double pf_opExitPlant = 0.5; 
const double prMisHC = 0.3;

const double pf_opEnterCell = 0.1;

const none = 0; const vl = 1; const l = 3; const m = 5; const h = 7; const vh = 10;
const micro = 1; const macro = 5;

const HCStOffVis = 0; const HCSrmstIdleVis = 1; const HCStOffAud = 2;
const HCres = 0; const HCres2 = 1;
const off = 0; const idle = 1; const exchWrkp = 2; const welding = 3; 
const normal = 0; const hguid = 1; const ssmon = 2; const pflim = 3; const srmst = 4; const stopped = 5; 
const inact = 0; const act = 1; const mit = 2; const mis = 3; const sfd = 4; 
const atTable = 0; const sharedTbl = 1; const inCell = 2; const atWeldSpot = 3; 
const empty = 0; const left = 1; const right = 2; const both = 3; 
const far = 0; const near = 1; const close = 2; 
const ok = 0; const leaveArea = 1; const resetCtr = 2; 
const sc = 0; const wc = 1; const op = 2;
const ag = 2; 

module workcell 
t: 		[0..2] 	init 0; 
s:              [0..1]  init 0; 
rloc: 		[0..3] 	init 2;
hloc: 		[0..3] 	init 0;
reffocc: 	[0..1] 	init 0; 
wps: 		[0..3] 	init 0;
wpfin: 		[0..1] 	init 0;
mntDone: 	[0..1] 	init 0; 
dntFlg_enterCell: [0..1] init 0; 
dntFlg_exitPlant: [0..1] init 0; 
notif: 		[0..2] 	init 0;
notif_leaveWrkb: [0..1] init 0; 
lgtBar: 	[0..1] 	init 0; 
rngDet: 	[0..2] 	init 0; 
ract: 		[0..3] 	init 0;
wact: 		[0..3] 	init 0;
hact: 		[0..3] 	init 0;
safmod: 	[0..5] 	init 0;
HCp: 		[0..4] 	init 0;

[h_start] !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot)
                         | (ract=welding & wact=welding & rngDet=close))
                       & wpfin=1 & wps=empty & reffocc=0 & mntDone=1))
  & safmod!=stopped & wact=off & wpfin=0 & ract=off
  & !((ract=welding & wact=welding & hloc=atWeldSpot)
      | (ract=welding & wact=welding & rngDet=close))
  -> (wact'=idle)&(ract'=exchWrkp)&(hact'=idle);
[p_final] (HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) 
	& !(ract=off & wact=off) & !((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1 -> (hact'=off)&(ract'=off)&(wact'=off);


[wc_idle] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) -> (t'=sc);

[r_moveToTable] t=wc 
& !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) 
& (safmod=normal|safmod=ssmon|safmod=pflim) & ract=exchWrkp & (rloc != sharedTbl) 
& (((wps!=right) & reffocc=1) | (wps=left & (reffocc=0))) 
-> (rloc'=sharedTbl)&(t'=sc);
[r_grabLeftWorkpiece] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim|safmod=hguid) & ract=exchWrkp & rloc=sharedTbl & reffocc=0 & wps=left -> (reffocc'=1)&(wpfin'=0)&(wps'=empty)&(t'=sc);
[r_placeWorkpieceRight] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim|safmod=hguid) & ract=exchWrkp & rloc=sharedTbl & reffocc=1 & wpfin=1 & wps=empty -> (reffocc'=0)&(wps'=right)&(t'=sc);
[r_placeWorkpieceRight] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim|safmod=hguid) & ract=exchWrkp & rloc=sharedTbl & reffocc=1 & wpfin=1 & wps=left -> (reffocc'=0)&(wps'=both)&(t'=sc);

[r_moveToWelder] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim) & ract=exchWrkp & reffocc=1 & wpfin=0 -> (ract'=welding)&(rloc'=atWeldSpot)&(t'=sc);


[rw_weldStep] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim) & (safmod=normal|safmod=ssmon) // TODO: simplify
	& ract=welding & (wact=idle|wact=welding) & wpfin=0 
	-> (wpfin'=1)&(wact'=welding)&(t'=sc);
[rw_leaveWelder] t=wc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (safmod=normal|safmod=ssmon|safmod=pflim) 
	& ract=welding & (wact=welding | wact=idle) & wps!=both & wpfin=1 
	-> (ract'=exchWrkp)&(rloc'=inCell)&(wact'=idle)&(t'=sc); 

[h_idle] t=op & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) -> (t'=sc);

// A:main work
[h_placeWorkpieceLeft] t=op & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (hact=idle|hact=exchWrkp) & hloc=atTable & wps=empty & reffocc=0 & wpfin=0
  -> (1-pf_lgtBar):(hact'=exchWrkp)&(hloc'=sharedTbl)&(wps'=left)&(lgtBar'=1)&(t'=sc)
  +
  pf_lgtBar:(hact'=exchWrkp)&(hloc'=sharedTbl)&(wps'=left)&(t'=sc);
[h_withDrawArm] t=op & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & hloc=sharedTbl -> (hact'=idle)&(hloc'=atTable)&(lgtBar'=0)&(t'=sc);
[h_grabRightWorkpiece] t=op & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & (hact=idle|hact=exchWrkp) & (hloc=atTable|hloc=sharedTbl) & wps=right -> (hact'=idle)&(hloc'=atTable)&(wps'=empty)&(lgtBar'=0)&(t'=sc);

// A:maintenance
[hi_mayEnterCell] t=op & dpMaint=1 & dntFlg_enterCell=0 & mntDone=0 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) 		// deontic flag and end-of-cycle check
	& wps!=empty & hact=idle & (hloc!=inCell & hloc!=atWeldSpot) & wpfin=0 	
	-> (((ract!=exchWrkp & ract!=welding & wact!=welding))?1:pf_opEnterCell):(dntFlg_enterCell'=1)	
	  + (((ract!=exchWrkp & ract!=welding & wact!=welding))?0:(1-pf_opEnterCell)):true;				
[h_enterCell] t=op & dntFlg_enterCell=1 
	& hact=idle & (hloc!=inCell & hloc!=atWeldSpot) & wpfin=0 
	-> (1-pf_rngDetEnterCell):(hloc'=inCell)&(rngDet'=near)&(t'=sc)
	+ pf_rngDetEnterCell:(hloc'=inCell)&(t'=sc);		
[h_approachWeldSpot] t=op & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & mntDone=0 & hact=idle & hloc=inCell -> 
	(1-pf_rngDetApproachWeldspot):(hloc'=atWeldSpot)&(mntDone'=1)&(dntFlg_enterCell'=0)&(rngDet'=close)&(t'=sc)
	+ pf_rngDetApproachWeldspot:(hloc'=atWeldSpot)&(mntDone'=1)&(dntFlg_enterCell'=0)&(t'=sc);
[hi_mayExitPlant] t=op & dntFlg_exitPlant=0 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1))
        & (hloc=inCell | hloc=atWeldSpot)
	-> ((notif=leaveArea)?(1-pf_opExitPlant):.6):(dntFlg_exitPlant'=1)
	  +((notif=leaveArea)?pf_opExitPlant:.4):true;

[h_exitPlant] t=op & dntFlg_exitPlant=1 
	& !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & hact!=off & (hloc=inCell | hloc=atWeldSpot) & (mntDone=1 | notif=leaveArea) 
	& (hloc!=inCell | hloc!=atWeldSpot) 
	-> 
	((HCp!=mis & ((ract=welding & wact=welding & rngDet=close) | (ract=welding & wact=welding & hloc=atWeldSpot)))?prMisHC:0):(HCp'=mis) & (hloc'=atTable)&(dntFlg_enterCell'=0)&(dntFlg_exitPlant'=0)&(rngDet'=far)&(t'=sc)
	+ ((HCp!=mis & ((ract=welding & wact=welding & rngDet=close) | (ract=welding & wact=welding & hloc=atWeldSpot)))?(1-prMisHC):1):(hloc'=atTable)&(dntFlg_enterCell'=0)&(dntFlg_exitPlant'=0)&(rngDet'=far)&(t'=sc);

////// safetyCtr /////////////////////////////////////////////////////
[si_idle] t=sc & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & HCp=inact -> (s'=mod(s+1,ag))&(t'=s+1); 
// & dpSC=0

[si_HCact] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & wact=welding & ract=welding & (ract=welding & wact=welding & rngDet=close) & !(HCp=act | HCp=mis) -> (HCp'=act);
[si_HCact] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & wact=off & ract=welding & (ract=welding & wact=welding & rngDet=close) & !(HCp=act | HCp=mis) -> (HCp'=act); 
[si_HCact] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & wact=welding & ract=off & (ract=welding & wact=welding & rngDet=close) & !(HCp=act | HCp=mis) -> (HCp'=act);

[s_HCstop2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & wact=welding & ract=welding & HCp=act -> (ract'=off)&(wact'=off)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCstop] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & wact=welding & ract=welding & HCp=act -> (ract'=off)&(wact'=off)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HChalt] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & wact=welding & ract=welding & HCp=act -> (wact'=idle)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HChalt] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & wact=welding & ract=off & HCp=act -> (wact'=idle)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCSrmstIdleVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & safmod=normal & HCp=act -> (safmod'=srmst)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCSrmstIdleVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & safmod=hguid & HCp=act -> (safmod'=srmst)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCSrmstIdleVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & safmod=ssmon & HCp=act -> (safmod'=srmst)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCSrmstIdleVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & safmod=pflim & HCp=act -> (safmod'=srmst)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCStOffAudsafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & safmod=normal & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffAudsafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & safmod=hguid & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffAudsafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & safmod=ssmon & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffAudsafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & safmod=pflim & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffAudsafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & safmod=srmst & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCStOffVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & safmod=normal & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & safmod=hguid & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & safmod=ssmon & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & safmod=pflim & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffVissafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & safmod=srmst & HCp=act -> (safmod'=stopped)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCSrmstIdleVisfun] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCSrmstIdleVis & (HCp=act) & !((notif=leaveArea)) -> (notif'=leaveArea)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffAudfun] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffAud & (HCp=act) & !((notif=leaveArea)) -> (notif'=leaveArea)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCStOffVisfun] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCmit=HCStOffVis & (HCp=act) & !((notif=leaveArea)) -> (notif'=leaveArea)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCmit] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & HCp=act & ((notif=leaveArea) | (notif=leaveArea) | (notif=leaveArea)) & !(ract=welding & wact=welding & rngDet=close) -> (HCp'=mit);

[si_HCres2fun] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & HCp=mit & !(ract=welding & wact=welding & rngDet=close) & ((notif=leaveArea) | (notif=leaveArea) | (notif=leaveArea)) & notif=leaveArea & !(hloc=inCell | hloc=atWeldSpot) -> (notif'=ok)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCresfun] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & HCp=mit & !(ract=welding & wact=welding & rngDet=close) & ((notif=leaveArea) | (notif=leaveArea) | (notif=leaveArea)) & notif=leaveArea & !(hloc=inCell | hloc=atWeldSpot) -> (notif'=ok)&(s'=mod(s+1,ag))&(t'=s+1);

[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=normal & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=hguid & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=ssmon & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=pflim & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=srmst & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCres2safmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & safmod=stopped & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=normal & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=hguid & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=ssmon & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=pflim & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=srmst & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);
[si_HCressafmod] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & safmod=stopped & HCp=mit & !(hloc=inCell | hloc=atWeldSpot) & (notif=ok) -> (safmod'=normal)&(HCp'=sfd)&(s'=mod(s+1,ag))&(t'=s+1);

[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=exchWrkp & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=welding & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=off & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=exchWrkp & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=welding & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=off & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=exchWrkp & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=welding & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume2] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres2 & ract=off & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=welding)&(wact'=welding)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=exchWrkp & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=welding & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=off & wact=welding & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=exchWrkp & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=welding & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=off & wact=idle & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=exchWrkp & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=welding & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
[s_HCresume] t=sc & dpSC=1 & !(HCp=mis | (!((ract=welding & wact=welding & hloc=atWeldSpot) | (ract=welding & wact=welding & rngDet=close)) & wpfin=1 & wps=empty & reffocc=0 & mntDone=1)) & dpHCres=HCres & ract=off & wact=off & HCp=sfd & !(ract=welding & wact=welding & rngDet=close) & (notif=ok) -> (ract'=exchWrkp)&(wact'=exchWrkp)&(HCp'=inact)&(s'=mod(s+1,ag))&(t'=s+1);
endmodule

////////////////////////////////////////////////////////////////////////////////
// Reward structures
rewards "nuisance"
// HC-mode: HCSrmstIdleVis
[si_HCSrmstIdleVisfun] (HCp=1 | HCp=2) 	: 4.0;
[si_HCSrmstIdleVissafmod] (HCp=1 | HCp=2) 	: 4.0;
[s_HChalt] (HCp=1 | HCp=2) 	: 4.0;
// HC-mode: HCres2
[si_HCres2safmod] (HCp=1 | HCp=2) 	: 7.0;
[s_HCresume2] (HCp=1 | HCp=2) 	: 7.0;
[si_HCres2fun] (HCp=1 | HCp=2) 	: 7.0;
// HC-mode: HCStOffAud
[si_HCStOffAudsafmod] (HCp=1 | HCp=2) 	: 6.0;
[s_HCstop2] (HCp=1 | HCp=2) 	: 6.0;
[si_HCStOffAudfun] (HCp=1 | HCp=2) 	: 6.0;
// HC-mode: HCStOffVis
[si_HCStOffVissafmod] (HCp=1 | HCp=2) 	: 5.0;
[si_HCStOffVisfun] (HCp=1 | HCp=2) 	: 5.0;
[s_HCstop] (HCp=1 | HCp=2) 	: 5.0;
// HC-mode: HCres
[si_HCressafmod] (HCp=1 | HCp=2) 	: 5.0;
[s_HCresume] (HCp=1 | HCp=2) 	: 5.0;
[si_HCresfun] (HCp=1 | HCp=2) 	: 5.0;
endrewards

