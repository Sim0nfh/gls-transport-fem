function g = RectCircg2()
    % Rectangle: [-2,6] x [-2,2]
    % 3 = rectangle, 4 = number of edges,
    R1 = [3; 4; ...
          -2; 6; 6; -2; ...
          -2; -2; 2;  2];

    % First circle: center (0,0), radius 1
    C1 = [1; 0; 0; 1];

    % Second circle: center (4,0), radius 1
    C2 = [1; 4; 0; 1];

    % Pad circles to same length as rectangle
    C1 = [C1; zeros(length(R1) - length(C1), 1)];
    C2 = [C2; zeros(length(R1) - length(C2), 1)];

    % Geometry description matrix
    gd = [R1, C1, C2];

    % Names for the objects
    ns = char('R1', 'C1', 'C2')';
    
    % Set formula: rectangle minus both circles
    sf = 'R1-C1-C2';

    % Decomposed geometry matrix returned to initmesh
    g = decsg(gd, sf, ns);
end
