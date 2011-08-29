function [ model ] = load_model (new_conc, new_param, model)
% load_mode
% Takes a model a matrix of new concentration values and new parameter
% values and loads them into the designated species and parameters
% -------------------------------------------------------------------

% Load initial concentrations

for i = 1:size(new_conc)
    model.species(new_conc(i,1)).initialAmount = new_conc(i,2);
end

for i = 1:size(new_param)
    model.parameters(new_param(i,1)).value = new_param(i,2);
end


end

