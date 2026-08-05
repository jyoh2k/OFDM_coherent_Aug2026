

function txout =  pad_frame ( txin, TXSampleFreq, AWGSampleFreq)  
    TXSampleFreq_is_integer  = ceil(TXSampleFreq/1e9) == floor(TXSampleFreq/1e9);
    AWGSampleFreq_is_integer  = ceil(AWGSampleFreq/1e9) == floor(AWGSampleFreq/1e9);
    if ( TXSampleFreq_is_integer ~= 1  ||   AWGSampleFreq_is_integer ~=1  )     
       txout =  txin;
       return
    end 
     
    gcd_val = gcd(AWGSampleFreq/1e9 , TXSampleFreq/1e9 *128);
    pattern_len_unit = TXSampleFreq/1e9 *128/gcd_val; 
    num_pad =  pattern_len_unit -  mod(size(txin, 2) ,pattern_len_unit); 
    num_pad = mod(num_pad, pattern_len_unit); 
  
    txout = [ txin, txin(:, end-num_pad+1:end)];
    
end  