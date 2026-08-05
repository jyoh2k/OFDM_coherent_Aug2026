function [legend] = get_legend(sim_case)

    switch sim_case 
        case 1
            legend = 'AWGN only';
        case 2
            %legend = 'DSP penality';
            legend = 'AWGN only';
        case 3
            legend = 'm<--';
        case 4
            legend = 'mo:';
        case 5
            legend = 'm^-';
        case 6
            legend = 'Bandwidth';
        case 7
            legend = 'r<--';
        case 8
            legend = 'rs-';
        case 9
            legend = 'IQ gain';
        case 10
            legend = 'IQ phase';
        case 11
            legend = 'IQ skew';
        case 12
            legend = 'Phase noise';
        case 19
            legend = 'CFO';
        case 20
            legend = 'SFO';
        case 21
            legend = 'Jitter';
        case 22
            legend = '20km';
        case 23
            legend = 'PMD';
        case 24
            legend = 'DAC';
        case 25
            legend = 'ADC';
        otherwise 
            legend = 'ms-';
    end
end
