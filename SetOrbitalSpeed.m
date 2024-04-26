function SetOrbitalSpeed(planet, satellite, clockwise)
    arguments
        planet
        satellite
        clockwise = false
    end
    distanceVector = planet.position - satellite.position;
    rotationMatrix = [0 1; -1, 0]; % 90 degrees ccw

    if clockwise;
        rotationMatrix = -rotationMatrix; % 90 degrees cw
    end

    directionVector = rotationMatrix * (distanceVector / norm(distanceVector));
    distance = norm(distanceVector);   
    

    speed = sqrt( (PhysicsObject.gravitationalConstant * planet.mass) / distance );
    
    satellite.velocity = planet.velocity + directionVector * speed; % add planet velocity incase it is moving (eg level 6 where we want to orbit the moon)
end

