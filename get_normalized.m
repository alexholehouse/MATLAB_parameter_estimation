function [ normalized_x ] = get_normalized( x )
% Takes a matrix of simulated values (i.e. colulms are timepoint data for 
% each variable, number of columns is number of variables looked at over 
% time) returns a matrix of equal dimensions, but with normalized values 
% between 0 and 100

% get inititial values
size_vector = size(x);
number_of_timepoints = size_vector(1);
number_of_species = size_vector(2);

% loop for each species
for i = 1:number_of_species
    max_val = max(x(:,i));
    
    %inner loop for each timepoint
    for j = 1:number_of_timepoints
        original = x(j,i);
        normalized_x(j,i) = 100*(original/max_val);
    end
end
end

