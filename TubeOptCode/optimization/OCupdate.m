function [newMembers] = OCupdate(members, nodePos, u, p)
memdata = members;
noddata = nodePos.Variables;
optMembers = memdata(memdata.design==1, :);

sen = zeros(size(optMembers, 1), 1);
for i = 1:size(optMembers, 1)
    currentMem = optMembers(i, :);
    sen(i, 1) = dCTruss(currentMem, noddata, u, p);
end

tubeNum = max(memdata.tubeIndex);
for i =1:tubeNum
    currentIndices = optMembers.tubeIndex==i;
    currentA = optMembers.area(currentIndices, :);
    currentSen = sen(currentIndices, 1);
    newA = tubeUpdate(currentSen, currentA);
    optMembers.area(currentIndices, :) = newA;
end

% assign new area values to members
memdata.area(memdata.design==1, :) = optMembers.area;
newMembers = memdata;
end

function xnew = tubeUpdate(dc, x)
    l1 = 0; l2 = 100000; move = 0.2;
    xmin = 0.001;
    xmax = 1.0;
    xsum = sum(x);
    xTotal = 0;
    while (abs(xTotal - xsum)>1e-4)
        lmid = 0.5*(l2+l1);
        xnew = max(xmin,max(x-move,min(xmax,min(x+move,x.*sqrt(-dc./lmid)))));
        xTotal = sum(sum(xnew));
        if xTotal - xsum > 0
          l1 = lmid;
        else
          l2 = lmid;
        end
    end
end