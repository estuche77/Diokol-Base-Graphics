--[[
    Created by Jason Latouche
    2018, march 10th
    Triangle Bar Chart for Diokol
]]

require "dbg/DklLabel"

local function roundToFirstDecimal(t)
    return math.floor(t)
end

function TriangleBarChart()
    local self = {
        labels = {},
        data = {},
        colors = {"0x2c3e50"},

        increment = 1,
        maxValue = 0,
        minValue = 0,

        lineColor = "0x2c3e50",

        orientation = VERTICAL,
        width = 100,
        height = 100,
        textOffset = 20,
        textRotation = 0,

        event = PRESSED,

        noLines = false
    }

    local setLabels = function(labels)
        self.labels = labels
    end

    local setData = function(data)
        self.data = data
    end

    local setColors = function(colors)
        self.colors = colors
    end

    local setIncrement = function(increment)
        self.increment = increment
    end

    local setMaxValue = function(maxValue)
        self.maxValue = maxValue
    end

    local setMinValue = function(minValue)
        self.minValue = minValue
    end

    local setLineColor = function(lineColor)
        self.lineColor = lineColor
    end

    local setOrientation = function(orientation)
        self.orientation = orientation
    end

    local setWidth = function(width)
        self.width = width
    end

    local setHeight = function(height)
        self.height = height
    end

    local setTextOffset = function(textOffset)
        self.textOffset = textOffset
    end

    local setTextRotation = function(textRotation)
        self.textRotation = textRotation
    end

    local setEvent = function(event)
        self.event = event
    end

    local setNoLines = function(active)
        self.noLines = active
    end

    local drawVertical = function()

        local selection = {}
        local result = false

        stroke(self.lineColor)
        noFill()

        if (not self.noLines) then
            line(0, 0, 0, -self.height)
        end

        for i = self.minValue, self.maxValue, self.increment do
            currentPosY = map(i, self.minValue, self.maxValue, 0, -self.height)

            if i == 0 then
                line(0, currentPosY, self.width, currentPosY)

                categoryCount = #self.labels
                baseLength = self.width / categoryCount
                for j = 1, categoryCount do
                    currentPosX = map(j, 0, categoryCount + 1, 0, self.width)
                    dataLong = map(self.data[j], self.minValue, self.maxValue, 0, -self.height)

                    pushMatrix()
                    noStroke()
                    fill(self.colors[(j-1)%#self.colors+1])
                    result = triangle(
                        currentPosX - (baseLength / 2), currentPosY,
                        currentPosX + (baseLength / 2), currentPosY,
                        currentPosX, dataLong
                    )
                    if (result) then
                        noFill()
                        stroke(0)
                        strokeWeight(5)
                        triangle(
                            currentPosX - (baseLength / 2), currentPosY,
                            currentPosX + (baseLength / 2), currentPosY,
                            currentPosX, dataLong
                        )
                        strokeWeight(1)
                        selection[i] = {x = currentPosX, y = dataLong, data = self.data[j]}
                    end
                    popMatrix()

                    pushMatrix()
                    fill(self.lineColor)
                    translate(currentPosX, currentPosY + self.textOffset)
                    rotate(self.textRotation)
                    text(self.labels[j], 0, 0)
                    popMatrix()
                end
                DklLabel(selection)
            end

            stroke(self.lineColor)
            text(roundToFirstDecimal(i), -20, currentPosY)
            line(-7, currentPosY, 0, currentPosY)
        end
    end

    local drawHorizontal = function()

        local selection = {}
        local result = false

        stroke(self.lineColor)
        noFill()

        if (not self.noLines) then
            line(0, 0, self.width, 0)
        end

        for i = self.minValue, self.maxValue, self.increment do
            currentPosX = map(i, self.minValue, self.maxValue, 0, self.width)

            if i == 0 then
                line(currentPosX, 0, currentPosX, -self.height)

                categoryCount = #self.labels
                baseLength = self.height / categoryCount
                for j = 1, categoryCount do
                    currentPosY = map(j, 0, categoryCount + 1, 0, -self.height)
                    dataLong = map(self.data[j], self.minValue, self.maxValue, 0, self.width)

                    pushMatrix()
                    noStroke()
                    fill(self.colors[(j-1)%#self.colors+1])
                    result = triangle(
                        currentPosX, currentPosY - (baseLength / 2),
                        currentPosX, currentPosY + (baseLength / 2),
                        dataLong, currentPosY
                    )
                    if (result) then
                        noFill()
                        stroke(0)
                        strokeWeight(5)
                        triangle(
                            currentPosX, currentPosY - (baseLength / 2),
                            currentPosX, currentPosY + (baseLength / 2),
                            dataLong, currentPosY
                        )
                        strokeWeight(1)
                        selection[i] = {x = dataLong, y = currentPosY, data = self.data[j]}
                    end
                    popMatrix()

                    pushMatrix()
                    fill(self.lineColor)
                    translate(currentPosX - self.textOffset, currentPosY)
                    rotate(self.textRotation)
                    text(self.labels[j], 0, 0)
                    popMatrix()
                end

                DklLabel(selection)
            end

            stroke(self.lineColor)
            text(roundToFirstDecimal(i), currentPosX, 20)
            line(currentPosX, 7, currentPosX, 0)
        end
    end

    local draw = function()

        event(self.event)

        if (self.orientation == HORIZONTAL) then
            drawHorizontal()
        elseif (self.orientation == VERTICAL) then
            drawVertical()
        end
        
    end

    return {
        setLabels = setLabels,
        setData = setData,
        setColors = setColors,
        setIncrement = setIncrement,
        setMaxValue = setMaxValue,
        setMinValue = setMinValue,
        setLineColor = setLineColor,
        setOrientation = setOrientation,
        setWidth = setWidth,
        setHeight = setHeight,
        setTextOffset = setTextOffset,
        setTextRotation = setTextRotation,
        setEvent = setEvent,
        setNoLines = setNoLines,
        draw = draw
    }

end