function [mapper_list, mapper1_list, upper_right_data, mapper2_list, norm] = QAMMapperList (  params )

%  Usage      : [mapper_list] = QAMMapperList (  params )
%
%  Function   :
%     1.   QAM mapping 
%     2.   params   : parameters 
%     3.   T        : Reserved for fixed sim.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

    num_bps = params.Nbitspersymbol ;
    if ( num_bps == 2 ) 
        mapper_list = 1/sqrt(2) * (ones(2,1) * [ -1 1  ]) ;
        mapper1_list = 1/sqrt(2) *  [ -1 1  ] ;
        mapper_list = mapper_list + 1j * mapper_list';
        upper_right_data = 1/sqrt(2)     * ( 1 + 1j );
        norm =   sqrt(2);
        mapper2_list =   [ -1 1  ] ;
    end

    %% 8 QAM
    if ( num_bps == 3 ) 
        mapper_list  = [  -1-sqrt(3),         -1+1j, -1-1j,  (1+sqrt(3))*1j, ...
                                     (1+sqrt(3))*-1j,  1+1j,   1-1j,  (1+sqrt(3)) ];    
        Normf = mean(abs(mapper_list) .^2) ;
        mapper_list     = 1/sqrt(Normf)* mapper_list; 
        mapper1_list = 1/sqrt(Normf) *   [ -3 -1 1 3 ] ;
        upper_right_data = mapper_list(end);
        norm =   sqrt(Normf);
        mapper2_list =   [ -3 -1 1 3 ] ;
    end

    %% 16 QAM
    if ( num_bps == 4 ) % 16 QAM
        mapper_list = 1/sqrt(10) * (ones(4,1) * [ -3 -1 1 3 ]) ;
        mapper1_list = 1/sqrt(10) *   [ -3 -1 1 3 ] ;
        mapper_list = mapper_list + 1j * mapper_list';
        upper_right_data = 1/sqrt(10) * ( 3 + 3j );
        norm =   sqrt(10);
        mapper2_list =   [ -3 -1 1 3] ;
    end

     %% 32 QAM
    if ( num_bps == 5 ) 
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
        upper_right_data = 1/sqrt(20) * ( 3+1j*5 );
        norm =   sqrt(20);
        mapper2_list =   [ -5 -3 -1 1 3 5] ;
    end
    %% 64QAM
    if ( num_bps == 6 ) 
        mapper_list = 1/sqrt(42) * (ones(8,1) * [-7 -5 -3 -1 1 3 5 7 ]) ;
        mapper1_list = 1/sqrt(42) * [-7 -5 -3 -1 1 3 5 7 ] ;
        mapper_list = mapper_list + 1j * mapper_list';
        upper_right_data = 1/sqrt(42)  * ( 7+1j*7 );
        norm =   sqrt(42);
        mapper2_list =   [-7 -5 -3 -1 1 3 5 7] ;
    end

    mapper_list = (mapper_list(:)); 
     

end
