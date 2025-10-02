local M = {}

M.dependencies = { "tech_sensors" }

TAPSLastRawReadings = {}

local function printTable(table)
    for k,v in pairs(table) do
        if type(v) == "table" then
            log('D','TAPS',k .." = Table printing below")
            printTable(v)
        else
            log('D','TAPS',k .." = ".. tostring(v))
        end
    end
end

local function createTAPS(vid, args) --Attaches sensor to a vehicle and sends creation data to VLua side
    -- Set optional parameters to defaults if they are not provided by the user.
  if args.pos == nil then args.pos = vec3(0, 0, 3) end
  if args.dir == nil then args.dir = vec3(0, -1, 0) end
  if args.up == nil then args.up = vec3(0, 0, 1) end
  args.up = -args.up  -- // we need to flip the up direction vector to get the orientation correct when attaching the sensor.
  if args.GFXUpdateTime == nil then args.GFXUpdateTime = 0.1 end
  if args.isVisualised == nil then args.isVisualised = false end
  if args.isSnappingDesired == nil then args.isSnappingDesired = false end
  if args.isForceInsideTriangle == nil then args.isForceInsideTriangle = false end
  if args.isAllowWheelNodes == nil then args.isAllowWheelNodes = false end
  if args.physicsUpdateTime == nil then args.physicsUpdateTime = 0.015 end
  if args.refLon == nil then args.refLon = 0.0 end
  if args.refLat == nil then args.refLat = 0.0 end

  GPSId = tech_sensors.createGPS(vid, args)
  RADARId = tech_sensors.createIdealRADARSensor(vid, args)

  -- Attach the sensor to the vehicle.
  local sensorId = Research.SensorManager.getNewSensorId()
  Research.SensorMatrixManager.attachSensor(sensorId, args.pos, args.dir, args.up, vid, false, args.isSnappingDesired,
    args.isForceInsideTriangle, args.isAllowWheelNodes, args.isDirWorldSpace)
  local attachData = Research.SensorMatrixManager.getAttachData(sensorId)

  local data =
  {
    sensorId = sensorId,
    vehicleId = vid,
    GFXUpdateTime = args.GFXUpdateTime,
    physicsUpdateTime = args.physicsUpdateTime,
    GPSId = GPSId,
    RADARId = RADARId,
    --nodeIndex1 = attachData['nodeIndex1'],
    --nodeIndex2 = attachData['nodeIndex2'],
    --nodeIndex3 = attachData['nodeIndex3'],
    --u = attachData['u'],
    --v = attachData['v'],
    --refLon = args.refLon,
    --refLat = args.refLat,
    --signedProjDist = attachData['signedProjDist'],
    isVisualised = args.isVisualised
  }
  local serialisedData = string.format("extensions.tech_TAPS.create(%q)", lpack.encode(data))
  
  be:queueObjectLua(vid, serialisedData)

  TAPSLastRawReadings[sensorId] = {}

  log('I','TAPS','VID = '..vid.." - TAPSId = "..sensorId.." - GPSId = "..GPSId.." - RADARId = "..RADARId)
  return sensorId
end

local function removeTAPS(vid, sensorId)
    local vehicleId = scenetree.findObject(vid):getID()
    be:queueObjectLua(vehicleId, "extensions.tech_TAPS.remove(" .. sensorId .. ")")
    TAPSLastRawReadings[sensorId] = nil
end

local function getTAPSReadings(sensorId) --Used by TechCore to retrieve readings
    local outData = {}
    for k, v in pairs(TAPSLastRawReadings[sensorId]) do
        outData[k] = v
    end
    TAPSLastRawReadings[sensorId] = {}

    nearby = outData[#outData].nearby
    position = outData[#outData].position
    log('D','TAPS-Nearby',"Nearby Values")
    printTable(nearby)
    log('D','TAPS-Position',"Position Values")
    printTable(position)

    return outData
end

local function updateTAPSLastReadings(data) --Called from VLua to push sensor data into global state
    local newReadings = lpack.decode(data)
    if TAPSLastRawReadings[newReadings.sensorId] == nil then
      return
    end
    local ctr = #TAPSLastRawReadings[newReadings.sensorId]
    for k, v in pairs(newReadings.reading) do
      TAPSLastRawReadings[newReadings.sensorId][ctr] = v
      ctr = ctr + 1
    end
end

local function updateTAPSAdHocRequest(data) --Handles ad-hoc request results if polling is on-demand.
    local d = lpack.decode(data)
    adHocVluaRequests[d.requestId] = d.reading
end

local function setTAPSUpdateTime(sensorId, vid, updateTime)
    local vehicleId = scenetree.findObject(vid):getID()
    be:queueObjectLua(vehicleId, "extensions.tech_TAPS.setUpdateTime(" .. sensorId .. ", " .. updateTime .. ")")
end

local function setTAPSIsVisualized(sensorId, vid, isVisualised)
    local data = { sensorId = sensorId, isVisualised = isVisualised }
    local serialisedData = string.format("extensions.tech_TAPS.setIsVisualised(%q)", lpack.encode(data))
    local vehicleId = scenetree.findObject(vid):getID()
    be:queueObjectLua(vehicleId, serialisedData)
end

local function sendTAPSRequest(sensorId, vid)
    local requestId = getUniqueRequestId()
    local vehicleId = scenetree.findObject(vid):getID()
    be:queueObjectLua(vehicleId, "extensions.tech_TAPS.adHocRequest(" .. sensorId .. ", " .. requestId .. ")")
    return requestId
end

local function collectTAPSRequest(requestId)
    if adHocVluaRequests[requestId] ~= nil then
        local data = adHocVluaRequests[requestId]
        adHocVluaRequests[requestId] = nil
        return data
    end
    return false
end

M.createTAPS                    = createTAPS
M.removeTAPS                    = removeTAPS
M.getTAPSReadings               = getTAPSReadings
M.updateTAPSLastReadings        = updateTAPSLastReadings
M.updateTAPSAdHocRequest        = updateTAPSAdHocRequest
M.setTAPSUpdateTime             = setTAPSUpdateTime
M.setTAPSIsVisualized           = setIsVisualised
M.sendTAPSRequest               = sendTAPSRequest
M.collectTAPSRequest            = collectTAPSRequest

return M