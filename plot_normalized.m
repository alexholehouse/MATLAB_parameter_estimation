function [ normalized_x ] = plot_normalized(t, x,names)
%plot_normalized - takes time values and a matrix of 
%   Detailed explanation goes here

% function analysis
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% time complexity is O(nm) 
%   n = number of species
%   m is number of time points
% breakdown
%   get_normalized is O(nm)
%   while loop is (basically) 1/6(n), so 
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


echo off
% get inititial values
size_vector = size(x)
number_of_species = size_vector(2)

normalized_x = get_normalized(x);

k = 1
exit_var = 1
exit = false
while(exit==false)
    if (k+6 > number_of_species)
        exit = true;
        while(k+exit_var < number_of_species)
            exit_var = exit_var+1;
        end
    end
    figure()
    
    if (exit==false)
        plot(t, normalized_x(:,k:k+6))
        legend(names(k:k+6))
        axis([0,7500,0,110])
    else
        plot(t, normalized_x(:,k:k+exit_var))
        legend(names(k:k+exit_var))
    end
    k = k+6;
end

end

