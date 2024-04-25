function [bodyList , goal, displayText] = Setup(LevelListBox)    

    level = LevelListBox.Value;

    goal = Goal(LevelListBox,[0,0]',1,'defaultLevelName',false); 
    % levelname needs to be in ' and not " because we need it to be a character vector and not a string array https://uk.mathworks.com/matlabcentral/answers/485385-difference-between-single-quote-vs-double-quote
    displayText = level;
    fuel = inf; %#ok<NASGU> % default is for fuel to be infinate

    switch level % This switch contains/loads the data for each level.
        
        case "Random"
            bodyList = {nan,nan,nan,nan,nan,nan};            
            
            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject("random");
            end
        
            bodyList{size(bodyList,2)} = Astronaut();

        case "Intro"
            bodyList = {nan,nan,nan}; % earth, moon, cosmonaut ^^

            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject;
            end
            
            % da earth
            bodyList{1}.setMass(6e24);  % I use setMass because it also updates the drawing size for the body
            bodyList{1}.position = [5e8,5e8]';
            bodyList{1}.positionFrozen = true;
            bodyList{1}.colour = [0.1,0.7,0.1];


            % da moon
            bodyList{2}.setMass(7e22);
            bodyList{2}.position = [5e8+4e8,5e8]';
            bodyList{2}.velocity = [0,1e3]';
            bodyList{2}.colour = [0.5,0.5,0.5];

            % da player
            bodyList{size(bodyList,2)} = Astronaut(); % Put the player last in bodyList so they are drawn ontop of rest
            SetOrbitalSpeed(bodyList{1}, bodyList{size(bodyList,2)})
            

            displayText = "Hello there, player! Welcome to Spacehopper: A 2D physics simulation game, intended to " + ...
                "help astrophysics students get a feel for the nature of orbital mechanics."+newline+newline+" Above this text are the " + ...
                "controls for your ship. Top left is the simulation view, and bottom left has controls for the " + ...
                "simulation itself. The simulation view shows a green earth, gray moon, and a diamond. The diamond " + ...
                "is your ship! You can play around with the controls to get a feel for it. If you're not sure what " + ...
                "prograde and retrograde mean, hover your mouse over for a look at the tooltip. "+newline+newline+"When you're happy to" + ...
                " proceed, use the menu below to select a level, and press Reset and then Run simulation.";
        

        case "Level 1"
            bodyList = {nan};
            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject;
            end

            bodyList{size(bodyList,2)} = Astronaut();

            bodyList{1}.position = [5e8+2e8,5e8]';

            goal = Goal(LevelListBox,[5e8-2e8,5e8]',8000, 'Level 2');
            
            displayText = "Wahey, you made it to level 1! Before I say anything else, " + ...
                "take note that the simulation speed is set to 0 whenever you change level, so that nothing will " + ...
                "happen until you are ready. When you want the simulation to begin, turn " + ...
                "up the simulation speed. I like 20 min/s - see what you think."+newline+newline+"In other " + ...
                "news, check out the big green thing on the map! That's your goal. If you " + ...
                "can stay inside it long enough, it will go blue, and unlock the next level" + ...
                " down in the bottom right.";

        

        case "Level 2"
            bodyList = {nan};
            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject;
            end

            fuel = 100;

            bodyList{size(bodyList,2)} = Astronaut(fuel); 
            bodyList{size(bodyList,2)}.position = [5e8+4.5e8,5e8]';

            goal = Goal(LevelListBox,[5e8-3.5e8,5e8]',4000, 'Level 3');            
            
            displayText = "Welcome to level 2! The new thing now is the fuel gauge, just to the right " + ...
                "of the speed gauge. If you run out of fuel, no more boosting! Take note that fuel drains " + ...
                "at a speed based on simulation time, so you'll whack through it quickly on a high simulation speed.";
        

        case "Level 3"
            bodyList = {nan,nan};
            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject;
            end

            % da earth
            bodyList{1}.setMass(6e24);  % I use setMass because it also updates the drawing size for the body
            bodyList{1}.position = [5e8,5e8]';
            bodyList{1}.positionFrozen = true;
            bodyList{1}.colour = [0.1,0.7,0.1];

            fuel = 50;            
            bodyList{size(bodyList,2)} = Astronaut(fuel);
            bodyList{size(bodyList,2)}.position = [5e8+3e8,5e8]';
            SetOrbitalSpeed(bodyList{1}, bodyList{size(bodyList,2)})

            goal = Goal(LevelListBox,[5e8,5e8]',8000, 'Level 4');   

            displayText = "Okay, now its time to bring in other objects! You are orbiting earth, at a radius of 300 million km. I've taken half your fuel so that you must do roughly what a real spacecraft would do." + ...
                "Your goal is to reduce the radius of your orbit." +newline+newline+ ...
                "If you're not sure how to manage this, here's my advice: Burn retrograde a little bit, to reduce your speed. Too slow and you'll crash into earth. Too high and you won't get that close to earth." + ...
                " Then wait until you are as close to the earth as you ever will be, in your orbit. Once there, burn retrograde " + ...
                "again. Remember, you can always slow down the simulation (Especially handy when you are close to earth, or waiting for your ship to get closer to earth)." + newline+newline+ ...
                "You can try to use the directional arrows, but you'll find that accelerating " + ...
                "towards or away from the direction of travel is almost always the most efficent way to change your orbit.";

        case "Level 4"
            bodyList = {nan,nan};
            for index = 1:size(bodyList,2)
                bodyList{index} = PhysicsObject;
            end

            % da earth
            bodyList{1}.setMass(6e24);  % I use setMass because it also updates the drawing size for the body
            bodyList{1}.position = [5e8,5e8]';
            bodyList{1}.positionFrozen = true;
            bodyList{1}.colour = [0.1,0.7,0.1];

            fuel = 60;            
            bodyList{size(bodyList,2)} = Astronaut(fuel);
            bodyList{size(bodyList,2)}.position = [5e8+3e8,5e8]';
            SetOrbitalSpeed(bodyList{1}, bodyList{size(bodyList,2)})

            goal = Goal(LevelListBox,[5e8,5e8]',4000, 'Level 5');   

            displayText = "Can you manage a smaller orbit?"+newline+newline+"You might find it easier to gradually reduce your orbit's size" + ...
            " instead of doing it in only 2 burns like I suggested for level 3."+newline+newline+"Hot tip: burning prograde and retrograde has the most effect when you are"+...
            "travelling at minimum and maximum speed in your orbit. This is the same as the lowest (fastest) and highest (slowest) points in your orbit."+newline+newline+ ...
            "Tip 2: To modify your orbit and keep it circular, you need to burn at the highest and lowest point. If you only do one side your orbit will be";

        



        otherwise
            error("Couldn't find a level called "+ level);
        
        

    end  
    
end
