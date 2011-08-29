% SCRIPT to automate the loading of data from the Monte Carlo simulation
% LOAD DATA - run from monte_carlo folder


% get into results folder and parse contents
cd 'results'
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
    cd ..
end

cd ..

temp = size(param_cube);

number_resulst = temp(2);
clear temp;

% calculate averages, stdevs and & stdevs




    