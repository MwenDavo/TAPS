local M = {}

local function onSerialize()
    --TODO
end

local function onDeserialized()
    --TODO
end

local function handleOpenTAPS()
    --TODO
end

local function handleGetTAPSId()
    --TODO
end

local function handleCloseTAPS()
    --TODO
end

local function handlePollTAPSGE()
    --TODO
end

local function handleSendAdHocRequestTAPS() a
    --TODO
end

local function handleIsAdHocPollRequestReadyTAPS()
    --TODO
end

local function handleCollectAdHocPollRequestTAPS()
    --TODO
end

local function handleSetTAPSRequestUpdateTime()
    --TODO
end

local function handleSetTAPSIsVisualized()
    --TODO
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
M.handleSetTAPSRequestUpdateTime            = handleSetTAPSRequestUpdateTime
M.handleSetTAPSIsVisualized                 = handleSetTAPSIsVisualized             

return M