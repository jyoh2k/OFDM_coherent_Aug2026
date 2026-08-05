function [out, dc_val, mean_power] = DCCancel(params, in, dc_val_in )    

%  Usage      : [out, dc_val] = DCCancle(params, in, dc_val_in)    
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    out =in;
    dc_val=zeros( size(in,1));
    mean_power =  mean(mean( abs(in) .^ 2)); 
    if (  params.en == 0 )
        return;
    end

    if (  params.en == 2 )
        out = filter([1 -1], [1 -0.95], in);
         mean_power = mean(mean( abs(out) .^ 2)); 
        return;
    end

%     if ( isempty( dc_val_in ) )
    if ( nargin < 3 )
        for ii=1:size(in,1)
            dc_val(ii) = mean(in(ii,:));
        end
    else
        dc_val = dc_val_in ;
    end
    for ii=1:size(in,1)
        out(ii,:) = in(ii,:) -dc_val(ii);
    end
     mean_power = mean(mean( abs(out) .^ 2)); 
end
