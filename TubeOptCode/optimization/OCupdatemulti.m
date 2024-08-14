function [newMembers] = OCupdatemulti(members, u, localKs, transTs, tubeSizes)
    memdata = members;
    designIndices = [1:size(members, 1)]';
    design = memdata.design==1;
    optMembers = memdata(design, :);
    designIndices = designIndices(design, :);
    areaP = 4;
    tubeNum = max(memdata.tubeIndex);
    
    sen = zeros(size(optMembers, 1), 1);
    for i = 1:size(optMembers, 1)
        currentMem = optMembers(i, :);
        sen(i, 1) = dCTruss(currentMem, u, 1, transTs{designIndices(i), 1});
        force = getInternalForce(currentMem, u, localKs{designIndices(i), 1}, transTs{designIndices(i), 1});
        if force(1) < 0
            sen(i, 1) = sen(i, 1)/(10000*optMembers.area(i));
        end
    end
    
    for i = 1:tubeNum
        currentIndices = optMembers.tubeIndex==i;
        currentMembers = optMembers(currentIndices, :);
        currentDesignIndices = designIndices(currentIndices, :);
        forces = zeros(size(currentMembers, 1), 1);
        for j = 1:size(currentMembers, 1)
            force = getInternalForce(currentMembers(j, :), u, localKs{currentDesignIndices(j), 1}, transTs{currentDesignIndices(j), 1});
            forces(j) = force(1);
        end
        compressionMembers = forces>0;
        currentSens = sen(currentIndices, :);
        if any(compressionMembers)
            maxCompressionSens = max(abs(currentSens(compressionMembers, :)));
            maxTensionSens = max(abs(currentSens(~compressionMembers, :)));
            currentSens(~compressionMembers, :) = currentSens(~compressionMembers, :)/(100*maxTensionSens/maxCompressionSens);
            sen(currentIndices, :) = currentSens;
        else
            maxSens = max(abs(currentSens));
            currentSens = 1./currentSens;
            currentSens = currentSens/(max(abs(currentSens))/maxSens);
            sen(currentIndices, :) = currentSens;
        end
    end
    
    
    allSens = zeros(size(members, 1), 1);
    allSens(design, :) = sen;

    % calculate the sensitivity for design variables
    varCmatrix = zeros(size(tubeSizes, 2),size(tubeSizes, 2));
    for i = 1:size(tubeSizes, 2)
        varCmatrix(i, i:end) = tubeSizes(1:end+1-i);
        varCmatrix(i, 1:i-1) = tubeSizes(end+2-i:end);
    end
    
    for i = 1:tubeNum
        currentIndices = optMembers.tubeIndex==i;
        currentVar = optMembers.var(currentIndices, :);
        currentVarPen = areaP*currentVar.^(areaP-1);
        currentVarPenM = repmat(currentVarPen, 1, size(tubeSizes, 2))';
        currentSen = sen(currentIndices, 1);
        varSen = varCmatrix.* currentVarPenM* currentSen;
        newVar = tubeUpdate(varSen, currentVar);
    
        currentVarPen = newVar.^areaP;
        newA = varCmatrix*currentVarPen;
        optMembers.var(currentIndices, :) = newVar;
        optMembers.area(currentIndices, :) = newA;
    end

    % assign new area values to members
    memdata.area(design, :) = optMembers.area;
    memdata.var(design, :) = optMembers.var;
    newMembers = memdata;
end

function xnew = tubeUpdate(dc, x)
    l1 = 0; l2 = 1000000; move = 0.2;
    xmin = 0.001;
    xmax = 1.0;
    xsum = 1.0;
    xTotal = 0;
    eta = 1.0;
    while (abs(xTotal - xsum)>1e-4)
        lmid = 0.5*(l2+l1);
        xnew = max(xmin,max(x-move,min(xmax,min(x+move, x.*(-dc./lmid).^0.5))));
        xTotal = sum(sum(xnew));
        if xTotal - xsum > 0
          l1 = lmid;
        else
          l2 = lmid;
        end
    end
end