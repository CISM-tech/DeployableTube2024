function kTruss = getkTruss(A, L)
    E = 1;
    kTruss = [E*A/L, 0, 0, -E*A/L, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0;
            -E*A/L, 0, 0, E*A/L, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0];
end