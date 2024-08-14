function [C] = getC(load, nodePos, u)
    C = 0;
    for i = 1:size(load, 1)
        loadIndex = getNd(nodePos, load(i, 1:2));
        uL = u(loadIndex, :);
        C = C+dot(uL, load(i, 3:5));
    end
end

