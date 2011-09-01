function [new_conc, new_param] = generate_values(missing_conc, missing_params, randomization_type)
% Function which randomly generates a value for each initial concentration
% and parameter defined by the missing_conc and missing_params vectors.
%
%   Because each concentration and parameter has its own range, for clarity
%   and maximum customization we've added a massive case statement which
%   evaluates what parameter or initial conc is being looked at based on
%   the index number, and generates a random number based on the ranges
%   defined by Hendriks et al.
%
%   The caveat to all this is that we've HARDCODED the species and
%   parameter index numbers. This means if you change the p38 MAPK model in
%   terms of the order of these species, you'll need to re-jigg the CASE
%   statements along the switch
%

% preallocate matrices for speed
new_conc = zeros(length(missing_conc),2);
new_param = zeros(length(missing_params),2);

% FOR loop which completes all the missing concentration values
for i = 1:length(missing_conc)
    
    switch missing_conc(i)
        % Note - for clarity, concentrations are in uM, while model takes M 
        
        case 4
            % MKK3_phosphatase - range 1E-03 to 1E02 
            % between( 1 and 10E05)/10E03
            new_conc(i,1) = 4;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 7
            % MK2_phosphatase  - range 10E-03 to 1E02
            new_conc(i,1) = 7;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 8
            % MKK3 - range 0.01 to 0.09
            new_conc(i,1) = 8;
            new_conc(i,2) = (0.01 + (rand(1) * 0.08))/1E6;
            
        case 13
            % Hsp27_phosphatase  - range 1E-03 to 1E02
            new_conc(i,1) = 13;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 15
            % MKK6 - range 0.01 to 0.12
            new_conc(i,1) = 15;
            new_conc(i,2) = (0.01 + (rand(1) * 0.11))/1E6;
            
        case 21
            % TLR4 - range 0.25 to 2.25
            new_conc(i,1) = 21;
            new_conc(i,2) = (0.25 + (rand(1) * 2))/1E6;
            
        case 23
            % p38 - range 1.3 to 11.7
            new_conc(i,1) = 23;
            new_conc(i,2) = (1.3 + (rand(1) * 10.4))/1E6;
            
        case 24
            % p38_phosphatase  - range 1E-03 to 1E02
            new_conc(i,1) = 24;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 25
            % MKK6_phosphatase - range 10E-03 to 1E02
            new_conc(i,1) = 25;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 28
            % Hsp27  - range 6.5 to 58.8
            new_conc(i,1) = 28;
            new_conc(i,2) = (6.5 + (rand(1) * 52.3))/1E6;
            
        case 33
            % LPS... - DO NOT SET - this is preset previously
            
        case 37
            % p38_phosphatase_nucleus  - range 10E-03 to 1E02
            new_conc(i,1) = 37;
            new_conc(i,2) = randomizer(1E-03, 1E02, randomization_type)/1E6;
            
        case 39
            % MK2_nucleus range 21-190
            new_conc(i,1) = 39;
            new_conc(i,2) = (21 + (rand(1) * 169))/1E6;
                
    end
end

% FOR loop which completes all the missing concentration values
for i = 1:length(missing_params)
    
    switch missing_params(i)
        
        case 6
            % main.P.kr_p38PMK2P - range 1E-04 to 10E01
            new_param(i,1) = 6;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
                       
        case 7
            % main.P.kr_LPS_TLR4  - range 1E-04 to 10E01 
            new_param(i,1) = 7;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 8
            % main.P.kr_p38_MKK6 - range 1E-04 to 10E01 
            new_param(i,1) = 8;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 9
            % main.P.kr_p38P_Ppas  - range 1E-04 to 10E01  
            new_param(i,1) = 9;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 15       
            % main.P.ki_p38PMK2P
            new_param(i,1) = 15;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 18        
            % main.P.ki_MK2
            new_param(i,1) = 18;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 23        
            % main.P.kr_complex_p38P
            % main.P.ki_MK2
            new_param(i,1) = 23;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 26        
            % main.P.kr_Hsp27P_Ppase 
            new_param(i,1) = 26;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 30       
            % main.P.ki_p38 - range 10^-4 to 10
            new_param(i,1) = 30;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 32      
            % main.P.kc_p38ppase - range 10^-2 to 10^2
            new_param(i,1) = 32;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
        case 34      
            % main.P.kf_MK2_p38 - RANGE 10^4 to 10^7
            new_param(i,1) = 34;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 35      
            % main.P.kf_complex_p38P - RANGE 10^4 to 10^7
            new_param(i,1) = 35;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 41      
            % main.P.kr_MKK3_complex - range 10^-4 to 10
            new_param(i,1) = 41;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 42      
            % main.P.kc_MK2  - range 10^-2 to 10^2
            new_param(i,1) = 42;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 43      
            % main.P.kf_Hsp27P_Ppase  - RANGE 10^4 to 10^7
            new_param(i,1) = 43;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 47       
            % main.P.kf_MKK6_complex  - RANGE 10^4 to 10^7
            new_param(i,1) = 47;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 57      
            % main.P.kr_MKK6_complex  - range 10^-4 to 10
            new_param(i,1) = 57;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
            
        case 60      
            % main.P.kc_Hsp27ppase - range 10^-2 to 10^2
            new_param(i,1) = 60;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 63       
            % main.P.k_inactivation - range 10^-4 to 10
            new_param(i,1) = 63;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 66       
            % main.P.kr_Hsp27_MK2 - range 10^-4 to 10
            new_param(i,1) = 66;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 70     
            % main.P.kf_p38_MKK6  - RANGE 10^4 to 10^7
            new_param(i,1) = 70;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 71      
            % main.P.kf_MK2P_Ppase - RANGE 10^4 to 10^7
            new_param(i,1) = 71;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 72     
            % main.P.kc_MKK6ppas - range 10^-2 to 10^2
            new_param(i,1) = 72;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 79      
            % main.P.kf_p38_MKK3 - RANGE 10^4 to 10^7
            new_param(i,1) = 79;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 82     
            % main.P.kr_MKK6P_Ppase- range 10^-4 to 10
            new_param(i,1) = 82;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 83      
            % main.P.kc_MKK3ppase- range 10^-2 to 10^2
            new_param(i,1) = 83;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
            
        case 84     
            % main.P.ko_p38P - range 10^-4 to 10
            new_param(i,1) = 84;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
        
        case 86      
            % main.P.kf_MKK3P_Ppase- RANGE 10^4 to 10^7
            new_param(i,1) = 86;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 87     
            % main.P.kc_MKK3 - range 10^-2 to 10^2
            new_param(i,1) = 87;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
                 
        case 89     
            % main.P.kr_MKK3P_Ppase - range 10^-4 to 10
            new_param(i,1) = 89;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 93     
            % main.P.kc_p38Pcomplex - range 10^-2 to 10^2
            new_param(i,1) = 93;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 96      
            % main.P.kc_MKK6 - range 10^-2 to 10^2
            new_param(i,1) = 96;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 97      
            % main.P.kf_p38P_Ppase - RANGE 10^4 to 10^7
            new_param(i,1) = 97;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 98       
            % main.P.kc_complexMKK3 - range 10^-2 to 10^2
            new_param(i,1) = 98;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 103      
            % main.P.kf_MKK3_complex- RANGE 10^4 to 10^7
            new_param(i,1) = 103;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
            
        case 105     
            % main.P.kc_MK2ppase - range 10^-2 to 10^2
            new_param(i,1) = 105;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 107    
            % main.P.kf_Hsp27_MK2 - RANGE 10^4 to 10^7
            new_param(i,1) = 107;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 108    
            % main.P.kf_MKK6P_Ppase - RANGE 10^4 to 10^7
            new_param(i,1) = 108;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 109     
            % main.P.ko_p38PMK2P- range 10^-4 to 10
            new_param(i,1) = 109;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 110      
            % main.P.k_deg_complex - range 10^-4 to 10
            new_param(i,1) = 110;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 113      
            % main.P.kr_MK2P_Ppase  - range 10^-4 to 10
            new_param(i,1) = 113;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
        case 122     
            % main.P.k_activation - range 10^-4 to 100
            new_param(i,1) = 122;
            new_param(i,2) = randomizer(1E-04, 100, randomization_type);
            
        case 123      
            % main.P.kf_p38P_Ppase_nucleus- RANGE 10^4 to 10^7
            new_param(i,1) = 123;
            new_param(i,2) = randomizer(1E04, 1E07, randomization_type);
            
        case 124     
            % main.P.kc_p38 - range 10^-2 to 10^2
            new_param(i,1) = 124;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 125       
            % main.P.kc_complexMKK6 - range 10^-2 to 10^2
            new_param(i,1) = 125;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 126      
            % main.P.ko_p38 - range 10^-4 to 10
            new_param(i,1) = 126;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 133      
            % main.P.kr_MK2_p38  - range 10^-4 to 10
            new_param(i,1) = 133;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 138     
            % main.P.kr_p38_MKK3 - range 10^-4 to 10
            new_param(i,1) = 138;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 144      
            % main.P.k_reactivation - range 10^-4 to 10
            new_param(i,1) = 144;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 146      
            % main.P.kf_LPS_TLR4 - original range is in 1/ng/ml/min, which
            % assuming a M of 100 000 Da for LPS we convert this to a range
            % of 1E-05 to 1E06 M-1/min
             new_param(i,1) = 146;
             new_param(i,2) = randomizer(1E-05, 10^6, randomization_type);
            
        case 147      
            % main.P.ko_MK2- range 10^-4 to 10
            new_param(i,1) = 147;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 148     
            % main.P.kc_p38P_Ppase_nucleus- range 10^-2 to 10^2
            new_param(i,1) = 148;
            new_param(i,2) = randomizer(1E-02, 1E02, randomization_type);
            
        case 152    
            % main.P.kr_p38P_Ppase_nucleus - range 10^-4 to 10
            new_param(i,1) = 152;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        case 153    
            % main.P.ki_p38P  - range 10^-4 to 10
            new_param(i,1) = 153;
            new_param(i,2) = randomizer(1E-04, 10, randomization_type);
            
        otherwise
            sprintf('None found for i_value = %d', i)
            
            
                
    end
end
                  
    
    
end

