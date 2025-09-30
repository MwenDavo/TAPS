local M = {}

M.dependencies = { "tech_techCore" }

local TAPSs = {}

local function onSerialize()
    local data = {}
    data.tcomParams = tcomParams
    data.quitRequested = quitRequested
    data.cameras = cameras
    data.lidars = lidars
    data.ultrasonics = ultrasonics
    data.radars = radars
    data.advancedIMUs = advancedIMUs
    data.GPSs = GPSs
    data.powertrains = powertrains
    data.meshes = meshes
    data.idealRADARs = idealRADARs
    data.roadsSensors = roadsSensors
    data.vehicleFeeders = vehicleFeeders
    data.TAPSs = TAPSs

    if server ~= nil then
      local _, serverSocket = next(server)
      _, data.runningPort = serverSocket:getsockname()
    end

    data.showServerGUI = showServerGUI
    return data
end

local function onDeserialized(data)
    tcomParams = data.tcomParams
    quitRequested = data.quitRequested
    cameras = data.cameras
    lidars = data.lidars
    ultrasonics = data.ultrasonics
    radars = data.radars
    advancedIMUs = data.advancedIMUs
    GPSs = data.GPSs
    powertrains = data.powertrains
    meshes = data.meshes
    idealRADARs = data.idealRADARs
    roadsSensors = data.roadsSensors
    vehicleFeeders = data.vehicleFeeders
    TAPSs = data.TAPSs

    if data.runningPort ~= nil then
      M.openServer(data.runningPort)
    end
    showServerGUI = data.showServerGUI
end

local function handleOpenTAPS(request)
    if not ResearchVerifier.isTechLicenseVerified() then
        reportMissingLicenseFeature(request)
        return false
    end

    local args = {}
    args.GFXUpdateTime = request['GFXUpdateTime']
    args.physicsUpdateTime = request['physicsUpdateTime']
    args.isVisualised = request['isVisualised']

    local name = request['name']
    local vid = scenetree.findObject(request['vid']):getID();

    TAPSs[name] = extensions.tech_sensors.createTAPS(vid, args)
    log('I', logTag, 'Opened TAPS sensor')

    request:sendACK('OpenedTAPS')
end

local function handleGetTAPSId(request)
    local sensorId = TAPSs[request['name']]
    local resp = {type = 'getTAPSId', data = sensorId}
    request:sendResponse(resp)
end

local function handleCloseTAPS(request)
    local name = request['name']
    local vid = request['vid']
    local sensorId = TAPSs[name]
    if sensorId ~= nil then
      TAPSs[name] = nil                                    -- remove from ge lua
      extensions.tech_sensors.removeTAPS(vid, sensorId)    -- remove from vlua.
      log('I', logTag, 'Closed TAPS sensor')
    end

    request:sendACK('ClosedTAPS')
end

local function handlePollTAPSGE(request)
    local name = request['name']
    local sensorId = TAPSs[name]
    if sensorId ~= nil then
      local readings = extensions.tech_sensors.getTAPSReadings(sensorId)
      if readings ~= nil then
        local resp = { type = 'PollTAPSGE', data = readings }
        request:sendResponse(resp)
        return true
      end
    end

    -- The sensor was not found, or the readings did not exist, so send an empty response.
    local resp = {type = 'PollTAPSGE', data = {} }
    log('I', logTag, 'WARNING: TAPS sensor not found')
    request:sendResponse(resp)
end

local function handleSendAdHocRequestTAPS(request)
    local requestId = extensions.tech_sensors.sendTAPSRequest(TAPSs[request['name']], request['vid'])
    local resp = {type = 'requestId', data = requestId}
    request:sendResponse(resp)
end

local function handleIsAdHocPollRequestReadyTAPS(request)
    local isRequestComplete = extensions.tech_sensors.isVluaRequestComplete(request['requestId'])
    local resp = {type = 'isRequestComplete', data = isRequestComplete}
    request:sendResponse(resp)
end

local function handleCollectAdHocPollRequestTAPS(request)
    local reading = extensions.tech_sensors.collectTAPSRequest(request['requestId'])
    local resp = {type = 'AdHocPollRequestData', data = reading}
    request:sendResponse(resp)
end

local function handleSetTAPSRequestedUpdateTime(request)
    extensions.tech_sensors.setTAPSUpdateTime(TAPSs[request['name']], request['vid'], request['updateTime'])
    request:sendACK('CompletedSetTAPSRequestedUpdateTime')
end

local function handleSetTAPSIsVisualized(request)
    extensions.tech_sensors.setTAPSIsVisualised(TAPSs[request['name']], request['vid'], request['isVisualised'])
    request:sendACK('CompletedSetTAPSIsVisualised')
end

M.onSerialize                               = onSerialize
M.onDeserialized                            = onDeserialized
M.handleOpenTAPS                            = handleOpenTAPS
M.handleGetTAPSId                           = handleGetTAPSId
M.handleCloseTAPS                           = handleCloseTAPS
M.handlePollTAPSGE                          = handlePollTAPSGE
M.handleSendAdHocRequestTAPS                = handleSendAdHocRequestTAPS
M.handleIsAdHocPollRequestReadyTAPS         = handleIsAdHocPollRequestReadyTAPS
M.handleCollectAdHocPollRequestTAPS         = handleCollectAdHocPollRequestTAPS
M.handleSetTAPSRequestUpdateTime            = handleSetTAPSRequestedUpdateTime
M.handleSetTAPSIsVisualized                 = handleSetTAPSIsVisualized             

return M