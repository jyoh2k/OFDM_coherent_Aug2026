function [mapper] = QAMMapper ( mapperin,  params, T )

%  Usage      : mapper = QAMMapper ( mapperin,  params, T );
%
%  Function   :
%     1.   4QAM, 16QAM mapping (Gray coding)    
%     2.   mapperin : data to be mapped 
%     3.   params   : parameters 
%     4.   T        : Reserved for fixed sim.
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :

d2 = size ( mapperin, 2 );
num_bps = params.Nbitspersymbol ;
if ( mod( d2, num_bps  ) ~= 0 )
    error(' The number of bit stream should be the integer multiples of params.Nbitspersymbol ');
end

if ( num_bps == 2 ) 
    mapper1I = mapperin( 1:2:end) * 2 -1;
    mapper1Q = mapperin( 2:2:end) * 2 -1;

    mapper2  = complex( mapper1I, mapper1Q); 
    mapper2  = 1/sqrt(2) * mapper2 ;  %  Normalization factor 
end

if ( num_bps == 3 )   
     mapper1 = mapperin(1:3:end)    + mapperin(2:3:end) *2 + ...
              mapperin(3:3:end)* 4 ;
    mapper1 = mapper1 +1;
    demapper_list = [ ...
          0 0 0; 0 0 1; 0 1 0; 0 1 1; ...
          1 0 0 ;1 0 1; 1 1 0; 1 1 1;];
    mapper_list  = [  -1-sqrt(3),         -1+1j, -1-1j,  (1+sqrt(3))*1j, ...
                                 (1+sqrt(3))*-1j,  1+1j,   1-1j,  (1+sqrt(3)) ];

    demapper_list = [ 1 + demapper_list(:,1) + demapper_list(:,2) *2  + demapper_list(:,3) * 4    ];
    [out,idx1] = sort( demapper_list) ;
    mapper2     = mapper_list(idx1(mapper1));
    Normf = mean(abs(mapper_list) .^2) ;
    mapper2     = 1/sqrt(Normf)* mapper2; 
end
if ( num_bps == 4 ) % 16 QAM
    mapper1I = mapperin( 1:4:end) * 2 + mapperin( 2:4:end) ;
    mapper1Q = mapperin( 3:4:end) * 2 + mapperin( 4:4:end) ;

    mapper2I = (1-2* (mapper1I < 2 )) .* ( mod ( mapper1I+1, 2) *2 + 1 );
    mapper2Q = (1-2* (mapper1Q < 2 )) .* ( mod ( mapper1Q+1, 2) *2 + 1 );
   
    mapper2  = complex( mapper2I, mapper2Q); 
    mapper2  = 1/sqrt(10) * mapper2 ;  %  Normalization factor 
end

 %% 32 QAM
if ( num_bps == 5 ) 
    mapper1 = mapperin(1:5:end)    + mapperin(2:5:end) *2 + ...
              mapperin(3:5:end)* 4 + mapperin(4:5:end) *8 + ...
              mapperin(5:5:end)* 16;
    mapper1 = mapper1 +1;
    demapper_list = [ ...
          0 0 0 0 0; 0 0 0 0 1; 1 0 0 0 1; 1 0 0 0 0; ...
          0 0 1 0 0; 0 1 1 0 0; 0 1 0 0 0; 1 1 0 0 0; 1 1 1 0 0; 1 0 1 0 0; ...
          0 0 1 0 1; 0 1 1 0 1; 0 1 0 0 1; 1 1 0 0 1; 1 1 1 0 1; 1 0 1 0 1; ...
          0 0 1 1 1; 0 1 1 1 1; 0 1 0 1 1; 1 1 0 1 1; 1 1 1 1 1; 1 0 1 1 1; ...
          0 0 1 1 0; 0 1 1 1 0; 0 1 0 1 0; 1 1 0 1 0; 1 1 1 1 0; 1 0 1 1 0; ...
          0 0 0 1 0; 0 0 0 1 1; 1 0 0 1 1; 1 0 0 1 0; ...
    ];
    mapper_list = [ ...
        (-3+1j*5) (-1+1j*5) (1+1j*5) (3+1j*5) ...
        (-5+1j*3) (-3+1j*3) (-1+1j*3) (1+1j*3) (3+1j*3) (5+1j*3)...
        (-5+1j*1) (-3+1j*1) (-1+1j*1) (1+1j*1) (3+1j*1) (5+1j*1)...
        (-5+1j*-1) (-3+1j*-1) (-1+1j*-1) (1+1j*-1) (3+1j*-1) (5+1j*-1)...
        (-5+1j*-3) (-3+1j*-3) (-1+1j*-3) (1+1j*-3) (3+1j*-3) (5+1j*-3)...
        (-3+1j*-5) (-1+1j*-5) (1+1j*-5) (3+1j*-5) ...
       ];

    demapper_list = [ 1 + demapper_list(:,1) + demapper_list(:,2) *2  + demapper_list(:,3) * 4 + demapper_list(:,4) *8 + demapper_list(:,5) *16 ];
    [out,idx1] = sort( demapper_list) ;
    mapper2     = mapper_list(idx1(mapper1)); 
    Normf = mean(abs(mapper_list) .^2) ;
    mapper2     = 1/sqrt(Normf)* mapper2;
    
end

 %% 64 QAM
if ( num_bps == 6 ) 
    mapper1I = mapperin(1:6:end) * 4 + mapperin(2:6:end)*2 + mapperin(3:6:end);
    mapper1Q = mapperin(4:6:end) * 4 + mapperin(5:6:end)*2 + mapperin(6:6:end);

    mapper2I = (mapper1I == 0)* -7 + (mapper1I == 1)* -5 ...
             + (mapper1I == 3)* -3 + (mapper1I == 2)* -1 ...
             + (mapper1I == 6)*  1 + (mapper1I == 7)*  3 ...
             + (mapper1I == 5)*  5 + (mapper1I == 4)*  7;
    mapper2Q = (mapper1Q == 0)* -7 + (mapper1Q == 1)* -5 ...
             + (mapper1Q == 3)* -3 + (mapper1Q == 2)* -1 ...
             + (mapper1Q == 6)*  1 + (mapper1Q == 7)*  3 ...
             + (mapper1Q == 5)*  5 + (mapper1Q == 4)*  7;
   
    mapper2  = complex( mapper2I, mapper2Q); 
    mapper2  = 1/sqrt(42) * mapper2 ;  %  Normalization factor 
end

mapper = mapper2;

 
 
end
