function [mapper_list,mapper1_list, upper_right_data, mapper2_list, norm ] = TxMapperList (params)

%  Usage      : mapper = TxMapperList ( mapperin,  params);
%
%  Function   :
%     1.   QAMMapperList ( IQ merged mapping)
%     2.   QAMMapper2List (IQ seperate mapping)
%     3.   params   : parameters 
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


   if ( params.iq_sep == 1 ) 
       [mapper_list,mapper1_list, upper_right_data, mapper2_list, norm ] = QAMMapper2List (params);
   else
       [mapper_list,mapper1_list, upper_right_data, mapper2_list, norm ] = QAMMapperList (params);
   end 


end 
