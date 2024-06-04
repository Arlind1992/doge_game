local PowerOne = {}
PowerOne.__index = PowerOne

-- Fixed dimensions for each frame within the sprite sheet
--local FRAME_WIDTH = 86
-- local FRAME_HEIGHT = 124

-- Fixed dimensions for each frame within the sprite sheet



function Bat.new()

    local self = setmetatable({}, Bat)

    self.image = love.graphics.newImage("/Assets/batdoge.png") -- Adjust the path as necessary
       
    return self
end

function love.update(dt)
    -- Increase the rotation angle over time
    rotation = rotation + dt
end
-- Method to draw the enemy
function Bat:draw()
    local x = love.graphics.getWidth() / 2
    local y = love.graphics.getHeight() / 2

    -- Draw the image with rotation
    love.graphics.draw(image, x, y, rotation, 1, 1, imageWidth / 2, imageHeight / 2)
end

-- Expose the module
return {
    Bat = Bat
}