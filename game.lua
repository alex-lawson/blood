require 'util'

Game = {}

SpreadOffs1 = {
    {-1, 0},
    {1, 0},
    {0, -1},
    {0, 1}
}
SpreadOffs2 = {
    {-1, -1},
    {1, 1},
    {1, -1},
    {-1, 1}
}

-- BloodDecay = 2
-- BloodSpreadDecay = 5
-- BloodSpreadDecay2 = 7

-- BloodSpreadMax = 0.9
-- BloodSpreadMax2 = 0.75

function Game:new(config)
    local newGame = setmetatable(copy(config), {__index=Game})

    newGame.bloodData = love.image.newImageData(unpack(WindowSize))
    newGame.flowData = love.image.newImageData("flowmap.png")

    newGame.bgImage = love.graphics.newImage("background.png")
    newGame.bgImage:setFilter("nearest", "nearest")

    newGame.bloodTickTimer = 0
    newGame.bloodRainTimer = 0

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

    self.bloodTickTimer = self.bloodTickTimer - dt
    if self.bloodTickTimer <= 0 then
        self.bloodTickTimer = self.bloodTickTime

        -- local bloodData = self.bloodCanvas:newImageData()
        local newBloodData = love.image.newImageData(unpack(WindowSize))
        for x = 1, WindowSize[1] - 2 do
            for y = 1, WindowSize[2] - 2 do
                -- SIMPLE MAX

                -- local maxBlood = bloodData:getPixel(x, y)
                -- maxBlood = math.max(0, maxBlood - BloodDecay)
                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]
                --     local tBlood = bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood - BloodSpreadDecay)
                -- end
                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]
                --     local tBlood = bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood - BloodSpreadDecay2)
                -- end
                -- newBloodData:setPixel(x, y, maxBlood, 0, 0, 255)

                -- MAX + TOTAL

                -- local totalBlood = self.bloodData:getPixel(x, y)
                -- totalBlood = math.max(0, totalBlood - BloodDecay)
                -- local maxBlood = totalBlood
                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]
                --     local tBlood = self.bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood * BloodSpreadMax)
                --     totalBlood = totalBlood + math.max(0, tBlood - BloodSpreadDecay) * 0.1
                -- end
                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]
                --     local tBlood = self.bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood * BloodSpreadMax2)
                --     totalBlood = totalBlood + math.max(0, tBlood - BloodSpreadDecay2) * 0.05
                -- end
                -- totalBlood = math.min(totalBlood, maxBlood)
                -- newBloodData:setPixel(x, y, totalBlood, 0, 0, 255)

                -- FLOW

                -- local _, _, _, totalBlood = self.bloodData:getPixel(x, y)
                -- totalBlood = math.max(0, totalBlood - BloodDecay)
                -- local maxBlood = totalBlood

                -- local _, _, _, flow = self.flowData:getPixel(x, y)

                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]

                --     local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                --     local flowDiff = tFlow - flow

                --     local _, _, _, tBlood = self.bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood * BloodSpreadMax)
                --     totalBlood = totalBlood + math.max(0, tBlood - 7 * flowDiff) * 0.1
                -- end
                -- for i = 1, 4 do
                --     local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]

                --     local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                --     local flowDiff = tFlow - flow

                --     local _, _, _, tBlood = self.bloodData:getPixel(tx, ty)
                --     maxBlood = math.max(maxBlood, tBlood * BloodSpreadMax)
                --     totalBlood = totalBlood + math.max(0, tBlood - 5 * flowDiff) * 0.1
                -- end
                -- totalBlood = math.min(totalBlood, maxBlood)
                -- newBloodData:setPixel(x, y, 255, 0, 0, totalBlood)

                -- FLOW 2

                -- local FlowRate = 50
                -- local AgeDecay = 4

                -- local amount, _, _, age = self.bloodData:getPixel(x, y)
                -- local _, _, _, flow = self.flowData:getPixel(x, y)

                -- if amount > 0 then
                --     age = math.max(0, age - AgeDecay)
                --     local flowAmount = math.max(amount, FlowRate)

                --     local flowRatios = {}
                --     local flowDenom = 0
                --     for i = 1, 4 do
                --         local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]

                --         local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                --         local flowDiff = tFlow - flow

                --         flowRatios[i] = math.max(0, flowDiff + 1)
                --         flowDenom = flowDenom + flowRatios[i]
                --     end

                --     for i = 1, 4 do
                --         local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]

                --         local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                --         local flowDiff = tFlow - flow

                --         flowRatios[i] = math.max(0, flowDiff + 1) * 0.7
                --         flowDenom = flowDenom + flowRatios[i]
                --     end

                --     for i = 1, 4 do
                --         if flowRatios[i] > 0 then
                --             local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]

                --             local tAmount, _, _, tAge = newBloodData:getPixel(tx, ty)

                --             tAmount = tAmount + math.ceil(flowAmount * (flowRatios[i] / flowDenom))
                --             tAmount = math.min(255, tAmount)

                --             tAge = math.max(tAge, age)

                --             newBloodData:setPixel(tx, ty, tAmount, 0, 0, tAge)
                --         end
                --     end

                --     for i = 1, 4 do
                --         if flowRatios[i] > 0 then
                --             local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]

                --             local tAmount, _, _, tAge = newBloodData:getPixel(tx, ty)

                --             tAmount = tAmount + math.ceil(flowAmount * (flowRatios[i] / flowDenom))
                --             tAmount = math.min(255, tAmount)

                --             tAge = math.max(tAge, age)

                --             newBloodData:setPixel(tx, ty, tAmount, 0, 0, tAge)
                --         end
                --     end

                --     amount = amount - flowAmount
                --     local tAmount, _, _, tAge = newBloodData:getPixel(x, y)
                --     amount = math.min(255, amount + tAmount)
                --     age = math.max(age, tAge)
                --     newBloodData:setPixel(x, y, amount, 0, 0, age)
                -- end

                -- FLOW 3

                local AgeDecay = 5
                local BaseResist = 80
                local ResistFactor = 70
                local ResistFactor2 = 90

                local pressure = self.bloodData:getPixel(x, y)
                local _, _, _, flow = self.flowData:getPixel(x, y)

                for i = 1, 4 do
                    local tx, ty = x + SpreadOffs1[i][1], y + SpreadOffs1[i][2]

                    local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                    local flowDiff = flow - tFlow

                    local tPressure = self.bloodData:getPixel(tx, ty)

                    local resistance = BaseResist - math.min((flowDiff + 0.5) * ResistFactor, tPressure)

                    tPressure = math.max(0, tPressure - resistance)

                    pressure = math.max(pressure, tPressure - AgeDecay)
                end

                for i = 1, 4 do
                    local tx, ty = x + SpreadOffs2[i][1], y + SpreadOffs2[i][2]

                    local _, _, _, tFlow = self.flowData:getPixel(tx, ty)
                    local flowDiff = flow - tFlow

                    local tPressure = self.bloodData:getPixel(tx, ty)

                    local resistance = BaseResist - math.min((flowDiff + 0.5) * ResistFactor2, tPressure)

                    tPressure = math.max(0, tPressure - resistance) * 0.6

                    pressure = math.max(pressure, tPressure - AgeDecay)
                end

                pressure = math.max(0, math.min(255, pressure) - AgeDecay)

                newBloodData:setPixel(x, y, pressure, 0, 0, 255)
            end
        end

        self.bloodData = newBloodData
    end
end

function Game:render()
    local bloodRenderData = love.image.newImageData(unpack(WindowSize))
    bloodRenderData:paste(self.bloodData, 0, 0, 0, 0, unpack(WindowSize))
    bloodRenderData:mapPixel(function(x, y, r, g, b, a)
            if r > 0 then
                return 170, g, b, a
            else
                return r, g, b, 0
            end
        end)

    local bloodImage = love.graphics.newImage(bloodRenderData)
    bloodImage:setFilter("nearest", "nearest")

    love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.setBlendMode("add")

    love.graphics.draw(self.bgImage, 0, 0)
    love.graphics.draw(bloodImage, 0, 0)
end

function Game:addBlood(x, y)
    self.bloodData:setPixel(x, y, 255, 0, 0, 255)
end
