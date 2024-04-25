classdef Astronaut < PhysicsObject
    properties
        % buttons for controlling the astronaut
        upButton;
        leftButton;
        downButton;
        rightButton;

        progradeButton;
        retrogradeButton;

        fuel {mustBeNumeric} = inf;
        fuelDrainRate {mustBeNumeric} = 1e-3;

        crashed {mustBeNumericOrLogical} = false;

        boostColour = [1,0.18,0];
        boostDirection = [0,0]';
        boosterPower {mustBeNumeric} = 0.03;
    end

    methods
        function obj = Astronaut(fuel) % constructor
            obj@PhysicsObject("random"); % this runs PhysicsObject's constructor before the astronaut (subclass) stuff
                
            obj.mass = 140; % 70 for the Astronaut, 70 for their suit

            if nargin == 1%~exist('fuel','var') 
                obj.fuel = fuel;
            end

            % ==== Cosmetics ====                     
            obj.marker = "diamond";
            obj.trailWidth = 2;
            obj.colour = [0.2,0.3,0.5];      
            obj.drawSize = 65;       
            
        end

        function setupInputButtons(obj,upButton,leftButton,downButton,rightButton,progradeButton,retrogradeButton)
            obj.upButton = upButton;
            obj.leftButton = leftButton;
            obj.downButton = downButton;
            obj.rightButton = rightButton;

            obj.progradeButton = progradeButton;
            obj.retrogradeButton = retrogradeButton;
        end

        function acceleration = CalculateBoosterAcceleration(obj)         

            if norm(obj.velocity) == 0
                directionOfTravel = rand(2,1)-0.5;
            else
                directionOfTravel = obj.velocity / norm(obj.velocity);
            end
            

            obj.boostDirection = [0,0]';         
            
            if obj.fuel < 0
                acceleration = [0,0]';
                return
            end


            if obj.progradeButton.Value == true
                obj.boostDirection = directionOfTravel;
            elseif obj.retrogradeButton.Value == true
                obj.boostDirection = -directionOfTravel;
            elseif obj.upButton.Value == true
                obj.boostDirection = [0,1]';
            elseif obj.downButton.Value == true
                obj.boostDirection = [0,-1]';
            elseif obj.leftButton.Value == true
                obj.boostDirection = [-1,0]';
            elseif obj.rightButton.Value == true
                obj.boostDirection =  [1,0]';
            end
            
            acceleration = obj.boosterPower * obj.boostDirection;            
            
        end

        function UpdateVelocity(obj, bodyList)

            if obj.position(2,1) > 9.9e8 % ensure the astronaut stays within the visible area
                obj.velocity(2,1) = -1e3;
            elseif obj.position(2,1) < 1e7
                obj.velocity(2,1) = 1e3;
            end

            if obj.position(1,1) > 9.9e8
                obj.velocity(1,1) = -1e3;
            elseif obj.position(1,1) < 1e7
                obj.velocity(1,1) = 1e3;
            end
            

            playerIsBoosting = norm(obj.boostDirection) ~= 0;
            if playerIsBoosting && obj.fuel ~= inf
                obj.fuel = obj.fuel - obj.fuelDrainRate * obj.dt;
            end
                
            obj.checkIfCrashed(bodyList)

            obj.acceleration = obj.CalculateGravitationalAcceleration(bodyList)+ obj.CalculateBoosterAcceleration();

            % disp(obj.velocity)
            % disp(obj.acceleration)
            obj.velocity = obj.velocity + obj.acceleration * obj.dt; % multiply by time step dt to make simulation independent of time step size
        end

        function checkIfCrashed(obj, bodyList)
            for i = 1:size(bodyList,2)
                foreignBody = bodyList{i}; 

                if foreignBody.id == obj.id
                    continue
                end

                vectorToBody = foreignBody.position - obj.position;
                distance = norm(vectorToBody);

                if distance < foreignBody.drawSize * 6e4 && norm(obj.velocity) > 1000            
                           
                    obj.crashed = true;

                    disp("Crashed!")
                end

            end
        end

        function DrawSelf(obj, UIAxes, drawTrail)
            playerIsBoosting = norm(obj.boostDirection) ~= 0;
            if playerIsBoosting % Draw boost flames 🔥🔥. Plots between the rocket and random spots nearby, a bit like a scribble.
                positionMatrix = [obj.position,obj.position,obj.position];
                boostDirectionMatrix = [obj.boostDirection,obj.boostDirection,obj.boostDirection];
                boostVectors = positionMatrix - boostDirectionMatrix * 3e7 + (rand(2,3)-0.5) * 3e7;
                plot(UIAxes,[positionMatrix(1,:),boostVectors(1,:)],[positionMatrix(2,:),boostVectors(2,:)], ...
                    LineWidth=obj.trailWidth*2,Color=obj.boostColour,LineStyle="-.")
            end
            
            DrawSelf@PhysicsObject(obj, UIAxes,drawTrail);
            
        end


    end
end