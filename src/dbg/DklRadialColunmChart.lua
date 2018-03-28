--[[
    Created by Jason Latouche
    2018, march 10th
    Radial Column Chart for Diokol
]]

require "dbg/DklLabel"

local function roundToFirstDecimal(t)
    return math.floor(t)
end

function RadialColunmChart()
    local self = {
        labels = {},
        data = {},
        colors = {"0x2c3e50"},

        diameter = 0,
        increment = 1,
        maxValue = 0,
        minValue = 0,

        event = PRESSED,

        lineColor = "0x2c3e50",

        columnWidth = 5
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

    local setDiameter = function(diameter)
        self.diameter = diameter
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

    local setEvent = function(event)
        self.event = event
    end

    local setLineColor = function(lineColor)
        self.lineColor = lineColor
    end

    local setColumnWidth = function(columnWidth)
        self.columnWidth = columnWidth
    end

    local circScale = function (v, b, s, r)
        local result = {};
        result.x = r/2*-math.cos(((v-b)*(PI*2)/(s-b)))
        result.y = r/2*-math.sin(((v-b)*(PI*2)/(s-b)))
        return result
    end

    local draw = function()

        ellipseMode(CENTER)

        event(self.event)
        local selection = {}
        local result = false

        stroke(self.lineColor)
        noFill()
        for i = self.minValue, self.maxValue, self.increment do
            actualDiameter = map(i, self.minValue, self.maxValue, 0, self.diameter)
            ellipse(0, 0, actualDiameter, actualDiameter)
        end

        dataCount = #self.labels
        for i = 1, dataCount do
            pushMatrix()
            noStroke()
            rectMode(CENTER)
            fill(self.colors[(i-1)%#self.colors+1])
            large = map(self.data[i], self.minValue, self.maxValue, 0, self.diameter / 2)
            coordBar = circScale(i - 1, 0, dataCount, large)
            rotation = map(i - 1, 0, dataCount, 0, 2*PI)
            translate(coordBar.x, coordBar.y)
            rotate(rotation)
            result = rect(0, 0, large, self.columnWidth)
            if (result) then
                noFill()
                stroke(0)
                strokeWeight(5)
                rect(0, 0, large, self.columnWidth)
                strokeWeight(1)
                selection[i] = {x = coordBar.x, y = coordBar.y, data = self.data[i]}
            end
            popMatrix()

            pushMatrix()
            fill(self.lineColor)
            textAlign(CENTER)
            coord = circScale(i - 1, 0, dataCount, self.diameter * 1.1)
            text(self.labels[i], coord.x, coord.y)
            popMatrix()
        end

        fill(self.lineColor)
        startValue = self.minValue + self.increment
        for i = startValue, self.maxValue, self.increment do
            actualDiameter = map(i, self.minValue, self.maxValue, 0, self.diameter)
            text(roundToFirstDecimal(i), actualDiameter / 2 + 5, 20)
        end

        DklLabel(selection)

    end

    return {
        setLabels = setLabels,
        setData = setData,
        setColors = setColors,
        setDiameter = setDiameter,
        setIncrement = setIncrement,
        setMaxValue = setMaxValue,
        setMinValue = setMinValue,
        setEvent = setEvent,
        setLineColor = setLineColor,
        setColumnWidth = setColumnWidth,
        draw = draw
    }

end