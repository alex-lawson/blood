require 'game'

WindowSize = {300, 200}
WindowScale = {3, 3}

function love.load()
    love.window.setMode(WindowSize[1] * WindowScale[1], WindowSize[2] * WindowScale[2])
    love.window.setTitle("Blood")

    GuiFont = love.graphics.newFont("cour.ttf", 16)
    love.graphics.setFont(GuiFont)

    game = Game:new({
            bloodTickTime = 0.0,
            -- bloodRainTime = 0.2,
        })

    game:init()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(unpack(WindowScale))
    game:render()
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    game:addBlood(x / WindowScale[1], y / WindowScale[2])
end

function love.mousereleased(x, y, button)

end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.focus(f)

end

function love.quit()

end

