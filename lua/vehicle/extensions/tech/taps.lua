local M = {}

local TAPSs = {}
local latestReadings = {}

local function create(data) --Instantiates the sensor and connects it to the controller
    local decodedData = lpack.decode(data)
    local controllerData = {
        sensorId = decodedData.sensorId,
        GFXUpdateTime = decodedData.GFXUpdateTime
        physicsUpdateTime = decodedData.physicsUpdateTime
    }

    TAPSs[decodedData.sensorId] = {
        data = controllerData,
        controller = controller.loadControllerExternal('tech/taps', 'TAPS' .. decodedData.sensorId, controllerData)
    }
end

local function updateGFX(dtSim) --Called every frame to push sensor data to GE Lua for collection
    --TODO
end

local function remove(sensorId) --Removes the sensor (usually when a vehicle is destroyed)
    controller.unloadControllerExternal('TAPS' .. sensorId)
    TAPSs[sensorId] = nil
end

local function adHocRequest(sensorId, requestId) --Handles immediate polling requests
    --TODO
end

local function cacheLatestReading(sensorId, reading) --Temporarily stores latest values per sensor ID.
    --TODO
end

local function getTAPSReading(sensorId) --Returns stored reading, called from GE Lua
    --TODO
end

local function getLatest(sensorId) --Returns the most recent single reading
    --TODO
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
M.updateGFX                                               = updateGFX
M.remove                                                  = remove
M.adHocRequest                                            = adHocRequest
M.cacheLatestReading                                      = cacheLatestReading
M.getTAPSReading                                          = getTAPSReading
M.getLatest                                               = getLatest
M.onVehicleDestroyed                                      = onVehicleDestroyed

return M
