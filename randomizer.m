function [random_value] = randomizer(lower, upper, implementation)
% Generates a random number with a uniformly distributed exponent.
%   If rand() is used to generate a random number between 1 and 1000, we
%   are much more likely to generate a number with an exponent of E2 than
%   E1-E0. However, this bias does not reflect the range of values provided
%   by biological research. The range simply means the value *can* be any
%   number between 1 and 1000, but does not give any inevitable bias 
%   towards larger numbers. This is even more significant when this range 
%   is larger
%   
%   rand() generates a value between 0 and 1, but
%   clearly the probability of getting 0.4xxxx is far higher than getting
%   0.0004xxxx - there are simply far more numbers which fit the former
%   criterion compared to the latter.
%
%   To work around this problem, randomizer initially randomly selects the
%   exponent between the range of values given. i.e. if we say 
%
%       randomizer(1E0,1E5)
%   
%   The resulting value has an equal chance of having an exponent of
%   0,1,2,3,4 or 5
%
%   The mantissa is the generated using rand()
%
%   While this clearly introduces some additional bias (e.g. 0-9 are not
%   as frequent as 10-99 or 100 - 999) it does give our parameters a much
%   wider range. Where we are generating some values between 1E-5 and 1E-2,
%   and some values between 1000 and 1000000000 it is key we explore the
%   full range of possible values, and do not limit ourselves to the larger
%   values nearly exclusivly. In reality, this is a byproduct of our ranges
%   being too larger - reducing these in size 

% 
%   There are two other modes, one where we use rand purly, reducing
%   exponent bias towards smaller numbers but favouring the larger ones,
%   for comparative analysis if need be
%


[~,lower_exponent] = strread(strrep(sprintf('%E',lower),'E','#'),'%f#%f');
[~,upper_exponent] = strread(strrep(sprintf('%E',upper),'E','#'),'%f#%f');


% Randomly select exponent between the appropriate range, then randomly 
% select a number between 0.1 and 1
if (implementation == 1)
    % range in the the different in 10E between lower and upper
    new_exponent = randi([lower_exponent+1, upper_exponent]);

    rv = rand(1);

    % ensures the random number is between 0.1 and 0.999.
    while (rv < 0.1)
        rv = rand(1);
    end

    random_value = (rv*10^(new_exponent));

end

% Determine the range of values and rescale to be between 1 and an
% appropriate number. Then generate a random int between 1 and that number,
% and then rescale to the correct value
if (implementation == 2)
    top_exponent = upper_exponent - lower_exponent;
    top = 10^(top_exponent);
    random_int = randi([1,top]);
    random_value = random_int*(10^(lower_exponent));
end

% Pure random number between a range
if (implementation ==3)
    range = upper_exponent - lower_exponent;
    rv = rand(1);
    while (rv < 0.1)
        rv = rand(1);
    end
    temp_val = rv*10^(range);
    random_value = temp_val*10^(lower_exponent);
end



end

