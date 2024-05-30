local Enemy = {}
Enemy.__index = Enemy

-- Fixed dimensions for each frame within the sprite sheet
--local FRAME_WIDTH = 86
-- local FRAME_HEIGHT = 124

-- Fixed dimensions for each frame within the sprite sheet
local enemySpeed = 200
local ENEMY_PROPORTIONS = 0.52

 local scaleFactor = 0.4  -- Scale factor for the size of the enemy
--local scaleFactor = 1  -- Scale factor for the size of the enemy


function Enemy.new(objectiveX, objectiveY,x,y)

    local self = setmetatable({}, Enemy)

    self.image = love.graphics.newImage("/Assets/simp.png") -- Adjust the path as necessary
    self.objectiveX=objectiveX
    self.objectiveY=objectiveY
    self.x = x
    self.y = y
    self.speed = 100 -- Pixels per second
    self.size = 20 -- Object size (radius)
    
    return self
end




-- Method to update the enemy (should be called from love.update)
function Enemy:update(dt)
    -- Calculate direction towards the objective
    local dx, dy = self.objectiveX - self.x, self.objectiveY - self.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    if distance > 0 then
        self.x = self.x + (dx / distance) * self.speed * dt
        self.y = self.y + (dy / distance) * self.speed * dt
    end
end


-- Method to draw the enemy
function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.2, 0.2, self.image:getWidth() / 2, self.image:getHeight() / 2)
end


-- Expose the module
return {
    Enemy = Enemy,
    ENEMY_PROPORTIONS = ENEMY_PROPORTIONS
}