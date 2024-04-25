function simulationStep(bodyList,dt)
    %simulationTimePassed = steps*dt;
    %disp(simulationTimePassed/86400)   
    
    for j = 1:size(bodyList,2)
        bodyList{j}.SetDT(dt)
        bodyList{j}.Move(bodyList)
    end

end