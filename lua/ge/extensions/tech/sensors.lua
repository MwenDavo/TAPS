local M = {}

local function createTaps(vid, args) --Attaches sensor to a vehicle and sends creation data to VLua side
    --TODO
end

local function removeTaps()
    --TODO
end

local function getTAPSReadings(sensorId) --Used by TechCore to retrieve readings
    --TODO
end

local function updateTAPSLastReadings(data) --Called from VLua to push sensor data into global state
    --TODO
end

local function updateTAPSAdHocRequest(data) --Handles ad-hoc request results if polling is on-demand.
    --TODO
end

local function setTAPSUpdateTime()
    --TODO
end

local function setTAPSIsVisualized()
    --TODO
end

local function sendTAPSRequest()
    --TODO
end

local function collectTAPSRequest()
    --TODO
end

M.createTaps                    = createTaps
M.removeTaps                    = removeTaps
M.getTAPSReading                = getTAPSReading
M.updateTAPSLastReadings        = updateTAPSLastReadings
M.updateTAPSAdHocRequest        = updateTAPSAdHocRequest
M.setTAPSUpdateTime             = setTAPSUpdateTime
M.setTAPSIsVisualized           = setIsVisualised
M.sendTAPSRequest               = sendTAPSRequest
M.collectTAPSRequest            = collectTAPSRequest

return M