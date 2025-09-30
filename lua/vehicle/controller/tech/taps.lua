local M = {}

local logTag = 'TAPS'

local sensorId
local GFXUpdateTime
local timeSinceLastPoll = 0.0
local isVisualised = true

local physicsTimer
local physicsUpdateTime

local readings = {}
local readingIndex = 1
local latestReading = {}

local function update(dtSim) --Called once per simulation step. Computes readings like position, time, and sensor-specific outputs
  if physicsTimer < physicsUpdateTime then
    physicsTimer = physicsTimer + dtSim
    return
  end
  physicsTimer = physicsTimer - physicsUpdateTime

  --for i = 0, be:getObjectCount() - 1 do
  --  local vehicle = be:getObject(i)
  --  latestReadings[i] = vehicle
  --end
  --readings[readingIndex] = latestReading
  --readingIndex = readingIndex + 1

  extensions.tech_TAPS.cacheLatestReading(sensorId,"Test")
  --TODO Implementar logica del sensor (obtener vehiculos cercanos, obtener data)
end

local function init(data) --Receives configuration from GE layer and initializes the sensor
    log('I', logTag, 'TAPS sensor initialized.')

    sensorId = data.sensorId
    GFXUpdateTime = data.GFXUpdateTime
    timeSinceLastPoll = 0.0
    isVisualised = data.isVisualised

    readings = {}
    readingIndex = 1
    physicsTimer = 0.0
    physicsUpdateTime = data.physicsUpdateTime

end

local function reset() --Clears current readings after they’ve been polled
  readings = {}
  readingIndex = 1
  timeSinceLastPoll = timeSinceLastPoll % math.max(GFXUpdateTime, 1e-30)
end

local function getSensorData() --Returns the full list of readings for the current graphics-step
  return {
    isVisualised = isVisualised,
    GFXUpdateTime = GFXUpdateTime,
    timeSinceLastPoll = timeSinceLastPoll,
    rawReadings = readings
  }
end

local function getLatest() --Returns the most recent reading (used for ad-hoc polling)
  return latestReading
end

local function setIsVisualised(value) --Enables or disables visualization in the simulation
  isVisualised = value
end

local function incrementTimer(dtSim) --Tracks time since last poll, used to control update frequency
  timeSinceLastPoll = timeSinceLastPoll + dtSim
end

M.update                                                = update
M.init                                                  = init
M.reset                                                 = reset
M.getSensorData                                         = getSensorData
M.getLatest                                             = getLatest
M.setIsVisualised                                       = setIsVisualised
M.incrementTimer                                        = incrementTimer

return M