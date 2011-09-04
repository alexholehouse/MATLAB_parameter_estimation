% SCRIPT to automate the loading of data from the Monte Carlo simulation
% LOAD DATA - run from monte_carlo folder

% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                          DATA IMPORT
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

% get into results folder and parse contents
cd 'real_data\100ng_per_ml_0.88'
folders_ls = ls;
num_folders = length(folders_ls);

% for each folder (results *must* only contain folders with simulation
% results) go in and extract data, parse into a temp and 



for i = 3:num_folders
    cd(folders_ls(i,:))
    res_folder_ls = ls;
    
    %
    % Assumes the 7th item in the result of ls in the folder is the param
    % file. If not adjust!
    %
    param_file = res_folder_ls(7,:);
    temp_param = csvread(param_file);
    
    
    %
    % Assumes the 3rd item in the result of ls in the folder is the param
    % file. If not adjust!
    %
    conc_file = res_folder_ls(4,:);
    temp_conc = csvread(conc_file);
    
    % Adding temp data to appropriate datacubes
    param_cube(:,i-1) = temp_param(:,2);
    conc_cube(:,i-1) = temp_conc(:,2);
    
    if (i==3)
        param_cube(:,1) = temp_param(:,1);
        conc_cube(:,1) = temp_conc(:,1);
    end
    
    %sprintf('Progress %d of %d',i-3, num_folders-3);
    
    cd ..
end

cd ..\..

temp = size(param_cube);


% Determine number 
number_results = temp(2);
number_of_parameters = temp(1);
clear temp;

temp = size(conc_cube);
number_of_concs = temp(1);
clear temp;

% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%                           BASIC DATA ANALYSIS
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

normalized_param_cube = param_cube;
normalized_conc_cube = conc_cube;

% PARAMETER ANALYSIS-------------------------------------------------------

% Normalize datacube
for i = 1:number_of_parameters
    tempmax = max(param_cube(i,[2:1:number_results]));
    for j = 2:number_results
        normalized_param_cube(i,j) = param_cube(i,j)/tempmax;
    end
end

% Get Normalized mean
mean_normalized_param_vals(number_of_parameters) = 0;
for i = 1:number_of_parameters
    mean_normalized_param_vals(i) = mean(normalized_param_cube(i,[2:number_results]));
end
mean_normalized_param_vals = mean_normalized_param_vals';

% Get raw mean
mean_param_vals(number_of_parameters) = 0;
for i = 1:number_of_parameters
    mean_param_vals(i) = mean(param_cube(i,[2:number_results]));
end
mean_param_vals = mean_param_vals';

% get raw STD
STD_params(number_of_parameters) = 0;
for i = 1:number_of_parameters
    STD_params(i) = std(param_cube(i,[2:number_results]));
end
STD_params = STD_params';

%get normalized STD
STD_normalized_params(number_of_parameters) = 0;
for i = 1:number_of_parameters
    STD_normalized_params(i) = std(normalized_param_cube(i,[2:number_results]));
end
STD_normalized_params = STD_normalized_params';

% CONC ANALYSIS-------------------------------------------------------

%get normalized conc cube
for i = 1:number_of_concs
    tempmax = max(conc_cube(i,[2:1:number_results]));
    for j = 2:number_results
        normalized_conc_cube(i,j) = conc_cube(i,j)/tempmax;
    end
end

% Get Normalized mean
for i = 1:number_of_concs
    mean_normalized_conc_vals(i) = mean(normalized_conc_cube(i,[2:number_results]))
end
 mean_normalized_conc_vals =  mean_normalized_conc_vals';

% Get raw mean
mean_conc_vals(number_of_concs) = 0;
for i = 1:number_of_concs
    mean_conc_vals(i) = mean(conc_cube(i,[2:number_results]));
end
mean_conc_vals = mean_conc_vals';

% get raw STD
STD_concs(number_of_concs) = 0;
for i = 1:number_of_concs
    STD_concs(i) = std(conc_cube(i,[2:number_results]));
end
STD_concs = STD_concs';

%get normalized STD
STD_normalized_concs(number_of_concs) = 0;
for i = 1:number_of_concs
    STD_normalized_concs(i) = std(normalized_conc_cube(i,[2:number_results]));
end
STD_normalized_concs = STD_normalized_concs';

% -------------------------------------------------------------------------------------
% Determining Min and Max ranges
% -------------------------------------------------------------------------------------

for i = 1:number_of_parameters
    min_params(i) = min(param_cube(i,[2:number_results]));
end
min_params = min_params';

for i = 1:number_of_parameters
    max_params(i) = max(param_cube(i,[2:number_results]));
end
max_params = max_params';

% CONCENTRATIONS
for i = 1:number_of_concs
    min_conc(i) = min(conc_cube(i,[2:number_results]));
end
min_conc = min_conc';

for i = 1:number_of_concs
    max_conc(i) = max(conc_cube(i,[2:number_results]));
end
max_conc = max_conc';

% -------------------------------------------------------------------------------------
% Looking at parameter sets
% -------------------------------------------------------------------------------------

for i = 2:number_results
    normalized_parameter_set_means(i) = mean(normalized_param_cube(:,i))
end

for i = 2:number_results
    normalized_conc_set_means(i) = mean(normalized_conc_cube(:,i))
end


% scatter([1:number_of_parameters],mean_normalized_param_vals)
% scatter([1:number_of_concs],mean_normalized_conc_vals)

sprintf('Finished parsing and analysing data')


