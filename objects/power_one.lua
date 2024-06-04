local PowerOne = {}
PowerOne.__index = PowerOne

-- Fixed dimensions for each frame within the sprite sheet
--local FRAME_WIDTH = 86
-- local FRAME_HEIGHT = 124

-- Fixed dimensions for each frame within the sprite sheet

ACTIVATEDFRAMES=30
POWERACTIVATED=240
BARWIDTH=300
BARHEIGHT=20

function PowerOne:new()

    local self = setmetatable({}, PowerOne)

    self.image = love.graphics.newImage("/Assets/sharingan.png") -- Adjust the path as necessary
    self.imageActivated = love.graphics.newImage("/Assets/bigdoge_powerup.png") -- Adjust the path as necessary
    
    self.x = math.random(0, love.graphics.getWidth())
    self.y = math.random(0, love.graphics.getHeight())
    self.imageWidth = self.image:getWidth()/4
    self.imageHeight = self.image:getHeight()/4

    self.xactivated = 0
    self.yacticated = 0
    self.imageWidthActivated = self.imageActivated:getWidth()/2
    self.imageHeightActivated = self.imageActivated:getHeight()/2
    self.activatedFrames=ACTIVATEDFRAMES
    self.powerActivated=POWERACTIVATED
    return self
end


-- Method to draw the enemy
function PowerOne:update(dt)
    if game.state["powerOneClickedAnimation"] then
        self.activatedFrames=self.activatedFrames-1
    end
    if game.state["powerOneClickedAnimation"] and self.activatedFrames ==0 then
        changeGameState("powerOneClicked")
        self.activatedFrames=ACTIVATEDFRAMES
    end
    if game.state["powerOneClicked"] then
        self.powerActivated=self.powerActivated-1
    end
    if game.state["powerOneClicked"] and self.powerActivated ==0 then
        changeGameState("running")
        self.powerActivated=POWERACTIVATED
    end

end


-- Method to draw the enemy
function PowerOne:draw()
    if game.state["powerOneClickedAnimation"] then
        love.graphics.draw(self.imageActivated, self.xactivated, self.yactivated, 0, 1, 1, 0, 0)
    elseif not game.state["powerOneClicked"] then
        love.graphics.draw(self.image, self.x, self.y, 0, 1/4, 1/4, self.imageWidth, self.imageHeight)
    elseif game.state["powerOneClicked"] then
        self:drawBar()
    end
end

function PowerOne:handleClick(x_click,y_click)  
    return x_click >= self.x and x_click <= self.x + self.imageWidth and y_click >= self.y and y_click <= self.y + self.imageHeight
end

function PowerOne:drawBar()
    -- Calculate the width of the timer bar based on remaining time
    local currentBarWidth = (self.powerActivated/POWERACTIVATED) * BARWIDTH
    local barX=love.graphics.getWidth()-BARWIDTH
    -- Draw the background bar (for the remaining time)
    love.graphics.setColor(0.8, 0.8, 0.8)  -- Grey color
    love.graphics.rectangle("fill", barX, 0, BARWIDTH, BARHEIGHT)
    
    -- Draw the timer bar (for the elapsed time)
    love.graphics.setColor(0.2, 0.6, 0.8)  -- Blue color
    love.graphics.rectangle("fill", barX, 0, currentBarWidth, BARHEIGHT)
    
    -- Draw the border of the bar
    love.graphics.setColor(0, 0, 0)  -- Black color
    love.graphics.rectangle("line", barX, 0, BARWIDTH, BARHEIGHT)
    
end



-- Expose the module
return {
    PowerOne = PowerOne
}