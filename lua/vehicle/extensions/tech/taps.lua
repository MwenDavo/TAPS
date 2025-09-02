local M = {}

local TAPSs = {}
local latestReadings = {}



local function create()
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

local function updateGFX(dtSim)

end

local function remove(sensorId)
    controller.unloadControllerExternal('TAPS' .. sensorId)
    TAPSs[sensorId] = nil
end

local function adHocRequest()
end

local function cacheLatestReading()
end

local function getTAPSReading()
end

local function getLatest()
end

local function onVehicleDestroyed(vid)
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
