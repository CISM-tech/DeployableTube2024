function plotStructureColor(members, nodePos, u, localKs, transTs, figNum, sens)
if nargin > 6
    plotSens = true;
else
    plotSens = false;
end
    figure(figNum);
    hold on
    axis equal
    scallingFactor = 0.1;
    if istable(nodePos)
        nodePos = table2array(nodePos);
    end
    for i = 1:size(members, 1)
            A = members.A(i);
            B = members.B(i);
            length = members.length(i);
            if members.area(i) > 0.001
            width = scallingFactor * members.area(i)/110;
            coordinates = getLineCornerCoordinates([nodePos(A, :); nodePos(B, :)]', length, width);
            if members.design(i)
                force = getInternalForce(members(i, :), u, localKs{i, 1}, transTs{i, 1});
                if force(1) > 0
                    fill (coordinates(1,:), coordinates(2,:), 'b', 'EdgeColor', 'b');
                else
                    fill (coordinates(1,:), coordinates(2,:), [150 150 150]/255, 'EdgeColor', [150 150 150]/255);
                end
                if plotSens
                    center = nodePos(A, :) + 0.2*(nodePos(B, :) - nodePos(A, :));
                    text(center(1), center(2), sprintf('%.2e', sens(i)))
                end
            else
                fill (coordinates(1,:), coordinates(2,:), 'k', 'EdgeColor', 'k');
            end
            end
    end
end
