function [indices] = getNd(nodelist, nodes, tol)
    if nargin<3
        tol = 1e-6;
    end
    indices = zeros(size(nodes, 1), 1);
    for i = 1:size(nodes, 1)
        dist = vecnorm(nodelist-nodes(i, :), 2, 2);
        indices(i, 1) = find(dist < tol);
    end
end

