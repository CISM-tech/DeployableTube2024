function [members, nodePos] = createTubes(centers, radius, segNum, innerSize, exteriorArea)
    allNds = cell(size(centers, 1), 1);
    for i = 1: size(centers, 1)
        currentCenter = centers(i, :);
        allNds{i, 1} = createTubeNds(currentCenter, radius, segNum);
    end
    
    nodePos = cell2mat(allNds);
    nodePos = uniquetol(nodePos, 1e-4, 'ByRows',true);

    NdIndices = cell(size(centers, 1), 1);
    for i = 1:size(allNds, 1)
        NdIndices{i, 1} = getNd(nodePos, allNds{i, 1});
    end
    
    members = createTubeCns(NdIndices, allNds, nodePos, innerSize, exteriorArea);
    nodePos = array2table(nodePos, 'VariableNames', {'x', 'y'});
end

