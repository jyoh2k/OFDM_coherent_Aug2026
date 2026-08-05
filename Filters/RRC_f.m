function [ H ] = RRC_f(os_factor, alpha, resp_sample)  

%  Usage      : [ out, phase ] = OFDE(in, params)  
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

% Root Raised Cosine Filter 

H = zeros( 1, resp_sample);

Normalized_freq = [-resp_sample/2:resp_sample/2-1]/resp_sample * os_factor;
idx1 = abs(Normalized_freq) < (1-alpha )/2 ; 
idx3 = abs(Normalized_freq) > (1+alpha )/2 ; 

H  =sqrt( 1/2* ( 1 - sin ( pi * (2 * abs( Normalized_freq) - 1)/ 2/alpha)));
H(idx1) =1 ;
H(idx3) =0 ;

