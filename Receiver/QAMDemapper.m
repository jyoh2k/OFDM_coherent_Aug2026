function [demapper_out, I]  =  QAMDemapper( demapper_in, params ) 

%  Usage      : [demapper_out]  =  QAMDemapper( demapper_in, params ) 
%  Function   :
%     1.  Simple QAMDemapper      
%         
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


    [d1, d2 ] = size ( demapper_in ); 
    
    num_demap = d2 * params.Nbitspersymbol ;
    demapper_out = zeros( 1, d1 * num_demap ); 


    %%
    if ( params.Nbitspersymbol == 2 )    
        mapper_list  = 1/sqrt(2)* [  -1-1j , -1+1j, +1-1j ,1+1j ];    
        demapper_out(1:2:d2*2) = sign(real( demapper_in)) ;
        demapper_out(2:2:d2*2) = sign(imag( demapper_in)) ;
        demapper_out = (demapper_out +1 )/2;
        distance = ( ones(length(mapper_list),1) * (demapper_in) ...
                    - conj( mapper_list' )* ones(1, d2 )).^2;
        [C, I]= min(distance, [],1);
    end

     %% 8QAM
    if ( params.Nbitspersymbol == 3 )       
        mapper_list  = [  -1-sqrt(3),         -1+1j, -1-1j,  (1+sqrt(3))*1j, ...
                                     (1+sqrt(3))*-1j,  1+1j,   1-1j,  (1+sqrt(3)) ];    
        Normf = mean(abs(mapper_list) .^2) ;
        mapper_list     = 1/sqrt(Normf)* mapper_list; 
       demapper_list = [ ...
          0 0 0; 0 0 1; 0 1 0; 0 1 1; ...
          1 0 0 ;1 0 1; 1 1 0; 1 1 1;];
       distance = ( ones(length(mapper_list),1) * (demapper_in) ...
                    - conj( mapper_list' )* ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);

       demapper_out( 1:3:end ) = demapper_list(I, 1);
       demapper_out( 2:3:end ) = demapper_list(I, 2);
       demapper_out( 3:3:end ) = demapper_list(I, 3);
    end
    
    %% 16QAM
    if ( params.Nbitspersymbol == 4 ) 
       mapper_list = 1/sqrt(10) * [ -3 -1 1 3 ];

       distance = ( ones(length(mapper_list),1) * real(demapper_in) ...
                    - mapper_list' * ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);
       
   
       demapper_out( 2:4:end ) = I  == 2 | I == 3 ;
       demapper_out( 1:4:end ) = I > 2;

       distance = ( ones(length(mapper_list),1) * imag(demapper_in) ...
                    - mapper_list' * ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);
       demapper_out( 4:4:end ) = I  == 2 | I == 3 ;
       demapper_out( 3:4:end ) = I > 2;
    end

    %% 32QAM
    if ( params.Nbitspersymbol == 5 )
       mapper_list = 1/sqrt(20)* [ ...
        (-3+1j*5) (-1+1j*5) (1+1j*5) (3+1j*5) ...
        (-5+1j*3) (-3+1j*3) (-1+1j*3) (1+1j*3) (3+1j*3) (5+1j*3)...
        (-5+1j*1) (-3+1j*1) (-1+1j*1) (1+1j*1) (3+1j*1) (5+1j*1)...
        (-5+1j*-1) (-3+1j*-1) (-1+1j*-1) (1+1j*-1) (3+1j*-1) (5+1j*-1)...
        (-5+1j*-3) (-3+1j*-3) (-1+1j*-3) (1+1j*-3) (3+1j*-3) (5+1j*-3)...
        (-3+1j*-5) (-1+1j*-5) (1+1j*-5) (3+1j*-5) ...
       ];
       demapper_list = [ ...
          0 0 0 0 0; 0 0 0 0 1; 1 0 0 0 1; 1 0 0 0 0; ...
          0 0 1 0 0; 0 1 1 0 0; 0 1 0 0 0; 1 1 0 0 0; 1 1 1 0 0; 1 0 1 0 0; ...
          0 0 1 0 1; 0 1 1 0 1; 0 1 0 0 1; 1 1 0 0 1; 1 1 1 0 1; 1 0 1 0 1; ...
          0 0 1 1 1; 0 1 1 1 1; 0 1 0 1 1; 1 1 0 1 1; 1 1 1 1 1; 1 0 1 1 1; ...
          0 0 1 1 0; 0 1 1 1 0; 0 1 0 1 0; 1 1 0 1 0; 1 1 1 1 0; 1 0 1 1 0; ...
          0 0 0 1 0; 0 0 0 1 1; 1 0 0 1 1; 1 0 0 1 0; ...
       ];
       distance = ( ones(length(mapper_list),1) * (demapper_in) ...
                    - conj( mapper_list' )* ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);

       demapper_out( 1:5:end ) = demapper_list(I, 1);
       demapper_out( 2:5:end ) = demapper_list(I, 2);
       demapper_out( 3:5:end ) = demapper_list(I, 3);
       demapper_out( 4:5:end ) = demapper_list(I, 4);
       demapper_out( 5:5:end ) = demapper_list(I, 5);

    end

    %% 64QAM
    if ( params.Nbitspersymbol == 6 )
       mapper_list = 1/sqrt(42) * [-7 -5 -3 -1 1 3 5 7 ];

       distance = ( ones(length(mapper_list),1) * real(demapper_in) ...
                    - mapper_list' * ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);


       demapper_out( 3:6:end ) = I == 2 | I == 3 | I == 6 | I == 7;
       demapper_out( 2:6:end ) = I == 3 | I == 4 | I == 5 | I == 6; 
       demapper_out( 1:6:end ) = I > 4;

       distance = ( ones(length(mapper_list),1) * imag(demapper_in) ...
                    - mapper_list' * ones(1, d2 )).^2;
       [C, I]= min(distance, [],1);
       demapper_out( 6:6:end ) = I == 2 | I == 3 | I == 6 | I == 7;
       demapper_out( 5:6:end ) = I == 3 | I == 4 | I == 5 | I == 6; 
       demapper_out( 4:6:end ) = I > 4;
    end

end
