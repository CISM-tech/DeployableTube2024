function plotStructure(members, nodePos, figNum)
    figure(figNum);
    hold on
    axis equal
    scallingFactor = 0.1;
    for i = 1:size(members, 1)
        if members(i, 4) > 0.01
            A = members(i, 1);
            B = members(i, 2);
            length = ((nodePos(A, 1) - nodePos(B, 1))^2 + (nodePos(A, 2) - nodePos(B, 2))^2)^0.5;
            width = scallingFactor * members(i, 4);
            coordinates = getLineCornerCoordinates([nodePos(A, :); nodePos(B, :)]', length, width);
            fill (coordinates(1,:), coordinates(2,:), [0 0 0], 'EdgeColor', [0 0 0]);
        end
    end
end
