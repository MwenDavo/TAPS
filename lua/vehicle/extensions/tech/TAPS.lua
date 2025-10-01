local M = {}

local TAPSs = {}
local latestReadings = {}

local function updateTAPSGFXStep(dtSim, sensorId, isAdHocRequest, adHocRequestId)
    local controller = TAPSs[sensorId].controller
    local data = controller.getSensorData()

    local rawReadingsData = {sensorId = sensorId, reading = data.rawReadings}
    obj:queueGameEngineLua(string.format("tech_sensors.updateTAPSLastReadings(%q)", lpack.encode(rawReadingsData)))

    if not isAdHocRequest and data.timeSinceLastPoll < data.GFXUpdateTime then
        controller.incrementTimer(dtSim)
        return
    end
    
    if isAdHocRequest then
        local adHocData = {requestId = adHocRequestId, reading = data.rawReadings}
        obj:queueGameEngineLua(string.format("tech_sensors.updateTAPSAdHocRequest(%q)", lpack.encode(adHocData)))
    end

    controller.reset()
end

local function create(data) --Instantiates the sensor and connects it to the controller
    local decodedData = lpack.decode(data)
    local controllerData = {
        sensorId = decodedData.sensorId,
        GFXUpdateTime = decodedData.GFXUpdateTime,
        isVisualised = isVisualised,
        timeSinceLastPoll = decodedData.timeSinceLastPoll,
        physicsUpdateTime = decodedData.physicsUpdateTime
    }

    TAPSs[decodedData.sensorId] = {
        data = controllerData,
        controller = controller.loadControllerExternal('tech/TAPS', 'TAPS' .. decodedData.sensorId, controllerData)
    }
end

local function remove(sensorId) --Removes the sensor (usually when a vehicle is destroyed)
    controller.unloadControllerExternal('TAPS' .. sensorId)
    TAPSs[sensorId] = nil
end

local function setUpdateTime(sensorId, GFXUpdateTime)
    TAPSs[sensorId].GFXUpdateTime = GFXUpdateTime
end

local function setIsVisualised(data)
  local decodedData = lpack.decode(data)
  TAPSs[decodedData.sensorId].controller.setIsVisualised(decodedData.isVisualised)
end

local function adHocRequest(sensorId, requestId) --Handles immediate polling requests
    updateGPSGFXStep(0.0, sensorId, true, requestId)
end

local function cacheLatestReading(sensorId, reading) --Temporarily stores latest values per sensor ID.
    if sensorId ~= nil then
        latestReadings[sensorId] = reading
    end
end

local function getTAPSReading(sensorId) --Returns stored reading, called from GE Lua
    return latestReadings[sensorId]
end

local function getLatest(sensorId) --Returns the most recent single reading
    return TAPSs[sensorId].controller.getLatest()
end

local function updateGFX(dtSim) --Called every frame to push sensor data to GE Lua for collection
    for sensorId, _ in pairs(TAPSs) do
        updateTAPSGFXStep(dtSim, sensorId, false, nil)
    end
end

local function onVehicleDestroyed(vid) --Cleans up all sensors if the vehicle is removed from the world.
    for sensorId, _ in pairs(TAPSs) do
    if vid == objectId then
      remove(sensorId)
      TAPSs[sensorId] = nil
    end
  end
end

M.create                                                  = create
M.remove                                                  = remove
M.adHocRequest                                            = adHocRequest
M.cacheLatestReading                                      = cacheLatestReading
M.getTAPSReading                                          = getTAPSReading
M.getLatest                                               = getLatest
M.setUpdateTime                                           = setUpdateTime
M.setIsVisualised                                         = setIsVisualised
M.updateGFX                                               = updateGFX
M.onVehicleDestroyed                                      = onVehicleDestroyed

return M
