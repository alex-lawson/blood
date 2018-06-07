require 'util'

GameConfig = {
    ageDecay = 0.04,
    baseResist = 0.15,
    neighbors = {
        {{-1, 0}, 100, 1.0},
        {{1, 0}, 100, 1.0},
        {{0, -1}, 100, 0.7},
        {{0, 1}, 100, 0.7},
        {{-1, -1}, 100, 0.6},
        {{1, 1}, 100, 0.6},
        {{1, -1}, 100, 0.6},
        {{-1, 1}, 100, 0.6},
    },
    poolConfig = {
        cx = 150,
        cy = 94,
        rxMin = 19,
        rxMax = 30,
        ryMin = 5,
        ryMax = 11,
        rFactor = 1 / 98,
    },
    bloodRed = 0.6
    -- bloodRainTime = 0,
}

Game = {}

function Game:new()
    local newGame = setmetatable(copy(GameConfig), {__index=Game})

    newGame.canvas = love.graphics.newCanvas(unpack(WindowSize))
    newGame.canvas:setFilter("nearest", "nearest")

    newGame.bloodData = love.image.newImageData(unpack(WindowSize))
    newGame.flowData = love.image.newImageData("flowmap.png")

    newGame.bgImage = love.graphics.newImage("background.png")

    newGame.fgImage = love.graphics.newImage("totem.png")

    newGame.bloodTickTimer = 0
    newGame.bloodRainTimer = 0

    newGame.currentBlood = 0

    return newGame
end

function Game:init()

end

function Game:update(dt)
    if self.bloodRainTime then
        self.bloodRainTimer = self.bloodRainTimer - dt
        if self.bloodRainTimer <= 0 then
            self.bloodRainTimer = self.bloodRainTime

            self:addBlood(math.random(1, WindowSize[1] - 1), math.random(1, WindowSize[2] - 1))
        end
    end

    self.currentBlood = 0

    local newBloodData = love.image.newImageData(unpack(WindowSize))
    for x = 1, WindowSize[1] - 2 do
        for y = 1, WindowSize[2] - 2 do
            local pressure = self.bloodData:getPixel(x, y)
            local _, _, _, flow = self.flowData:getPixel(x, y)

            for i = 1, #self.neighbors do
                local n = self.neighbors[i]

                local nx, ny = x + n[1][1], y + n[1][2]

                local _, _, _, nFlow = self.flowData:getPixel(nx, ny)
                local flowDiff = flow - nFlow

                local nPressure = self.bloodData:getPixel(nx, ny)

                local resistance = self.baseResist - math.min(flowDiff * n[2], nPressure)

                nPressure = math.max(0, nPressure - resistance) * n[3]

                pressure = math.max(pressure, nPressure - self.ageDecay)
            end

            if flow == 1 then -- collection cell
                self.currentBlood = self.currentBlood + math.min(1, pressure)
                newBloodData:setPixel(x, y, 0, 0, 0, 1)
            else
                pressure = math.max(0, math.min(1, pressure) - self.ageDecay)

                newBloodData:setPixel(x, y, pressure, 0, 0, 1)
            end
        end
    end

    self.bloodData = newBloodData
end

function Game:render()
    love.graphics.setCanvas(self.canvas)

    local bloodRenderData = love.image.newImageData(unpack(WindowSize))
    bloodRenderData:paste(self.bloodData, 0, 0, 0, 0, unpack(WindowSize))
    bloodRenderData:mapPixel(function(x, y, r, g, b, a)
            if r > 0 then
                return self.bloodRed, g, b, a
            else
                return r, g, b, 0
            end
        end)

    local bloodImage = love.graphics.newImage(bloodRenderData)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(self.bgImage, 0, 0)
    love.graphics.draw(bloodImage, 0, 0)

    love.graphics.setColor(self.bloodRed, 0, 0, 1)
    local bloodFactor = math.min(1.0, self.currentBlood * self.poolConfig.rFactor)
    local rx = self.poolConfig.rxMin + bloodFactor * (self.poolConfig.rxMax - self.poolConfig.rxMin)
    local ry = self.poolConfig.ryMin + bloodFactor * (self.poolConfig.ryMax - self.poolConfig.ryMin)
    love.graphics.ellipse("fill", self.poolConfig.cx, self.poolConfig.cy, rx, ry, 50)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(self.fgImage, 0, 0)
    -- love.graphics.print(string.format("Current blood: %d", self.currentBlood), 10, 5)

    love.graphics.setCanvas()

    love.graphics.push()
    love.graphics.scale(unpack(WindowScale))
    love.graphics.draw(self.canvas, 0, 0)
    love.graphics.pop()
end

function Game:addBlood(x, y)
    self.bloodData:setPixel(x, y, 1, 0, 0, 1)
end
