local M = {}

local logTag = 'TAPS'

local sensorId
local GFXUpdateTime

local physicsTimer
local physicsUpdateTime

local readings = {}
local readingIndex = 1
local latestReading = {}

local function init(data)
    log('I', logTag, 'TAPS sensor initialized.')

    sensorId = data.sensorId
    GFXUpdateTime = data.GFXUpdateTime

    readings = {}
    readingIndex = 1
    physicsTimer = 0.0
    physicsUpdateTime = data.physicsUpdateTime

end

local function update()
    if physicsTimer < physicsUpdateTime then
    physicsTimer = physicsTimer + dtSim
    return
  end
  physicsTimer = physicsTimer - physicsUpdateTime


end

local function reset()
end

local function getSensorData()
end

local function getLatest()
end

local function setIsVisualised()
end

local function incrementTimer()
end

M.init                                                  = init
M.update                                                = update
M.reset                                                 = reset
M.getSensorData                                         = getSensorData
M.getLatest                                             = getLatest
M.setIsVisualised                                       = setIsVisualised
M.incrementTimer                                        = incrementTimer

return M