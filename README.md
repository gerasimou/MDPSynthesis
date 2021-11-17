# EvoPoli

EvoPoli is a search-based software engineering approach and tool that employs multiobjective optimisation genetic algorithms to automate the synthesis of approximate Pareto-optimal policies for MDPS with complex combinations of constraints and optimisation objectives.

EvoPoli is the outcome of the research paper "Evolutionary-Guided Synthesis of Verified Pareto-Optimal MDP Policies" published at the [36th IEEE/ACM International Conference on Automated Software Engineering](https://conf.researchr.org/home/ase-2021)



Instructions
------------

EvoPoli is a Java-based tool build on top of [EvoChecker](https://github.com/gerasimou/EvoChecker) and uses Maven for managing the project and its dependencies, and for generating the executable jars.

1. Import the project in your IDE of preference

2. Set the following environment variable (In Eclipse go to Run / Run Configurations / Environment tab / New)
   > OSX: DYLD\_LIBRARY\_PATH = libs/runtime
   > 
   > *NIX: LD\_LIBRARY\_PATH = libs/runtime
   
3. Specify the configuration parameters in file [config.properties](https://github.com/gerasimou/MDPSynthesis/blob/master/config.properties)

4. Run [MainMDPSynthesis](https://github.com/gerasimou/MDPSynthesis/blob/master/src/main/java/mdpSynthesis/MainMDPSynthesis.java)
