// ----------------------------------------------------------------------------
// tas-reconf.prism - Tele-Assistance System (TAS) Reconfiguration model 
// 2021 Javier Camara 
//
// ----------------------------------------------------------------------------
// This model is based on the Tele Assistance Model Exemplar described in:
// http://homepage.lnu.se/staff/daweaa/TAS/tas.htm
// A comprehensive description of the exemplar can be found in:
//    Danny Weyns, Radu Calinescu: 
//    Tele Assistance: A Self-Adaptive Service-Based System Exemplar.
//    SEAMS@ICSE 2015: 88-92
//    DOI: 10.1109/SEAMS.2015.27
//-----------------------------------------------------------------------------
mdp

// Model params
const MAX_TIMEOUTS=1;
const TIMEOUT_MULT_FACTOR=1;

// enum tasks
formula notSelected = 0;
formula getVitalParams = 1;
formula buttonMsg = 2;

// enum analysis results
formula none = 0;
formula patientOK = 1;
formula changeDrug = 2;
formula changeDose = 3;
formula sendAlarm = 4;

// number of alternative services, per type

//-----------------------------------------------------------------------------
// Reconfiguration module
//-----------------------------------------------------------------------------

//formula reconf_done = (MS1_selected>0 | MS2_selected>0 | MS3_selected>0 | MS4_selected>0 | MS5_selected>0) & (DS1_selected>0) & (AS1_selected>0 | AS2_selected>0 | AS3_selected>0);

formula reconf_done = turn=8;

formula MS_selected = MS1_selected + MS2_selected + MS3_selected + MS4_selected + MS5_selected;
formula DS_selected = DS1_selected;
formula AS_selected = AS1_selected + AS2_selected + AS3_selected;

module reconf
	turn: [0..9] init 0;
	MS1_selected: [0..1] init 0;
	MS2_selected: [0..1] init 0;
	MS3_selected: [0..1] init 0;
	MS4_selected: [0..1] init 0;
	MS5_selected: [0..1] init 0;
	DS1_selected: [0..1] init 1;
	AS1_selected: [0..1] init 0;
	AS2_selected: [0..1] init 0;
	AS3_selected: [0..1] init 0;

	[select_MS1] (turn=0)  -> (MS1_selected'=1) & (turn'=1);
	[select_MS2] (turn=1)  -> (MS2_selected'=1) & (turn'=2);
	[select_MS3] (turn=2)  -> (MS3_selected'=1) & (turn'=3);
	[select_MS4] (turn=3)  -> (MS4_selected'=1) & (turn'=4);
	[select_MS5] (turn=4)  -> (MS5_selected'=1) & (turn'=5);

	[select_AS1] (turn=5) -> (AS1_selected'=1) & (turn'=6);
	[select_AS2] (turn=6) -> (AS2_selected'=1) & (turn'=7);
	[select_AS3] (turn=7) -> (AS3_selected'=1) & (turn'=8);
	
	[skip] (turn=0) -> (turn'=turn+1);
	[skip] (turn=1) -> (turn'=turn+1);
	[skip] (turn=2) -> (turn'=turn+1);
	[skip] (turn=3) -> (turn'=turn+1);
	[skip] (turn=4) & (MS_selected>0)  -> (turn'=turn+1);
	[skip] (turn=5) -> (turn'=turn+1);
	[skip] (turn=6) -> (turn'=turn+1);
	[skip] (turn=7) & (AS_selected>0)  -> (turn'=turn+1);

endmodule


//-----------------------------------------------------------------------------
// TAS Workflow module
//-----------------------------------------------------------------------------

label "success" = workflowOK=true;
label "done" = workflowDone=true;

module TASWorkflow
	task:[notSelected..buttonMsg] init notSelected; 
	analysisResult:[none..sendAlarm] init none;

	MSInvoked: bool init false; 
	DInvoked: bool init false; 
	AInvoked : bool init false;
	workflowOK : bool init false;
	workflowDone : bool init false;

	timeouts:[0..MAX_TIMEOUTS] init MAX_TIMEOUTS;

	[pickTask] (reconf_done) & (task=notSelected) -> 0.5: (task'=getVitalParams) + 0.5: (task'=buttonMsg);

	//1. pickTask selected buttonMsg -- override analysis and go directly to sendAlarm (2b)
	[] (task=buttonMsg) & (!MSInvoked) -> (MSInvoked'=true) & (analysisResult'=sendAlarm); 

	//2. PickTask selected getVitalParams

  [MS1_analyzeDataCall] (task=getVitalParams) & (!MSInvoked) -> (MSInvoked'=true);
	[MS1_analysisResultPatientOK]  (MSInvoked) -> (analysisResult'=patientOK) & (workflowOK'=true) & (workflowDone'=true);
	[MS1_analysisResultChangeDrug] (MSInvoked) -> (analysisResult'=changeDrug);
	[MS1_analysisResultChangeDose] (MSInvoked) -> (analysisResult'=changeDose);
	[MS1_analysisResultSendAlarm]  (MSInvoked) -> (analysisResult'=sendAlarm);
	[MS1_timeout] (timeouts>0) & (MSInvoked)   -> (MSInvoked'=false) & (timeouts'=timeouts-1);
	[MS1_timeout] (timeouts=0) & (MSInvoked)   -> (workflowDone'=true);

  [MS2_analyzeDataCall] (task=getVitalParams) & (!MSInvoked) -> (MSInvoked'=true);
	[MS2_analysisResultPatientOK]  (MSInvoked) -> (analysisResult'=patientOK) & (workflowOK'=true) & (workflowDone'=true);
	[MS2_analysisResultChangeDrug] (MSInvoked) -> (analysisResult'=changeDrug);
	[MS2_analysisResultChangeDose] (MSInvoked) -> (analysisResult'=changeDose);
	[MS2_analysisResultSendAlarm]  (MSInvoked) -> (analysisResult'=sendAlarm);
	[MS2_timeout] (timeouts>0) & (MSInvoked)   -> (MSInvoked'=false) & (timeouts'=timeouts-1);
	[MS2_timeout] (timeouts=0) & (MSInvoked)   -> (workflowDone'=true);

  [MS3_analyzeDataCall] (task=getVitalParams) & (!MSInvoked) -> (MSInvoked'=true);
	[MS3_analysisResultPatientOK]  (MSInvoked) -> (analysisResult'=patientOK) & (workflowOK'=true) & (workflowDone'=true);
	[MS3_analysisResultChangeDrug] (MSInvoked) -> (analysisResult'=changeDrug);
	[MS3_analysisResultChangeDose] (MSInvoked) -> (analysisResult'=changeDose);
	[MS3_analysisResultSendAlarm]  (MSInvoked) -> (analysisResult'=sendAlarm);
	[MS3_timeout] (timeouts>0) & (MSInvoked)   -> (MSInvoked'=false) & (timeouts'=timeouts-1);
	[MS3_timeout] (timeouts=0) & (MSInvoked)   -> (workflowDone'=true);

  [MS4_analyzeDataCall] (task=getVitalParams) & (!MSInvoked) -> (MSInvoked'=true);
	[MS4_analysisResultPatientOK]  (MSInvoked) -> (analysisResult'=patientOK) & (workflowOK'=true) & (workflowDone'=true);
	[MS4_analysisResultChangeDrug] (MSInvoked) -> (analysisResult'=changeDrug);
	[MS4_analysisResultChangeDose] (MSInvoked) -> (analysisResult'=changeDose);
	[MS4_analysisResultSendAlarm]  (MSInvoked) -> (analysisResult'=sendAlarm);
	[MS4_timeout] (timeouts>0) & (MSInvoked)   -> (MSInvoked'=false) & (timeouts'=timeouts-1);
	[MS4_timeout] (timeouts=0) & (MSInvoked)   -> (workflowDone'=true);


  [MS5_analyzeDataCall] (task=getVitalParams) & (!MSInvoked) -> (MSInvoked'=true);
	[MS5_analysisResultPatientOK]  (MSInvoked) -> (analysisResult'=patientOK) & (workflowOK'=true) & (workflowDone'=true);
	[MS5_analysisResultChangeDrug] (MSInvoked) -> (analysisResult'=changeDrug);
	[MS5_analysisResultChangeDose] (MSInvoked) -> (analysisResult'=changeDose);
	[MS5_analysisResultSendAlarm]  (MSInvoked) -> (analysisResult'=sendAlarm);
	[MS5_timeout] (timeouts>0) & (MSInvoked)   -> (MSInvoked'=false) & (timeouts'=timeouts-1);
	[MS5_timeout] (timeouts=0) & (MSInvoked)   -> (workflowDone'=true);
	//2a. Medical Analysis Service determined to change drug or dose

	[DS1_changeDrugCall] (MSInvoked) & (!DInvoked) & (analysisResult=changeDrug) -> (DInvoked'=true);
	[DS1_changeDrugOK]   (DInvoked) -> (workflowOK'=true) & (workflowDone'=true);
	[DS1_changeDoseCall] (MSInvoked) & (!DInvoked) & (analysisResult=changeDose) -> (DInvoked'=true);
	[DS1_changeDoseOK]   (DInvoked) -> (workflowOK'=true) & (workflowDone'=true);
	[DS1_timeout] (timeouts>0) & (DInvoked) -> (DInvoked'=false) & (timeouts'=timeouts-1);
	[DS1_timeout] (timeouts=0) & (DInvoked) -> (workflowDone'=true);

	//2b. Medical Analysis Service determined to raise alarm

  [AS1_sendAlarmCall] (MSInvoked) & (!AInvoked) & (analysisResult=sendAlarm) -> (AInvoked'=true);
	[AS1_sendAlarmOK]   (AInvoked) -> (workflowOK'=true) & (workflowDone'=true);
	[AS1_timeout] (timeouts>0) & (AInvoked) -> (AInvoked'=false) & (timeouts'=timeouts-1);
	[AS1_timeout] (timeouts=0) & (AInvoked) -> (workflowDone'=true);

  [AS2_sendAlarmCall] (MSInvoked) & (!AInvoked) & (analysisResult=sendAlarm) -> (AInvoked'=true);
	[AS2_sendAlarmOK]   (AInvoked) -> (workflowOK'=true) & (workflowDone'=true);
	[AS2_timeout] (timeouts>0) & (AInvoked) -> (AInvoked'=false) & (timeouts'=timeouts-1);
	[AS2_timeout] (timeouts=0) & (AInvoked) -> (workflowDone'=true);

  [AS3_sendAlarmCall] (MSInvoked) & (!AInvoked) & (analysisResult=sendAlarm) -> (AInvoked'=true);
	[AS3_sendAlarmOK]   (AInvoked) -> (workflowOK'=true) & (workflowDone'=true);
	[AS3_timeout] (timeouts>0) & (AInvoked) -> (AInvoked'=false) & (timeouts'=timeouts-1);
	[AS3_timeout] (timeouts=0) & (AInvoked) -> (workflowDone'=true);

endmodule

//-----------------------------------------------------------------------------
// Medical analysis services
//-----------------------------------------------------------------------------

module MS1  
  MS1_serviceOK: bool init false;
  MS1_ready : bool init true;
  
  [MS1_analyzeDataCall] (MS1_selected=1) & (MS1_ready) -> MS1_failure_rate: (MS1_serviceOK'=false) & (MS1_ready'=false) + 1-MS1_failure_rate: (MS1_serviceOK'=true) & (MS1_ready'=false);
  [MS1_analysisResultPatientOK]  (MS1_selected=1) & (!MS1_ready) & (MS1_serviceOK)  -> (MS1_serviceOK'=false) & (MS1_ready'=true);
  [MS1_analysisResultChangeDrug] (MS1_selected=1) & (!MS1_ready) & (MS1_serviceOK)  -> (MS1_serviceOK'=false) & (MS1_ready'=true);
  [MS1_analysisResultChangeDose] (MS1_selected=1) & (!MS1_ready) & (MS1_serviceOK)  -> (MS1_serviceOK'=false) & (MS1_ready'=true);
  [MS1_analysisResultSendAlarm]  (MS1_selected=1) & (!MS1_ready) & (MS1_serviceOK)  -> (MS1_serviceOK'=false) & (MS1_ready'=true);
  [MS1_timeout]                  (MS1_selected=1) & (!MS1_ready) & (!MS1_serviceOK) -> (MS1_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module MS2  
  MS2_serviceOK: bool init false;
  MS2_ready : bool init true;
  
  [MS2_analyzeDataCall] (MS2_selected=1) & (MS2_ready) -> MS2_failure_rate: (MS2_serviceOK'=false) & (MS2_ready'=false) + 1-MS2_failure_rate: (MS2_serviceOK'=true) & (MS2_ready'=false);
  [MS2_analysisResultPatientOK]  (MS2_selected=1) & (!MS2_ready) & (MS2_serviceOK)  -> (MS2_serviceOK'=false) & (MS2_ready'=true);
  [MS2_analysisResultChangeDrug] (MS2_selected=1) & (!MS2_ready) & (MS2_serviceOK)  -> (MS2_serviceOK'=false) & (MS2_ready'=true);
  [MS2_analysisResultChangeDose] (MS2_selected=1) & (!MS2_ready) & (MS2_serviceOK)  -> (MS2_serviceOK'=false) & (MS2_ready'=true);
  [MS2_analysisResultSendAlarm]  (MS2_selected=1) & (!MS2_ready) & (MS2_serviceOK)  -> (MS2_serviceOK'=false) & (MS2_ready'=true);
  [MS2_timeout]                  (MS2_selected=1) & (!MS2_ready) & (!MS2_serviceOK) -> (MS2_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module MS3  
  MS3_serviceOK: bool init false;
  MS3_ready : bool init true;
  
  [MS3_analyzeDataCall] (MS3_selected=1) & (MS3_ready) -> MS3_failure_rate: (MS3_serviceOK'=false) & (MS3_ready'=false) + 1-MS3_failure_rate: (MS3_serviceOK'=true) & (MS3_ready'=false);
  [MS3_analysisResultPatientOK]  (MS3_selected=1) & (!MS3_ready) & (MS3_serviceOK)  -> (MS3_serviceOK'=false) & (MS3_ready'=true);
  [MS3_analysisResultChangeDrug] (MS3_selected=1) & (!MS3_ready) & (MS3_serviceOK)  -> (MS3_serviceOK'=false) & (MS3_ready'=true);
  [MS3_analysisResultChangeDose] (MS3_selected=1) & (!MS3_ready) & (MS3_serviceOK)  -> (MS3_serviceOK'=false) & (MS3_ready'=true);
  [MS3_analysisResultSendAlarm]  (MS3_selected=1) & (!MS3_ready) & (MS3_serviceOK)  -> (MS3_serviceOK'=false) & (MS3_ready'=true);
  [MS3_timeout]                  (MS3_selected=1) & (!MS3_ready) & (!MS3_serviceOK) -> (MS3_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module MS4  
  MS4_serviceOK: bool init false;
  MS4_ready : bool init true;
  
  [MS4_analyzeDataCall] (MS4_selected=1) & (MS4_ready) -> MS4_failure_rate: (MS4_serviceOK'=false) & (MS4_ready'=false) + 1-MS4_failure_rate: (MS4_serviceOK'=true) & (MS4_ready'=false);
  [MS4_analysisResultPatientOK]  (MS4_selected=1) & (!MS4_ready) & (MS4_serviceOK)  -> (MS4_serviceOK'=false) & (MS4_ready'=true);
  [MS4_analysisResultChangeDrug] (MS4_selected=1) & (!MS4_ready) & (MS4_serviceOK)  -> (MS4_serviceOK'=false) & (MS4_ready'=true);
  [MS4_analysisResultChangeDose] (MS4_selected=1) & (!MS4_ready) & (MS4_serviceOK)  -> (MS4_serviceOK'=false) & (MS4_ready'=true);
  [MS4_analysisResultSendAlarm]  (MS4_selected=1) & (!MS4_ready) & (MS4_serviceOK)  -> (MS4_serviceOK'=false) & (MS4_ready'=true);
  [MS4_timeout]                  (MS4_selected=1) & (!MS4_ready) & (!MS4_serviceOK) -> (MS4_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module MS5  
  MS5_serviceOK: bool init false;
  MS5_ready : bool init true;
  
  [MS5_analyzeDataCall] (MS5_selected=1) & (MS5_ready) -> MS5_failure_rate: (MS5_serviceOK'=false) & (MS5_ready'=false) + 1-MS5_failure_rate: (MS5_serviceOK'=true) & (MS5_ready'=false);
  [MS5_analysisResultPatientOK]  (MS5_selected=1) & (!MS5_ready) & (MS5_serviceOK)  -> (MS5_serviceOK'=false) & (MS5_ready'=true);
  [MS5_analysisResultChangeDrug] (MS5_selected=1) & (!MS5_ready) & (MS5_serviceOK)  -> (MS5_serviceOK'=false) & (MS5_ready'=true);
  [MS5_analysisResultChangeDose] (MS5_selected=1) & (!MS5_ready) & (MS5_serviceOK)  -> (MS5_serviceOK'=false) & (MS5_ready'=true);
  [MS5_analysisResultSendAlarm]  (MS5_selected=1) & (!MS5_ready) & (MS5_serviceOK)  -> (MS5_serviceOK'=false) & (MS5_ready'=true);
  [MS5_timeout]                  (MS5_selected=1) & (!MS5_ready) & (!MS5_serviceOK) -> (MS5_ready'=true);
endmodule

//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Drug services
//-----------------------------------------------------------------------------


module DS1
  DS1_serviceOK: bool init false;
  DS1_ready : bool init true;
  
  [DS1_changeDrugCall] (DS1_selected=1) & (DS1_ready) -> DS1_failure_rate: (DS1_serviceOK'=false) & (DS1_ready'=false) + 1-DS1_failure_rate: (DS1_serviceOK'=true) & (DS1_ready'=false);
  [DS1_changeDrugOK]   (DS1_selected=1) & (!DS1_ready) & (DS1_serviceOK)  -> (DS1_serviceOK'=false) & (DS1_ready'=true);

  [DS1_changeDoseCall] (DS1_selected=1) & (DS1_ready) -> DS1_failure_rate: (DS1_serviceOK'=false) & (DS1_ready'=false) + 1-DS1_failure_rate: (DS1_serviceOK'=true) & (DS1_ready'=false);
  [DS1_changeDoseOK]   (DS1_selected=1) & (!DS1_ready) & (DS1_serviceOK)  -> (DS1_serviceOK'=false) & (DS1_ready'=true);

  [DS1_timeout] (DS1_selected=1) & (!DS1_ready) & (!DS1_serviceOK) -> (DS1_ready'=true);
endmodule

//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Alarm services
//-----------------------------------------------------------------------------


module AS1
  AS1_serviceOK: bool init false;
  AS1_ready : bool init true;
  
  [AS1_sendAlarmCall] (AS1_selected=1) & (AS1_ready) -> AS1_failure_rate: (AS1_serviceOK'=false) & (AS1_ready'=false) + 1-AS1_failure_rate: (AS1_serviceOK'=true) & (AS1_ready'=false);
  [AS1_sendAlarmOK]  (AS1_selected=1) & (!AS1_ready) & (AS1_serviceOK)  -> (AS1_serviceOK'=false) & (AS1_ready'=true);
  [AS1_timeout] (AS1_selected=1) & (!AS1_ready) & (!AS1_serviceOK) -> (AS1_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module AS2
  AS2_serviceOK: bool init false;
  AS2_ready : bool init true;
  
  [AS2_sendAlarmCall] (AS2_selected=1) & (AS2_ready) -> AS2_failure_rate: (AS2_serviceOK'=false) & (AS2_ready'=false) + 1-AS2_failure_rate: (AS2_serviceOK'=true) & (AS2_ready'=false);
  [AS2_sendAlarmOK]  (AS2_selected=1) & (!AS2_ready) & (AS2_serviceOK)  -> (AS2_serviceOK'=false) & (AS2_ready'=true);
  [AS2_timeout] (AS2_selected=1) & (!AS2_ready) & (!AS2_serviceOK) -> (AS2_ready'=true);
endmodule

//-----------------------------------------------------------------------------

module AS3
  AS3_serviceOK: bool init false;
  AS3_ready : bool init true;
  
  [AS3_sendAlarmCall] (AS3_selected=1) & (AS3_ready) -> AS3_failure_rate: (AS3_serviceOK'=false) & (AS3_ready'=false) + 1-AS3_failure_rate: (AS3_serviceOK'=true) & (AS3_ready'=false);
  [AS3_sendAlarmOK]  (AS3_selected=1) & (!AS3_ready) & (AS3_serviceOK)  -> (AS3_serviceOK'=false) & (AS3_ready'=true);
  [AS3_timeout] (AS3_selected=1) & (!AS3_ready) & (!AS3_serviceOK) -> (AS3_ready'=true);
endmodule

//-----------------------------------------------------------------------------



//-----------------------------------------------------------------------------
// Reward structures: cost
//-----------------------------------------------------------------------------

rewards "cost"

  // For medical analysis services
  [MS1_analyzeDataCall] true : MS1_cost;    
  [MS2_analyzeDataCall] true : MS2_cost;    
  [MS3_analyzeDataCall] true : MS3_cost;    
  [MS4_analyzeDataCall] true : MS4_cost;    
  [MS5_analyzeDataCall] true : MS5_cost;    

  // For drug services
  [DS1_changeDrugCall] true : DS1_cost;    

  // For alarm services
  [AS1_sendAlarmCall] true : AS1_cost;    
  [AS2_sendAlarmCall] true : AS2_cost;    
  [AS3_sendAlarmCall] true : AS3_cost;    

endrewards


//-----------------------------------------------------------------------------
// Reward structures: time
//-----------------------------------------------------------------------------

rewards "time"

  // For medical analysis services
  [MS1_analysisResultPatientOK]  true : MS1_response_time;
  [MS1_analysisResultChangeDrug] true : MS1_response_time;
  [MS1_analysisResultChangeDose] true : MS1_response_time;
  [MS1_analysisResultSendAlarm]  true : MS1_response_time;
  [MS1_timeout]                  true : MS1_response_time*TIMEOUT_MULT_FACTOR;
  [MS2_analysisResultPatientOK]  true : MS2_response_time;
  [MS2_analysisResultChangeDrug] true : MS2_response_time;
  [MS2_analysisResultChangeDose] true : MS2_response_time;
  [MS2_analysisResultSendAlarm]  true : MS2_response_time;
  [MS2_timeout]                  true : MS2_response_time*TIMEOUT_MULT_FACTOR;
  [MS3_analysisResultPatientOK]  true : MS3_response_time;
  [MS3_analysisResultChangeDrug] true : MS3_response_time;
  [MS3_analysisResultChangeDose] true : MS3_response_time;
  [MS3_analysisResultSendAlarm]  true : MS3_response_time;
  [MS3_timeout]                  true : MS3_response_time*TIMEOUT_MULT_FACTOR;


  [MS4_analysisResultPatientOK]  true : MS4_response_time;
  [MS4_analysisResultChangeDrug] true : MS4_response_time;
  [MS4_analysisResultChangeDose] true : MS4_response_time;
  [MS4_analysisResultSendAlarm]  true : MS4_response_time;
  [MS4_timeout]                  true : MS4_response_time*TIMEOUT_MULT_FACTOR;


  [MS5_analysisResultPatientOK]  true : MS5_response_time;
  [MS5_analysisResultChangeDrug] true : MS5_response_time;
  [MS5_analysisResultChangeDose] true : MS5_response_time;
  [MS5_analysisResultSendAlarm]  true : MS5_response_time;
  [MS5_timeout]                  true : MS5_response_time*TIMEOUT_MULT_FACTOR;
  // For drug services
  [DS1_changeDrugOK]   true : DS1_response_time;
  [DS1_changeDoseOK]   true : DS1_response_time;
  [DS1_timeout]        true : DS1_response_time*TIMEOUT_MULT_FACTOR;
 
  // For alarm services
  [AS1_sendAlarmOK]   true : AS1_response_time;    
  [AS1_timeout]       true : AS1_response_time*TIMEOUT_MULT_FACTOR;    
  [AS2_sendAlarmOK]   true : AS2_response_time;    
  [AS2_timeout]       true : AS2_response_time*TIMEOUT_MULT_FACTOR;    
  [AS3_sendAlarmOK]   true : AS3_response_time;    
  [AS3_timeout]       true : AS3_response_time*TIMEOUT_MULT_FACTOR;    

endrewards

// Script-generated rewards and constants start here

	 formula  MS1_failure_rate=0.06;
	 formula  MS1_cost=9.8;
	 formula  MS1_response_time=22;
	 formula  MS2_failure_rate=0.1;
	 formula  MS2_cost=8.9;
	 formula  MS2_response_time=27;
	 formula  MS3_failure_rate=0.15;
	 formula  MS3_cost=9.3;
	 formula  MS3_response_time=31; 
	 formula  MS4_failure_rate=0.25;
  	 formula  MS4_cost=7.3;
 	 formula  MS4_response_time=29;
 	 formula  MS5_failure_rate=0.05;
  	 formula  MS5_cost=11.9;
	 formula  MS5_response_time=20;
  	 


	 formula  DS1_failure_rate=0.12;
	 formula  DS1_cost=0.1;
	 formula  DS1_response_time=1;

	 formula  AS1_failure_rate=0.3;
	 formula  AS1_cost=4.1;
	 formula  AS1_response_time=11;
	 formula  AS2_failure_rate=0.4;
	 formula  AS2_cost=2.5;
	 formula  AS2_response_time=9;
	 formula  AS3_failure_rate=0.08;
	 formula  AS3_cost=6.8;
	 formula  AS3_response_time=3;
