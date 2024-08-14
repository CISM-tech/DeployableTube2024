function [forces] = getInternalForce(currentMem, u, localK, transT)
    currentU = [u(currentMem.A, :), 0, u(currentMem.B, :), 0];
    forces = transT*localK*currentU';
end

