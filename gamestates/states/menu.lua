-- states/menu.lua
local menuState = {}

function menuState.enter()
    print("Entered Menu State")
end

function menuState.exit()
    print("Exited Menu State")
end

function menuState.update(dt)
    -- Menu state update logic
end

function menuState.draw()
    love.graphics.print("Menu State", 100, 100)
end

function menuState.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        GameState.switchState("game")
    end
end

function menuState.keypressed(key)
    if key == 'r' then
        GameState.switchState("running")
    elseif key == 'q' then
        love.event.quit()
    end

end

return menuState