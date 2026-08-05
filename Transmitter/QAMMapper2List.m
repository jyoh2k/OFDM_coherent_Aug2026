function [mapper_list,mapper1_list, upper_right_data, mapper2_list, norm] = QAMMapper2List (  params )

%  Usage      : [mapper_list] = QAMMapper2List (  params )
%
%  Function   :
%     1.   QAM mapping , PAM mapping list
%     2.   params   : parameters 
%     3.   T        : Reserved for fixed sim.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    num_bps = params.Nbitspersymbol ;
    if ( params.QAM_factor == 2)
        if ( num_bps == 2 ) % 4 QAM
            mapper1_list = 1/sqrt(2) * (ones(2,1) * [ -1 1  ]) ;
            mapper_list  = mapper1_list+ 1j * mapper1_list';
            upper_right_data = 1/sqrt(2)     * ( 1 + 1j );
            mapper1_list= 1/sqrt(2) * (  [ -1 1  ]) ;
            mapper2_list=  (  [ -1 1  ]) ; norm =   sqrt(2);
        end
        if ( num_bps == 4 ) % 16 QAM
            mapper1_list = 1/sqrt(10) * (ones(4,1) * [ -3 -1 1 3 ]) ;
            mapper_list = mapper1_list + 1j * mapper1_list';
            upper_right_data = 1/sqrt(10) * ( 3 + 3j );
            mapper1_list = 1/sqrt(10) * (  [ -3 -1 1 3 ]) ;
            mapper2_list=  (   [ -3 -1 1 3 ]) ;
            norm =   sqrt(10);
        end

        if ( num_bps == 5 ) % 32 QAM
            mapper_list = [ ...
                (-3+1j*5) (-1+1j*5) (1+1j*5) (3+1j*5) ...
                (-5+1j*3) (-3+1j*3) (-1+1j*3) (1+1j*3) (3+1j*3) (5+1j*3)...
                (-5+1j*1) (-3+1j*1) (-1+1j*1) (1+1j*1) (3+1j*1) (5+1j*1)...
                (-5+1j*-1) (-3+1j*-1) (-1+1j*-1) (1+1j*-1) (3+1j*-1) (5+1j*-1)...
                (-5+1j*-3) (-3+1j*-3) (-1+1j*-3) (1+1j*-3) (3+1j*-3) (5+1j*-3)...
                (-3+1j*-5) (-1+1j*-5) (1+1j*-5) (3+1j*-5) ...
               ];
            mapper_list     = 1/sqrt(20) * mapper_list;
            mapper1_list = 1/sqrt(20) *   [ -5 -3 -1 1 3 5 ] ;
            mapper2_list = [ -5 -3 -1 1 3 5];
            upper_right_data = 1/sqrt(20) * ( 3+1j*5 );
            norm =   sqrt(20);
        end
        if ( num_bps == 6 ) % 64 QAM
            mapper1_list= 1/sqrt(42) * (ones(8,1) * [-7 -5 -3 -1 1 3 5 7 ]) ;
            mapper_list = mapper1_list + 1j * mapper1_list';
            upper_right_data = 1/sqrt(42)  * ( 7+1j*7 );
            mapper1_list= 1/sqrt(42) * ( [-7 -5 -3 -1 1 3 5 7 ]) ;
            mapper2_list=  (  [-7 -5 -3 -1 1 3 5 7 ]) ;
            norm =   sqrt(42);
        end
    else
        if ( num_bps == 2.5 ) % PAM6  
            mapper1_list = [ ...
                (-3+1j*5) (-1+1j*5) (1+1j*5) (3+1j*5) ...
                (-5+1j*3) (-3+1j*3) (-1+1j*3) (1+1j*3) (3+1j*3) (5+1j*3)...
                (-5+1j*1) (-3+1j*1) (-1+1j*1) (1+1j*1) (3+1j*1) (5+1j*1)...
                (-5+1j*-1) (-3+1j*-1) (-1+1j*-1) (1+1j*-1) (3+1j*-1) (5+1j*-1)...
                (-5+1j*-3) (-3+1j*-3) (-1+1j*-3) (1+1j*-3) (3+1j*-3) (5+1j*-3)...
                (-3+1j*-5) (-1+1j*-5) (1+1j*-5) (3+1j*-5) ...
               ];
            mapper2_list = [ -5 -3 -1 1 3 5];
            mapper_list = mapper2_list;
        else
            mapper1_list = [1:2^num_bps] *2 - (2^num_bps + 1 )  ; 
            mapper2_list = [1:2^num_bps] *2 - (2^num_bps + 1 )  ; 
            mapper_list = [1:2^num_bps] *2 - (2^num_bps + 1 )  ; 
        end  
        mapper_list = mapper_list';
        upper_right_data = mapper_list(end);
        norm = 1;
    end  
    mapper_list = (mapper_list(:));
    mapper1_list =(mapper1_list(:));
    mapper2_list =(mapper2_list(:));
end
