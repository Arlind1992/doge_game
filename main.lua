local WINDOW_WIDTH = 900
local WINDOW_HEIGHT = 480
local ENEMY_SIZE = 20
local PLAYER_SIZE = 30

--introduced to further facilitate the code
local PLAYER_PROPORTIONS = 0.25
local CENTER_MASS = 0.5

local enemyModule = require("objects/enemy")  -- Adjust the path if necessary
local Enemy = enemyModule.Enemy

local girlModule = require("objects/girl")  -- Adjust the path if necessary
local Girl = girlModule.Girl

local playerModule = require("objects/player")  -- Adjust the path if necessary
local Player = playerModule.Player


local FRAME_WIDTH = enemyModule.FRAME_WIDTH
local FRAME_HEIGHT = enemyModule.FRAME_HEIGHT
local ENEMY_PROPORTIONS = enemyModule.ENEMY_PROPORTIONS


-- Variables
local enemies = {}
local girls = {}

local enemySpeed = 200
local score = 0

local gameStarted = false

local game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        gameover = false,
        hitting = false
    }
}

local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state['hitting'] = state =='hitting'
    game.state["gameover"] = state == "gameover"
end

local function startNewGame()
    changeGameState("running")
    game.points = 0
    score = 0
end
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then -- Left mouse button
        player:setXY(x,y)
        
    end
end

function love.keypressed(key)
    if game.state["menu"] then
        if key == 'r' then
            startNewGame()
        elseif key == 'q' then
            love.event.quit()
        end
    elseif game.state["gameover"] then
        if game.points > bestscore then
            bestscore = game.points
            enemies_jumped = score
            saveScore()
        end
        if key == 'r' then
            startNewGame()
        elseif key == 'q' then
            love.event.quit()
        end
        
    end
end

love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT, flags )

function isArrayEmpty(array)
    return next(array) == nil
end

------------------------------------------------------------GAME LOAD-----------------------------------------------------------------

function love.load()

    -- Import anim8 library
    anim8 = require 'libraries/anim8'
    love.window.setTitle("Boink the Enemies")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true
    })
    player=Player:new()
    backgroundImage = love.graphics.newImage("/Assets/backgroundDoge2.png") -- Adjust the path as necessary
    local highscores={}
    for line in love.filesystem.lines("datas.txt") do
        table.insert(highscores, tonumber(line))
    end
    bestscore=highscores[1]
    enemies_jumped=highscores[2]
    -- Create the physics world
    

    -- Create the ground
    bodiesToDestroy={}
    -- Set random seed
    math.randomseed(os.time())
    game.points = 0
    score = 0
end

----------------------------------------------------------GAME UPDATE--------------------------------------------------------------

function love.update(dt)
    --print()

    --and player.body:isTouching( groundBody.body )
    createGirls(dt)  
    createEnemies(dt)
    player:update()
    


    if not game.state["gameover"] then
        game.points = game.points + dt
    end
    if game.state["hitting"] then
        player.animations.hitting:update(dt)

        last = last +dt
        if last > 0.3 then
            changeGameState('running')
        end    
    end

    --player.animations.running:update(dt)
end

function getClosestGirl(x,y) 
    local closest=girls[1]
    local dx, dy = x - closest.x, y - closest.y
    local distance = math.sqrt(dx * dx + dy * dy)
    for _, gi in ipairs(girls) do
        local dx_c, dy_c = x - gi.x, y - gi.y
        local distance_c = math.sqrt(dx * dx + dy * dy)
        if distance>distance_c then
            distance=distance_c
            closest=gi
        end
    end
    return closest.x,closest.y
end

function createEnemies(dt)
    if math.random() < 0.5 then
        local x_enemy = math.random(0, love.graphics.getWidth())
        local y_enemy = math.random(0, love.graphics.getHeight())
        x_girl,y_girl=getClosestGirl(x_enemy,y_enemy)
        dx=x_girl-x_enemy
        dy=y_girl-y_enemy
        
        if math.sqrt(dx * dx + dy * dy)<200 then
            return
        end

        table.insert(enemies, Enemy.new(x_girl,y_girl,x_enemy,y_enemy))
    end
    -- Move enemies towards the player
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:update(dt)
        
        
    end
end

function createGirls(dt)
    if isArrayEmpty(girls) then
        table.insert(girls,Girl:new())
    end

    --if math.random() < 0.01 then
    --    table.insert(girls,Girl:new())
    --end
  
end


-------------------------------------------------------------GAME DRAW----------------------------------------------------------------

function love.draw()
    if game.state["menu"] then
        gameStart()
    elseif game.state['running'] or game.state['hitting'] then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(backgroundImage, 0, 0, 0, 1, 1)
     
        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end
        for _, gi in ipairs(girls) do
            gi:draw()
        end
        -- Display score
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Score: " .. game.points, 10, 10)
        love.graphics.print("Enemies surpassed: " .. score, 20, 20)
        love.graphics.print("Highscore " .. bestscore, WINDOW_WIDTH- 150, 10)
        player:draw()
        
    elseif game.state["gameover"] then
        gameOver()
    
    end
    
end

-----------------------------------------------------------FUNCTIONS-----------------------------------------------------------------

function gameStart()    
    love.graphics.print("Your Highscore is " .. bestscore, WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 10)
    love.graphics.print("Press 'r' to start or 'q' to quit", WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 30)
end


function gameOver()
    love.graphics.print("Game Over!", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 - 10)
    if game.points > bestscore then
        love.graphics.print("New HighScore: " .. game.points, WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 10)
    else
        love.graphics.print("New Score: " .. game.points, WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 10)
    end
    love.graphics.print("Enemies Jumped: " .. score, WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 20)
    love.graphics.print("Press 'r' to start or 'q' to quit", WINDOW_WIDTH / 2 - 70, WINDOW_HEIGHT / 2 + 30)
    
end

function saveScore()
    local ScoreData={bestscore, enemies_jumped}
    love.filesystem.write("datas.txt", table.concat(ScoreData,"\n"))
end