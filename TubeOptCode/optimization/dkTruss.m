function [kTruss] = dkTruss(A,L)
E = 1;
    kTruss = [E/L, 0, 0, -E/L, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0;
            -E/L, 0, 0, E/L, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0];
end

