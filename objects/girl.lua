local Girl = {}
Girl.__index = Girl

-- Fixed dimensions for each frame within the sprite sheet
--local FRAME_WIDTH = 86
-- local FRAME_HEIGHT = 124

-- Fixed dimensions for each frame within the sprite sheet



function Girl.new()

    local self = setmetatable({}, Girl)

    self.image = love.graphics.newImage("/Assets/girl.png") -- Adjust the path as necessary
    
    self.x = math.random(0, love.graphics.getWidth())
    self.y = math.random(0, love.graphics.getHeight())
    
    return self
end


-- Method to draw the enemy
function Girl:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end


-- Expose the module
return {
    Girl = Girl,
    ENEMY_PROPORTIONS = ENEMY_PROPORTIONS
}