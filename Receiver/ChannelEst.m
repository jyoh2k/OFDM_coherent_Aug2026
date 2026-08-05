function [data_out, H_ISFA, ce ]=  ChannelEst( in, params )

%  Usage      :   [data_out, H, ce ]=  ChannelEst( in, params )
%  Function   :
%     1.       
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    data_out = in(:, params.NLTF * params.NLTFSample +1:end);
    
    H =  zeros(params.NTXStream, params.NTXStream, params.NFFT, params.NLTF);
    for irep=1:params.NLTF 
        ltfin = in( :, (1:params.NLTFSample )+ (irep-1)*params.NLTFSample);
        H( :, :, :, irep) = ChannelEst_LTF( ltfin, params);
    end 

    H_mean =mean( H,4);

    H_ISFA = ISFA(H_mean, params); 
    %%
    ce.H = H(:,:, params.SubcarrierIndex, 1);
    ce.H_mean = H_mean(:,:, params.SubcarrierIndex);
    ce.H_ISFA = H_ISFA(:,:, params.SubcarrierIndex);
end 

function [ out ]=  ChannelEst_LTF( in, params )
    if ( params.NTXStream == 1)
       out_sc = ChannelEst_SISO( in, params ); 
    else
       out_sc = ChannelEst_AA( in, params ); 
    end 
    out = zeros(params.NTXStream, params.NTXStream, params.NFFT);
    out(:, :, params.SubcarrierIndex) = out_sc;
end 

function [ out ]=  ChannelEst_SISO( in, params )
    out = params.LTF(params.SubcarrierIndex) ./ in(1, params.SubcarrierIndex);
end 

function [ out ]=  ChannelEst_SIMO( in, params )
    Response(1,:,:) = in(:, params.SubcarrierIndex) .* ones(2,1) * params.LTF(params.SubcarrierIndex); 

    out = zeros (2, 1, length(params.SubcarrierIndex));
    for ii=params.SubcarrierIndex
        out(:,1, ii) = ctranspose(Response(1,:,ii)) ...
          / ( Response(1,:,ii) *ctranspose(Response(1, :,ii)));
    end

end 

function [ out ]=  ChannelEst_AA( in, params )
    RX(1,:,:) = [in(1, 1:params.NFFT ); in(1, params.NFFT +(1:params.NFFT) ); ]  ;
    RX(2,:,:) = [in(2, 1:params.NFFT ); in(2, params.NFFT +(1:params.NFFT) ); ]  ;
    TX(1,:,:) = [params.LTF ;  params.LTF] ;
    TX(2,:,:) = [params.LTF ; -params.LTF] ;
    out = zeros( 2, 2, params.NFFT);

    for ii=params.SubcarrierIndex
        %out(:,:, ii ) =  transpose( TX(:,:,ii) / RX(:,:,ii) );  %org 
        out(:,:, ii ) =  TX(:,:,ii) / RX(:,:,ii);   %@jason
    end
    out = out(:,:, params.SubcarrierIndex);
end 
