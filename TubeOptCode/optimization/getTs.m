function Ts = getTs(members, nodePos)
Ts = cell(size(members, 1), 1);
for i = 1:size(members, 1)
    A = members.A(i);
    B = members.B(i);
    length = members.length(i);
    transT = getT(nodePos, A, B, length);
    Ts{i, 1} = transT;
end

end

function T = getT(nodePos, A, B, length)
    node1 = nodePos(A, :);
    node2 = nodePos(B, :);
    c = (node2(1) - node1(1))/length;
    s = (node2(2) - node1(2))/length;
    T = [c s 0 0 0 0
        -s c 0 0 0 0
        0 0 1 0 0 0
        0 0 0 c s 0
        0 0 0 -s c 0
        0 0 0 0 0 1];
end