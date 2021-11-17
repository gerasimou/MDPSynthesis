

mdp

// parameters
const int n_resources = 3;
const int n_tasks = 2;
const int n_sensors = 2;


// sensor resources
const int resource1=1;
const int resource2=2;

// network configuration
const int e12=1;
const int e21=e12;

module controller // schedules the algorithm

	// algorithm status
	status : [0..5];

	// task resource indicator variables
	t1_r1 : [0..1];
	t1_r2 : [0..1];
	t1_r3 : [0..1];
	
	t2_r1 : [0..1];
	t2_r2 : [0..1];
	t2_r3 : [0..1];

	// schedule placeholders
	turn1 : [0..n_sensors];
	turn2 : [0..n_sensors];

	// selecting schedule uniformly at random
	[] status=0 -> 1/2 : (turn1'=1) & (turn2'=2) & (status'=1)
		 + 1/2 : (turn1'=2) & (turn2'=1) & (status'=1);


	// initialising non-empty tasks uniformly at random
	[] status=1 -> 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=0) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=0) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=0) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=0) & (t2_r2'=1) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=0) & (t2_r3'=1) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=0) & (status'=2)
		 + 1/49 : (t1_r1'=1) & (t1_r2'=1) & (t1_r3'=1) & (t2_r1'=1) & (t2_r2'=1) & (t2_r3'=1) & (status'=2);

	// executing the schedule

	// 1st round
	[str1] status=2 & turn1=1 -> (status'=2);
	[fin1] status=2 & turn1=1 -> (status'=3);
	[str2] status=2 & turn1=2 -> (status'=2);
	[fin2] status=2 & turn1=2 -> (status'=3);

	// 2nd round
	[str1] status=3 & turn2=1 -> (status'=3);
	[fin1] status=3 & turn2=1 -> (status'=4);
	[str2] status=3 & turn2=2 -> (status'=3);
	[fin2] status=3 & turn2=2 -> (status'=4);


	[] status=4 -> (status'=5);

	[] status=5 -> true;

endmodule

module sensor1

	state1 : [0..1];

	// team membership indicators
	m1_t1 : [0..1];
	m1_t2 : [0..1];

	// starting turn, selecting order of tasks
	[str1] state1=0 -> (state1'=1);

	// if there is no team and has required skill - initiating the team
	[] state1=1 & !committed & team_size_t1=0 & has_resource_t1 -> (m1_t1'=1);
	[] state1=1 & !committed & team_size_t2=0 & has_resource_t2 -> (m1_t2'=1);

	// if team already exists and one of the neighbours is in it - joining the team 
	[] state1=1 & !committed & team_size_t1>0 & can_join_t1 & has_resource_t1 & !resource_filled_t1 -> (m1_t1'=1);
	[] state1=1 & !committed & team_size_t2>0 & can_join_t2 & has_resource_t2 & !resource_filled_t2 -> (m1_t2'=1);
	
	[fin1] state1>0 -> (state1'=0); 

endmodule

module sensor2 = sensor1 
[ 
	state1=state2, 

	str1=str2,
	fin1=fin2,

	m1_t1=m2_t1,
	m1_t2=m2_t2,

	m2_t1=m1_t1,
	m2_t2=m1_t2,

	resource1=resource2,	
	resource2=resource1,

	e12=e21,
	e13=e23,
	e14=e24,
	e15=e25,

	e21=e12,
	e23=e13,
	e24=e14,
	e25=e15
] 
endmodule




// agent is committed to some team
formula committed = (m1_t1+m1_t2) > 0;

// formulae to compute team sizes
formula team_size_t1 = m1_t1+m2_t1;
formula team_size_t2 = m1_t2+m2_t2;

// formulae to check whether the agent can join the team
formula can_join_t1 = e12*m2_t1  > 0;
formula can_join_t2 = e12*m2_t2  > 0;

// formulae to check whether agent has the resource required by the task
formula has_resource_t1 = ( (t1_r1=1&resource1=1) | (t1_r2=1&resource1=2) | (t1_r3=1&resource1=3) );
formula has_resource_t2 = ( (t2_r1=1&resource1=1) | (t2_r2=1&resource1=2) | (t2_r3=1&resource1=3) );

// formulae to check whether the resource of an agent has been already filled in the team
formula resource_filled_t1 = (m2_t1=1 & resource1=resource2);
formula resource_filled_t2 = (m2_t2=1 & resource1=resource2);

// formula to compute team initiation probability (assuming each agent has at least one connection)
formula IP = (e12*(1-((m2_t1+m2_t2)=0?0:1))) / (e12);




// labels and formulae for property specification 
formula finished = (status=4);
label "end" = (status=5);


formula task1_completed = finished 
		 	 & ((t1_r1=1)=>((m1_t1=1&resource1=1)|(m2_t1=1&resource2=1)))
			 & ((t1_r2=1)=>((m1_t1=1&resource1=2)|(m2_t1=1&resource2=2)))
			 & ((t1_r3=1)=>((m1_t1=1&resource1=3)|(m2_t1=1&resource2=3)));

formula task2_completed = finished
			 & ((t2_r1=1)=>((m1_t2=1&resource1=1)|(m2_t2=1&resource2=1)))
			 & ((t2_r2=1)=>((m1_t2=1&resource1=2)|(m2_t2=1&resource2=2)))
			 & ((t2_r3=1)=>((m1_t2=1&resource1=3)|(m2_t2=1&resource2=3)));



formula agent1_joins_successful_team = (task1_completed & m1_t1=1) | (task2_completed & m1_t2=1);
formula agent1_joins_successful_team_of_1 = (task1_completed & m1_t1=1 & team_size_t1=1) | (task2_completed & m1_t2=1 & team_size_t2=1);
formula agent1_joins_successful_team_of_2 = (task1_completed & m1_t1=1 & team_size_t1=2) | (task2_completed & m1_t2=1 & team_size_t2=2);
formula agent1_joins_successful_team_of_3 = (task1_completed & m1_t1=1 & team_size_t1=3) | (task2_completed & m1_t2=1 & team_size_t2=3);

formula agent2_joins_successful_team = (task1_completed & m2_t1=1) | (task2_completed & m2_t2=1);
formula agent2_joins_successful_team_of_1 = (task1_completed & m2_t1=1 & team_size_t1=1) | (task2_completed & m2_t2=1 & team_size_t2=1);
formula agent2_joins_successful_team_of_2 = (task1_completed & m2_t1=1 & team_size_t1=2) | (task2_completed & m2_t2=1 & team_size_t2=2);
formula agent2_joins_successful_team_of_3 = (task1_completed & m2_t1=1 & team_size_t1=3) | (task2_completed & m2_t2=1 & team_size_t2=3);

// rewards
rewards "w_1_total"
    [] agent1_joins_successful_team : 1;
    [] agent2_joins_successful_team : 1;
endrewards

rewards "w_2_total"
    [] task1_completed : 1;
    [] task2_completed : 1;
endrewards




