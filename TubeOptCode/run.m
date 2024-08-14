close all
addPath
% construct geometry
N = 9;
startPt = [1 1];
endPt = [11, 3];
x = linspace(startPt(1),endPt(1),endPt(1));
y = linspace(startPt(2),endPt(2),endPt(2));
[X,Y] = meshgrid(x,y) ;
centers = [reshape(X, [], 1), reshape(Y, [], 1)]; 
radius = 0.5;
segNum = 12;
exteriorArea = 1.0;
tubeSizes = [110, 0.0, 0.0, 0.0, 0.0, 0.0];
[members, nodePos] = createTubes(centers, radius, segNum, mean(tubeSizes), exteriorArea);

% Optimization process
load = [5.0, 3.5, 0, -1, 0;
        6.0, 3.5, 0, -1, 0;
        7.0, 3.5, 0, -1, 0;
        ]; %x, y, ldx, ldy
support = [1.0, 0.5, 1, 1, 0;
           2.0, 0.5, 1, 1, 0;
           10.0, 0.5, 1, 1, 0;
           11.0, 0.5, 1, 1, 0;];
changeC = 1.0;
oldC = 0.0;
itr = 1;
history = zeros(200, 2);

transTs = getTs(members, nodePos.Variables);
num=1;

while changeC>1e-6 && itr < 200
    % FE analysis
    [u, localKs] = FEACompressiononly(members, nodePos, transTs, load, support);

    C = getC(load, nodePos.Variables, u);
    changeC = abs(C-oldC)/C;
    oldC = C;
    fprintf('It.:%5i Obj.:%11.4f ch.:%7.3f\n',itr, C,changeC);
    % OC update scheme
    members = OCupdatemulti(members, u(:, 1:2), localKs, transTs, tubeSizes);
    history(itr, :) = [itr, C];
    itr = itr + 1;
    figure()
    plotStructureColor(members, nodePos, u(:, 1:2), localKs, transTs, num);
    num = num + 1;
end

