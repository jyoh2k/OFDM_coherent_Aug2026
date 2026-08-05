function [color] = get_color(sim_case)

    switch sim_case 
        case 1
            color = 'rs--';
        case 2
            color = 'ms-';
        case 3
            color = 'm<--';
        case 4
            color = 'mo:';
        case 5
            color = 'm^-';
        case 6
            color = 'ro:';
        case 7
            color = 'r<--';
        case 8
            color = 'rs-';
        case 9
            color = 'gs-';
        case 10
            color = 'g<--';
        case 11
            color = 'go:';
        case 12
            color = 'bs-';
        case 19
            color = 'b<--';
        case 20
            color = 'bo-';
        case 21
            color = 'b^:';
        case 22
            color = 'ys-';
        case 23
            color = 'c^--';
        case 24
            color = 'ms-';
        case 25
            color = 'm^--';
        otherwise 
            color = 'ms-';
    end
end
