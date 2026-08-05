function [sims, params]=  Init ( sims, params )

        if nargin < 1
            [sims, params]=  Init_OFDM ( );
        else 
            [sims, params]=  Init_OFDM ( sims, params );
        end  

    % global SC
    % if (SC == 1 ) 
    %     if nargin < 1
    %         [sims, params]=  Init_SC ();
    %     else 
    %         [sims, params]=  Init_SC ( sims, params );
    %     end  
    % else 
    %     if nargin < 1
    %         [sims, params]=  Init_OFDM ( );
    %     else 
    %         [sims, params]=  Init_OFDM ( sims, params );
    %     end  
    % end  

end
