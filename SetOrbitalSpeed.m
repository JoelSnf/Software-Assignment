function SetOrbitalSpeed(planet, satellite)
    distanceVector = planet.position - satellite.position;
    rotationMatrix = [0 1; -1, 0]; % 90 degrees cw
    directionVector = rotationMatrix * (distanceVector / norm(distanceVector));
    distance = norm(distanceVector);   
    

    speed = sqrt( (PhysicsObject.gravitationalConstant * planet.mass) / distance );
    
    satellite.velocity = directionVector * speed;
end

