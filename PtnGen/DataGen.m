function [dataf] =  DataGen( ptn, totalbits, offset )

%  Usage      : [dataf] =  DataGen( ptn , totalbits, offset )
%  Function   :
%     1. Data generator 
%     2. ptn        : Parameter for data pattern
%     3. totalbits  : Number of total bits of output 
%     4. offset     : offset on data pattern file to generate output data
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

filename = ptn.data_file ;

if ( ptn.useprbsdata == 1 )
    %% read pbrs
    pbrs =importdata(filename);    
    pbrs = reshape(pbrs,1,length(pbrs));
    tmpdata = pbrs;
    for ii=1:(ceil(totalbits/length(tmpdata) )+offset/length(tmpdata))
        tmpdata = [tmpdata pbrs];
    end
    dataf = tmpdata(offset+1:offset+totalbits);
else
    rng(11, 'twister'); %  Mersenne Twister 
    dataf = double(rand(1,totalbits) > 0.5);
end

end
