function [ EVM_dB, error_const_idx, cmp_length] = calculate_EVM(params, signal, ideal_tx, ideal )

%  Usage      : calucate_EVM 
%  Function   : 
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    if (nargin < 4)
        ideal = slicer(signal, params);
    end
    ideal_tx = slicer(ideal_tx, params); % For fixed simulation
    cmp_length      = min(length(signal), length(ideal));
    cmp_length      = min(cmp_length,  length(ideal_tx));
    error           = ideal(1:cmp_length) - signal(1:cmp_length) ;
    EVM_dB          = 10*log10(sum(abs(error) .^2 )/sum(abs(signal(1:cmp_length)) .^2 ));
    error_const_idx = find(ideal(1:cmp_length)  ~= ideal_tx(1:cmp_length)) ;
end

function [decided] = slicer( in, params)
        distance = abs( ( ones(length(params.mapper_list),1) * in - params.mapper_list * ones(1, length(in)) )) .^2;
        [C, I] = min( distance  );
        decided = zeros(size(in));
        decided(1:length(in)) =  params.mapper_list(I);
end
