function [nodes] = createTubeNds(center, radius, segNum)
    nodes = zeros(segNum, 2);

    for i = 0:segNum-1
        currentAngle = i*2*pi/segNum;
        nodes(i+1, :) = [center(1) + radius*sin(currentAngle), center(2) + radius*cos(currentAngle)];
    end
end

