function [U, localKs] = FEA(members, nodePos, transTs, load, support)
    nodePos = table2array(nodePos);
    NdNum = size(nodePos, 1);
    K = sparse(NdNum*3, NdNum*3);
    localKs = cell(size(members, 1), 1);
    for i = 1:size(members, 1)
        A = members.A(i);
        B = members.B(i);
        currentArea = members.area(i);
        currentI = 1/12*currentArea^1.5;
        length = members.length(i);
        if members.design(i)== 0
            k = getk(currentArea, currentI, length);
        else
            k = getkTruss(currentArea, length);
        end
        transT = transTs{i, 1};
        k = transT' * k * transT;
        localKs{i, 1} = k; 
        edof = [3*A-2, 3*A-1, 3*A, 3*B-2, 3*B-1, 3*B];
        K(edof,edof) = K(edof,edof) + k;
    end
    F = sparse(NdNum*3,1);
    U = sparse(NdNum*3,1);
    loadIndices = getNd(nodePos, load(:, 1:2));
    supportIndives = getNd(nodePos, support(:, 1:2));
    for i = 1:size(loadIndices, 1)
        F(loadIndices*3-2) = load(i, 3);
        F(loadIndices*3-1) = load(i, 4);
        F(loadIndices*3) = load(i, 5);
    end
    fixeddofs = [];
    for i =1:size(support, 1)
        if support(i, 3) == 1
            fixeddofs = [fixeddofs, supportIndives(i, 1)*3-2];
        end
        if support(i, 4) ==1
            fixeddofs = [fixeddofs, supportIndives(i, 1)*3-1];
        end
        if support(i, 5) ==1
            fixeddofs = [fixeddofs, supportIndives(i, 1)*3];
        end
    end
    alldofs   = [1: NdNum*3];
    freedofs  = setdiff(alldofs,fixeddofs);
    U(freedofs,:) = K(freedofs,freedofs) \ F(freedofs,:);
    U(fixeddofs,:)= 0;
    U = full(U);
    U = reshape(U, 3, [])';
end