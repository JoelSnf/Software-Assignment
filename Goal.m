classdef Goal < handle
    
    properties
        position = [0,0]'; 
        drawSize; % 8000 usually
        nextLevelName;  % "Level 1" or similar
        Visible = true;

        levelListBox; % ui object, needs to be passed in

        progress = 0;
        progressSlowingFactor = 3200;
        
        inverted {mustBeNumericOrLogical} = false; % Inverted = means the mission is to be *outside* of the goal area.

        marker="o";
        goalAlpha = 0.5;
        defaultColour = [0.39,0.83,0.07];
        progressColour = [0.19,0.53,0.07];
        colour = [0.39,0.83,0.07];
    end

    methods
        function obj = Goal(LevelListBox, position,drawSize, nextLevelName, Inverted ,Visible)
            arguments
                LevelListBox
                position
                drawSize
                nextLevelName
                Inverted = false;
                Visible = true;
            end

            obj.levelListBox = LevelListBox;
            obj.position = position;
            obj.drawSize = drawSize;
            obj.nextLevelName = nextLevelName;
            obj.inverted = Inverted;

            if obj.inverted                
                obj.defaultColour = [0.85,0.25,0.25];
                obj.colour = obj.defaultColour;
            end

            if ~exist('Visible','var')
                % Visible does not exist, so default it to true
                 Visible = true;
            end
            
            obj.Visible = Visible;
        end

        function CheckIfAstronautNearby(obj, astronaut)
            if not(obj.Visible) || obj.progress == inf || astronaut.crashed 
                return
            end 

            endIndex = size(obj.levelListBox.Items,2); 
            nextLevelIsAlreadyInList = false;

            for i = 1:endIndex % check to see wether this level has been beaten already.
                if string(obj.levelListBox.Items{i}) == string(obj.nextLevelName)
                    nextLevelIsAlreadyInList = true;
                    % obj.progress = inf;
                    % obj.colour = [0.30,0.75,0.93];
                    % obj.goalAlpha = 0.3;
                    % return
                end
            end

            astronautPos = astronaut.position;

            goalRadius = 1.11e6 * obj.drawSize ^ 0.5; % Should be 1e8 when drawsize = 8000.
            
            astronautInsideGoal = ( norm(astronautPos - obj.position) ) < goalRadius;

            if astronautInsideGoal ~= obj.inverted % Progress if the player is in the region they should be
                obj.colour = obj.progressColour;
                obj.progress = obj.progress + 2 * (astronaut.dt / obj.progressSlowingFactor);
            else
                obj.colour = obj.defaultColour;
                obj.progress = obj.progress - 0.5 * (astronaut.dt / obj.progressSlowingFactor);
            end

            if obj.progress > 100                
                disp("Nice, you did it !")

                obj.progress = inf; % I'm using progress == inf to represent the goal being complete
                obj.colour = [0.30,0.75,0.93];
                obj.goalAlpha = 0.3;                
                

                for i = 1:endIndex
                    if string(obj.levelListBox.Items{i}) == string(obj.nextLevelName)
                        nextLevelIsAlreadyInList = true;
                    end
                    
                    if not(nextLevelIsAlreadyInList)
                        obj.levelListBox.Items{endIndex+1} = obj.nextLevelName;  % This only works if obj.nextLevelName is in '' and not "".  See my comment in Setup.m            
                    end
                end

                return % this return is to prevent the code below from changing obj.goalAlpha

            elseif obj.progress < 0
                obj.progress = 0;
            end

            obj.goalAlpha = (obj.progress / 300) + 0.2;
        end

            


        function DrawSelf(obj, UIAxes)
            if not(obj.Visible)
                return
            end

            scatter(UIAxes,obj.position(1,1),obj.position(2,1), ...
            obj.drawSize, ...
            Marker=obj.marker, ...
            MarkerEdgeColor=obj.colour, ...
            MarkerFaceColor=obj.colour, ...
            MarkerFaceAlpha=obj.goalAlpha)
            
        end
    end
end