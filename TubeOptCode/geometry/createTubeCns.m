function [Cns] = createTubeCns(NdIndices, nodePos, allPos, innerSize, exteriorArea)
    if nargin < 5
        exteriorArea = 1;
    end
    Cns = cell(size(NdIndices, 1), 1);
    for i = 1:size(NdIndices, 1)
        currentNds = NdIndices{i, 1};
        currentPos = nodePos{i, 1};
        segNum = size(currentNds, 1);
        
        % construct exterior members
        members = zeros(segNum*1.5, 5);
        for j = 1:segNum-1
            members(j, :) = [currentNds(j), currentNds(j+1), 0, exteriorArea, 0];
        end
        members(segNum, :) = [currentNds(end), currentNds(1), 0, exteriorArea, 0];
          
        % construct interior members
        for j = 1:segNum/2
            members(segNum+j, :) = [currentNds(j), currentNds(j+segNum/2), 1, innerSize, 1/(segNum/2)];
        end

        % assign tube index
        members = [members, i*ones(size(members, 1), 1)];
        
        length = zeros(size(members, 1), 1);
        for j = 1:size(members, 1)
            A = members(j, 1);
            B = members(j, 2);
            length(j) = ((allPos(A, 1) - allPos(B, 1))^2 + (allPos(A, 2) - allPos(B, 2))^2)^0.5;
        end
            Cns{i, 1} = [members, length];
    end
    Cns = cell2mat(Cns);
    Cns = array2table(Cns,...
    'VariableNames',{'A','B','design', 'area', 'var', 'tubeIndex', 'length', });
end

