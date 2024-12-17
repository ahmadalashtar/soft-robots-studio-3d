eas.fitIdx.ikMod = 1;

eas.fitIdx.nodes = 2; % number of links to reach the target's orientation segment (overall sum)

eas.fitIdx.wiggly = 3; % percentage of ondulation of the configuration (avg among configurations)

eas.fitIdx.nodesOnSegment = 4; % number of links on the target's orientation segment (overall sum)

eas.fitIdx.totLengthMod = 5;

eas.fitIdx.ik = 6; % IK fitness (avg among configurations)

eas.fitIdx.totLength = 7; % total length of the robot (avg among configurations - maybe we should use max?)

eas.fitIdx.pen = 8; % penalty for constraints

eas.fitIdx.rank = 9; % rank, used as fitness for selection and survival operators

eas.fitIdx.id = 10; % reference to chromosome in the array of population

eas.fitIdx.algo = 11; % type of algorithm that we are using

eas.fitIdx.runTime = 12; % running time in seconds

eas.fitIdx.taskID = 13; % reference to task number

eas.fitIdx.runID = 14; % reference to iteration number

eas.fitIdx.chromID = 15; % reference to chromosome number

eas.fitIdx.parameterInd1 = 16; % first parameter options index.

eas.fitIdx.parameterInd2 = 17; % second parameter options index.

eas.fitIdx.parameterInd3 = 18; % third parameter options index

Algorithms: 1 BBBC 2 GA 3 DE 4 PSO

GA:
16: Mutation Probability
17: Crossover Alpha
18: 0
19: 1 full_elitist 0 non-elitist

DE:
16: Variant
17: Scaling Factor
18: 0
19: 1 full_elitist 0 non-elitist

PSO:
16: intertia weight
17: Cognitive Constant
18: Social Constant
19: 1 full_elitist 0 non-elitist