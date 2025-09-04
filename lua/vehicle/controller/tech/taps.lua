local M = {}

local logTag = 'TAPS'

local sensorId
local GFXUpdateTime

local physicsTimer
local physicsUpdateTime

local readings = {}
local readingIndex = 1
local latestReading = {}

local function init(data) --Receives configuration from GE layer and initializes the sensor
    log('I', logTag, 'TAPS sensor initialized.')

    sensorId = data.sensorId
    GFXUpdateTime = data.GFXUpdateTime

    readings = {}
    readingIndex = 1
    physicsTimer = 0.0
    physicsUpdateTime = data.physicsUpdateTime

end

local function update(dtSim) --Called once per simulation step. Computes readings like position, time, and sensor-specific outputs
    if physicsTimer < physicsUpdateTime then
    physicsTimer = physicsTimer + dtSim
    return
  end
  physicsTimer = physicsTimer - physicsUpdateTime

  --TODO Implementar logica del sensor (obtener vehiculos cercanos, obtener data)
end

local function reset() --Clears current readings after they’ve been polled
  --TODO
end

local function getSensorData() --Returns the full list of readings for the current graphics-step
  --TODO
end

local function getLatest() --Returns the most recent reading (used for ad-hoc polling)
  --TODO
end

local function setIsVisualised(value) --Enables or disables visualization in the simulation
  --TODO
end

local function incrementTimer(dtSim) --Tracks time since last poll, used to control update frequency
  --TODO
end

M.init                                                  = init
M.update                                                = update
M.reset                                                 = reset
M.getSensorData                                         = getSensorData
M.getLatest                                             = getLatest
M.setIsVisualised                                       = setIsVisualised
M.incrementTimer                                        = incrementTimer

return M