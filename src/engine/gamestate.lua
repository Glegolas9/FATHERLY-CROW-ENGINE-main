-- [[ CONFIGS ]]
local DEFAULT_LAYER_COUNT = 3

local gm = {
    enter  = function(self, ...)

    end,

    leave  = function(self, ...)
        --self.World:clear_instances()
    end,
    
    update = function(self, dt)
        self:UpdateLayersWithRange(1, #self.Layers)
        self.World:update(dt)
    end,

    draw   = function(self)
        local layers    = self.Layers
        local layer_len = #self.Layers
        self:DrawLayer(1)
            self.World:draw()
        if layer_len > 2 then
            self:DrawLayersWithRange(2, layer_len)
        else
            self:DrawLayer(2)
        end
    end
}
gm.__index = gm

-- [[ CATEGORY: CAMERA EDITING ]] 
--[[
    Used to reset camera status back to the original camera
    property it was set to on startup.
]]
function gm:FixateBackToCameraOrigin()
    local DEF = self.CameraDefaultPosition
    self.Camera:lookAt(DEF.x, DEF.y)
end

function gm:FixateBackToCameraZoom()
    local DEF = self.CameraDefaultPosition
    self.Camera:zoomTo(DEF.zoom)
end

function gm:FixateBackToCameraSmooth()
    local DEF = self.CameraDefaultPosition
    self.Camera.smooth = DEF.smooth
end

function gm:ChangeCameraOrigin(x, y, zoom, smooth)
    local DEF = self.CameraDefaultPosition
    DEF.x = x or DEF.x
    DEF.y = y or DEF.y
    DEF.zoom = zoom or DEF.zoom
    DEF.smooth = smooth or DEF.smooth
end

function gm:ResetCamera()
    local DEF = self.CameraDefaultPosition
    self.Camera:lookAt(DEF.x, DEF.y)
    self.Camera:zoomTo(DEF.zoom)
    self.Camera.smooth = DEF.smooth
end

--[[
    Used to create pre-defined points for camera to use in the future.
    Mostly used for cutscenes and locking camera in fixed regions.
]]
function gm:AddCameraPoint(tag, x, y, zoom, smooth)
    local x, y, zoom, smooth = x or self.Camera.x, y or self.Camera.y, zoom or self.Camera.scale, smooth or self.Camera.smooth
    local inst = {x = x, y = y, zoom = zoom, smooth = smooth}
    self.CameraPoints[tag] = inst
    return inst
end

function gm:LookAtCameraPoint(tag)
    local point = self.CameraPoints[tag]
    self.Camera:lookAt(point.x, point.y)
end

function gm:MoveToCameraPoint(tag, dx, dy)
    local cam   = self.Camera
    local point = self.CameraPoints[tag]
    local ox, oy = cam.x, cam.y
    
    dx = dx or 1
    dy = dy or 1
    cam:move((point.x - ox) * dx, (point.y - oy) * dy)
end

function gm:LookAtOriginPoint()
    local DEF = self.CameraDefaultPosition
    cam:lookAt(DEF.x, DEF.y)
end

function gm:MoveToOriginPoint(dx, dy)
    local DEF = self.CameraDefaultPosition
    local cam = self.Camera
    local cx, cy = cam.x, cam.y

    dx = dx or 1
    dy = dy or 1
    cam:move((DEF.x - cx) * d, (DEF.y - cy) * d)
end

function gm:RemoveCameraPoint(tag)
    self.CameraPoints[tag] = nil
end

function gm:FindCameraPoint(tag)
    return self.CameraPoints[tag]
end

-- [[CATEGORY: RENDER LAYERING]]
function gm:DrawLayer(layer)
    local layers = self.Layers
    local layer  = layers[layer]
    for item_num = 1, #layer do
        local object = layer[item_num]
        object:draw()
    end
end

function gm:UpdateLayer(layer, dt)
    local layers = self.Layers
    local layer  = layers[layer]
    for item_num = 1, #layer do
        local object = layer[item_num]
        object:update(dt)
    end
end

function gm:DrawLayersWithRange(startingLayer, endingLayer)
    local layers = self.Layers
    for i = startingLayer, endingLayer do
        local layer = layers[i]
        for item_num = 1, #layer do
            local object = layer[item_num]
            object:draw()
        end
    end
end

function gm:UpdateLayersWithRange(startingLayer, endingLayer, dt)
    local layers = self.Layers
    for i = startingLayer, endingLayer do
        local layer = layers[i]
        for item_num = 1, #layer do
            local object = layer[item_num]
            object:update(dt)
        end
    end
end

function gm:CreateLayer(LayerCount)
    for i = 1, LayerCount do
        t_insert(self.Layers, {})
    end
end

function gm:InsertObjectToLayer(layer, ...)
    local layers = self.Layers
    local real_layer = layers[layer]
    if real_layer then
        local items = {...}
        for i = #items, 1, -1 do
            local item = items[i]
            t_insert(layers, item)
        end
    end
end

function gm:RemoveLayer(...)
    local layers = self.Layers

    if #layers <= DEFAULT_LAYER_COUNT then
        print('Layers are already less than the default amount.')
        return;
    end

    local tuple  = {...}
    for i = 1, #tuple do
        local layer = layers[tuple[i]]
        if layer then
            t_remove(layers, tuple[i])
        end

        if #layers <= DEFAULT_LAYER_COUNT then
            print('Layers are already less than the default amount.')
            return;
        end
    end
end

-- [[ CONSTRUCTOR FUNCTION ]]
return function(data, wrld, cmra, cmra_points, lyrs)

    local data = data or {}
    local wrld = wrld or data.World  or WorldManager.new()
    local cmra = cmra or data.Camera or CameraManager()
    local cmra_points = cmra_points or data.CameraPoints or {}

    --[DEFAULTS TO THREE LAYERS]
    local lyrs = lyrs or data.Layers or {
        {};
        {};
        {};
    }

    local inst  = setmetatable(data, gm)
    inst.World                 = wrld
    inst.Camera                = cmra
    inst.CameraDefaultPosition = {x = cmra.x, y = cmra.y, zoom = cmra.scale, smooth = cmra.smooth}
    inst.CameraPoints          = cmra_points
    inst.Layers                = lyrs 

    return inst

end