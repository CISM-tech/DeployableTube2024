function [currentSen] = dCTruss(currentMem, u, p, transT)
    currentU = [u(currentMem.A, :), 0, u(currentMem.B, :), 0];
    length = currentMem.length;
    dk = dkTruss(currentMem.area, length);
    dk = transT' * dk * transT;
    currentSen = -p *currentMem.area^(p-1)*currentU*dk*currentU'; 
end

