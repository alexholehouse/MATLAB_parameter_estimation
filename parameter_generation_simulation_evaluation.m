%_________________________________________________________________________

% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: %
%                                                                         %  
%                        Monte-Carlo Parameter Generator                  %
%                                                                         %
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: %
%_________________________________________________________________________


sprintf('Clearing all variables...')
clear all

% Reasonaly simple script which carries out monte-carlo based parameter
% generation and evaluation on a p38 MAPK signalling model developed in
% SBML, saving "good" parameter sets to the folder
%             /results/pset_<simulation run number>_<date>
% 
% For questions or concerns contact alex.holehouse@gmail.com


% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                                SETTINGS
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


%_________________________________________________________________________
%                            Model settings
%__________________________________________________________________________

% Model settings are those relating to the overall model

% Set SBML file model name to be used
% This model should have any parameters or initial concentrations we're
% going to generate random values for set to the replacement value, which
% we define below
model_name = 'p38_with_rep_vals_2.xml';

% Replacement value is a numeric number the scripts identify as a
% placeholder for a randomly generated number. This is variable so that we
% can avoid clashes with real parameters
replacement_val = 99999;

%__________________________________________________________________________
%                           Species Settings
%__________________________________________________________________________

% Species settings define model-wide parameters associated with specific
% species

% Set the species number that p38P, Hsp27P and LPS are at in the loaded model
p38P_species_number = 20;
Hsp27P_species_number = 16;
LPS_species_number = 33;

% LPS values 
% Set the concentration of LPS in ng/ml. The system converts this to Molar
% Additionally, molar mass is set to 100000 based on previous work,
% although it's not a defined number so we can change the value here if
% need be
LPS_concentration = 10;
LPS_molar_mass = 100000;

% Dex values - to be added later
%DEX_concentration = ?

%__________________________________________________________________________
%                           Simulation Settings
%__________________________________________________________________________

% Simulation settings define settings specific to the ODE simulation and
% parameter generation steps

% Set for the number of loops in the monte carlo simulation
N_montecarlo_iterations = 10000;

% Set the simulation length
simulation_length = 7200; 

% Set max timestep size of step through simulation (in seconds)
max_timestep = 100; 


% Set the type of randomization the randomizer algorithm uses
% 1 = Seperate exponent and mantissa randomization (RECOMMENDED)
% 2 = Randomize an int between 1 and an appopriate number, before
% re-scaling
% 3 = Simple uniform random number
randomization_type = 1;


%__________________________________________________________________________
%                           Ouput Settings
%__________________________________________________________________________

% Output settings are those

% Set to true to plot p38P experimental/simulated and Hsp27P graphs to file
% for easy viewing later. This should be false when this script is used as
% a non-graphical interface SSH script
plot_graphs_on_success = true;

% Set name of folder results should go into (NB, we always check it exists,
% and if it doesn't the folder is created)
results_folder = 'results';

% Sensetivity threshold for simulations to define a parameter set as "good"
% - the higher the number, the better a fit the simulated data will be.
% Value should be between 0 and -1 (though if threshold_val < 0 you are
% looking for a negative correlation).
threshold_val = 0.85;

windows = true;
unix = false;


% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% -----------------------    END OF SETTINGS     --------------------------
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                                LOADING DATA
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%
% This is where empyrical data is loaded, at present we only have empyrical
% data for p38_P and Hsp27P (at 10 ng/ml, for the sake of brevity we're
% avoiding multiple concentrations at this stage).
%
% When more data becomes available, additional data can be loaded in the
% same manner - i.e.. experimental_newProtein_10 = [concentrtaions at
% experomental_t timepoints]. Note that if timepoints are not the same we
% may extrapolate to the ones given here to give an equivalent data set. If
% this happens it will be discussed.

% Load timepoints data is collected at
experimental_t = [0,300,1200,1800,2400,2700,3000,3600,4200,5400,6300,7200];

% Load experimental data 
experimental_p38P_10 = [0.003485893,0.023448276,0.256476489,0.423197492,0.47646395,0.508163009,0.566043887,0.492112853,0.282959248,0.145329154,0.111423197,0.125166144];
experimental_Hsp27P_10 = [0.000543905,0.007139463,0.303870883,0.535219251,0.606373416,0.711490127,0.708512965,0.532745916,0.260702038,0.081408198,0.060682572,0.054819853];

% Normalize that data
normalized_experimental_p38P_10 = get_normalized(experimental_p38P_10');
normalized_experimental_Hsp27P_10 = get_normalized(experimental_Hsp27P_10');

% to add more experimental data, add another block with the same
% structure/format below. 
%
% You will need to add more "compare" blocks manually in the Part 2 of the
% script


% Load model
% ......................................................................
model = sbmlimport(model_name);


% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% -----------------------    END OF LOADING DATA    -----------------------
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                                PRE-SIMULATION SETUP
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if (windows && unix)
    sprintf('ERROR - cannot be both Windows and *Nix system?!')
    keyboard
end

if (windows)
    seperator = '\';
else
    seperator = '/';
end
% Set LPS and Dex concentrations in model
% ......................................................................
% We must convert the LPS and Dex 
%
% LPS
% convert ng/ml into mol/l
ng_per_ml_value = LPS_concentration;
ng_per_l_value = ng_per_ml_value * 1000;
g_per_l_value = ng_per_l_value/1000000000;

% volume is 1l so we have g_per_l_value grams in total
% n = m/M, estimate LPS M = 100 000Da (based on previous work)

n_moles = g_per_l_value/LPS_molar_mass;
% because we're operating in a volume at a litre then the concentration
% (c =n/v) is also n_moles (mole/litre) - note, this assumes LPS in species
% 33 - if not adjust appropriately. It's more straight forward to hardcode
% this than have a lookup!

model.species(LPS_species_number).initialAmount = n_moles;

% GC
% ... same thing for GC (depends on conc)

% Set simulation settings 
% .......................................................................
% Set the simulation options, based on settings entered by the user earlier
% and some standard settinsg, e.g. we're using the ode23s ODE solver, and a
% relative max toleranace of 1E-02
%

configsetObj = getconfigset(model, 'active');

set(configsetObj, 'SolverType', 'ode23s');
set(configsetObj, 'StopTime', simulation_length);

solver_options = get(configsetObj, 'SolverOptions');
solver_options.MaxStep = max_timestep;
solver_options.RelativeTolerance = 1e-02;

% Get N_species
N_species = length(model.species);

% Identify missing values
% .......................................................................
% Identify which values are missing and need to be generated in the
% Monte-Carlo simulation. These values are identified based on them having
% a value in the loaded model = replacement_val. For example, if the model
% had a parameter with the following details
%
%   Index:    Name:                      Value:        ValueUnits:
%   1         parameter_name             99999          Molar
%
% And the replacement value was 99999 then we would earmark parameter 1 as
% needing to have values generated

[missing_initial_concs, missing_params] = identify_missing_parameters(model, replacement_val);

% Ensure results folder is present
% .......................................................................
if exist(results_folder) ~= 7;
    mkdir (results_folder)
end


% Preconstruct matrices for R1, R2 and some other values for analysis
% .......................................................................
R1_values = 1:N_montecarlo_iterations;
R2_values = 1:N_montecarlo_iterations;

param6_val = 1:N_montecarlo_iterations;
param32_val = 1:N_montecarlo_iterations;
param34_val = 1:N_montecarlo_iterations;


% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% -----------------     END OF PRE SIMULATION SETUP   --------------------
% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                          MONTE CARLO SIMULATION
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

for i = 1:N_montecarlo_iterations

% Generate a random set of parameters for the model based on the missing
% initial concentrations and parameters defined in the pre-simulation setup
% .......................................................................
[new_conc, new_param] = generate_values2(missing_initial_concs, missing_params, randomization_type);

% Load newly generate initail_concs and parameters into the model
% .......................................................................
model = load_model(new_conc, new_param, model);


% RUN THE SIMULATION!
% Try/catch loop so you can skip bad parameter sets using CTRL-C
% and not quit the script
try
    [t,x,names]= sbiosimulate(model);
catch error
    keyboard
    continue
end


% get normalized matrix of results (values between 0 and 100)
normalized_x = get_normalized(x);

% Evaluate the simulated data in comparison to the empyrical data
% .......................................................................
% Note that as more empyical data is available, you'll need to add more
% compare_sim_and_ex function calls with the same structure here
R1 = compare_sim_and_ex(p38P_species_number, normalized_x, t, experimental_t, normalized_experimental_p38P_10);
R2 = compare_sim_and_ex(Hsp27P_species_number, normalized_x, t, experimental_t, normalized_experimental_Hsp27P_10);


% check if R values comply
if (R1 < threshold_val || R2 < threshold_val || isnan(R1) || isnan(R2))
    sprintf('Loop %d - This set does not comply! R1=%e and R2=%e',i, R1,R2)
    
% if R values do comply...
else
    sprintf('Loop %d - This set might comply! R1=%e abd R2=%e', i,R1,R2)
    
    min_p38V = min(normalized_x(:,p38P_species_number));
    min_Hsp27PV = min(normalized_x(:,Hsp27P_species_number));
    
    % Ensure value doesn't drop below -5% 
    if (min_p38V > -5 && min_Hsp27PV > -5)
       
        sprintf('Loop %d - This set does comply! minp38P = %e and minHsp27P = %e', i,min_p38V,min_Hsp27PV)
        
        % Build results storage folder and move into that folder
        folder_name = sprintf('pset_%d_%s', i,date);
        cd 'results'
        mkdir(folder_name)
        
        
        cd(strcat(folder_name, seperator))

        % Plot and save graphs as .fig files in the relevant folders        
        if (plot_graphs_on_success)
            figure()
            plot(t, normalized_x(:,p38P_species_number), experimental_t, normalized_experimental_p38P_10)
            legend('simulation - p38P','empyrical - p38P')
            title(sprintf('p38 - parameter set %d', i))
            saveas(gcf, sprintf('p38P_%d.fig', i))
            close()
            figure()
            plot(t, normalized_x(:,Hsp27P_species_number), experimental_t, normalized_experimental_Hsp27P_10)
            legend('simulation - Hsp27P','empyrical - Hsp27P')
            title(sprintf('Hsp27P - parameter set %d', i))
            saveas(gcf, sprintf('Hsp27P_%d.fig', i))
            close ()
        end

        % write parameter set to disk, as well as simulation results for
        % easy analysis later
        csvwrite(sprintf('r1_%d = %d.csv', i, R1), R1);
        csvwrite(sprintf('r2_%d = %d.csv', i, R2), R2);
        csvwrite(sprintf('conc_set_%d.csv', i), new_conc);
        csvwrite(sprintf('param_set_%d.csv', i), new_param);
        csvwrite(sprintf('simulation_t_%d.csv', i), t);
        csvwrite(sprintf('simulation_x_%d.csv', i), x);

        model.name = sprintf('model_%d',i);
        sbmlexport(model);

        cd('..');
        cd('..');
    end

end

% Some R value stats
R1_values(i) = R1;
R2_values(i) = R2;

param6_val(i) = model.parameters(6).value;
param32_val(i) = model.parameters(32).value;
param34_val(i) = model.parameters(34).value;



end
