local GameState = {}

GameState.states = {}
GameState.currentState = nil

function GameState.addState(name, state)
    GameState.states[name] = state
end

function GameState.switchState(name)
    if GameState.states[name] then
        if GameState.currentState and GameState.states[GameState.currentState].exit then
            GameState.states[GameState.currentState].exit()
        end
        GameState.currentState = name
        if GameState.states[GameState.currentState].enter then
            GameState.states[GameState.currentState].enter()
        end
    else
        error("State '" .. name .. "' does not exist.")
    end
end

function GameState.update(dt)
    if GameState.currentState and GameState.states[GameState.currentState].update then
        GameState.states[GameState.currentState].update(dt)
    end
end

function GameState.draw()
    if GameState.currentState and GameState.states[GameState.currentState].draw then
        GameState.states[GameState.currentState].draw()
    end
end

function GameState.mousepressed(x, y, button, istouch, presses)
    if GameState.currentState and GameState.states[GameState.currentState].mousepressed then
        GameState.states[GameState.currentState].mousepressed(x, y, button, istouch, presses)
    end
end

return GameState