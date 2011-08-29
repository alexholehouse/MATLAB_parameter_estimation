function [ evaluation_value ] = compare_sim_and_ex(species_number, normalized_x, t, experimental_t, normalized_experimental)

%   Compare a set of parameters based on the simulation results of a
%   defined species with empyrical data reflecting that same species



% for each experimental timepoint, interpolate the value from the
% simulated data at that timepoint
for i = 1:length(experimental_t)
    interpolated(i) = interp1(t, normalized_x(:,species_number), experimental_t(i));
end

% Determine the correlation between the interpolated data and the
% experimental data
evaluation_value = corr(interpolated',normalized_experimental);
end

