-- [[ LIBS ]]
Gamestate = require 'src.libs.gamestate'
Gamestate.registerEvents()

CameraManager = require 'src.libs.camera'

-- [[ UTILS ]]
require 'src.utils.memoise'
require 'src.utils.drawing'

Class     = require 'src.utils.class'

-- [[ MAIN ]]
NewGamestate = require 'src.engine.gamestate'
WorldManager = require 'src.engine.world'

-- [[ STATES ]]
Menu  = NewGamestate{
    World = WorldManager.new{
        systems   = {Systems.ShapeRenderer};
        instances = {Objects.Player:new()}; 
    };
}

Game  = NewGamestate()

Gamestate.switch(Menu)