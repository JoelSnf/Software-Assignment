classdef PhysicsObject < handle

    properties
        position {isnumeric} = [0 0]'; % starting location, in metres
        positionFrozen = false;
        velocity {isnumeric} = [0 0]'; % m/s.           
        acceleration {isnumeric} = [0,0]'; % m/s^2
        
        previousPositionCounter = 0;

        mass = 1e22; % kg. Moon = 7e22 kg. Earth = 6e24 kg

        marker = "o";
        trailWidth = 2;
        colour = [0.5,0.5,0.5];
        
        % ========== these are assigned values in the constructor =============
        previousPositions; 
        drawSize; 
        id;

        dt = 60*60; % delta time. Time step of 1 hour
    end

    properties (Constant)        
        gravitationalConstant = 6.67430e-11 % G = 6.67430e-11 in our universe.
    end


    methods
        function obj = PhysicsObject(random) %#ok<INUSD>
            if nargin == 1 % nargin = number of arguments in. Funky !
                randomPos = rand(2,1)*1e9;
                %disp(randomPos)
                obj.position = randomPos;                
                
                randomMass = rand(1)*1e24;
                obj.mass = randomMass;

                randomColour = rand(1,3);
                obj.colour = randomColour;
            end

            obj.id = rand(3);

            obj.drawSize = obj.mass ^ 0.25 / 5e3;

            obj.previousPositions = NaN(2,150); % Columns decide how long the trail is. 10 quite short
        end

        function setMass(obj,mass)
            obj.mass = mass;
            obj.drawSize = obj.mass ^ 0.25 / 5e3;
        end

        function totalAcceleration = CalculateGravitationalAcceleration(obj, bodyList)
            totalAcceleration = [0,0]'; 

            for i = 1:size(bodyList,2)
                foreignBody = bodyList{i}; 

                if foreignBody.id == obj.id
                    continue
                end

                vectorToBody = foreignBody.position - obj.position;
                distance = norm(vectorToBody);
                directionToBody = vectorToBody / norm(vectorToBody);

                if distance < foreignBody.drawSize * 6e4   % bounce if too close / crash                            
                    force = - obj.gravitationalConstant * obj.mass * foreignBody.mass / distance ^ 2; % newton's law of gravitation                
                else
                    force = obj.gravitationalConstant * obj.mass * foreignBody.mass / distance ^ 2; % newton's law of gravitation                                  
                end

                forceVector = force * directionToBody;
                accelerationVector = forceVector / obj.mass;
                totalAcceleration = totalAcceleration + accelerationVector;
                
            end            
        end  
        
        function UpdateVelocity(obj, bodyList)

            obj.acceleration = obj.CalculateGravitationalAcceleration(bodyList);

            % disp(obj.velocity)
            % disp(obj.acceleration)
            obj.velocity = obj.velocity + obj.acceleration * obj.dt; % multiply by time step dt to make simulation independent of time step size
        end

        function Move(obj, bodyList)
            if obj.dt == 0 || obj.positionFrozen
                return
            end

            obj.UpdateVelocity(bodyList);
            
            obj.position = obj.position + obj.velocity * obj.dt;  % multiply by time step dt to make simulation independent of time step size
            obj.UpdatePreviousPositions();
            %disp(obj.acceleration)
        end

        function SetDT(obj, dt)
            obj.dt = dt;
        end

        function UpdatePreviousPositions(obj)
            obj.previousPositionCounter = obj.previousPositionCounter + 1;

            if obj.previousPositionCounter > 0
                obj.previousPositions(:,1) = obj.position;
                n = size(obj.previousPositions,2);
                for i = 2:n
                    j = n+2 - i ;
                    obj.previousPositions(:,j) = obj.previousPositions(:,j-1);
                end  

                obj.previousPositionCounter = 0;
            end
        end

        function DrawSelf(obj, UIAxes, drawTrail)
            if nargin == 3
                if drawTrail
                    plot(UIAxes,obj.previousPositions(1,:)',obj.previousPositions(2,:)',LineWidth=obj.trailWidth,Color=obj.colour.^0.5)

                end
            end

            scatter(UIAxes,obj.position(1,1),obj.position(2,1),obj.drawSize,'filled',Marker=obj.marker,MarkerFaceColor=obj.colour)
            
        end
    end
end