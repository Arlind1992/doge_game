local Player = {}
Player.__index = Player
function Player:new()
    local self = setmetatable({}, Player)
    self.image = love.graphics.newImage("/Assets/bonk.png") -- Adjust the path as necessary

    self.spriteSheetHitting = love.graphics.newImage("Assets/spritesheet_bonk.png")
    self.gridHitting =anim8.newGrid(450,323, self.spriteSheetHitting:getWidth(), self.spriteSheetHitting:getHeight())


    self.todraw=false
    self.x=0
    self.y=0
    self.framesToDraw=1200
    return self
end
function Player:setXY(x,y)
    self.x=x
    self.y=y
    self.todraw=true
end


function Player:update(dt)
    if self.todraw then
        self.framesToDraw=self.framesToDraw-1
        
    end
    if self.framesToDraw==0 then
        self.todraw=false
        self.framesToDraw=120
    end
end

function Player:draw()
    if self.todraw then
        love.graphics.draw(self.image, self.x, self.y, 0, 0.2, 0.2, self.image:getWidth() / 2, self.image:getHeight() / 2)
    end
        

end

function Player:drawHitting()
    if self.todraw then
        self.animations.hitting:draw(self.spriteSheetHitting,self.body:getX(), self.body:getY()-323*PLAYER_PROPORTIONS/2, 0, PLAYER_PROPORTIONS, PLAYER_PROPORTIONS)
    end
        

end

return {Player=Player}