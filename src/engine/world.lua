-- [[ ELEMENTS ]]
Components = require 'src.engine.predef_components'
Objects    = require 'src.engine.predef_objects'
Systems    = require 'src.engine.predef_systems'

local world  = {
    systems   = {};
    instances = {};
}

world.__index = world

-- [[ SYSTEM MANAGEMENT ]]
function world:clearSystems()
    local systems = self.systems

    for i, system in pairs(systems) do
        t_remove(systems, i)
    end

    systems = nil
end

function world:registerSystem(...)
    local tuple = {...}
    local len   = #tuple

    for i = 1, len do
        local sys_index = tuple[i]
        local sys = Systems[sys_index]

        t_insert(self.systems, sys)
    end

    tuple = nil
end

function world:unregisterSystem(id)
    local systems = self.systems

    for i, system in pairs(systems) do
        if system.id == id then
            t_remove(systems, i)
        end
    end

    systems = nil
end

-- [[ INSTANCING ]]
function world:create(object, ...)

    if type(object) == 'string' then
        local object = Objects[object]
        if object then

            object = object:new(...)
            t_insert(self.instances, object)
        end
    else
        t_insert(self.instances, object)
    end

    return instance
end

function world:destroy_instance(inst)
    for i, system in pairs(systems) do
        if system.destroy and system:match(inst) then
            system:destroy(inst)
        end
    end
end

function world:clear_instances()
    local instances = self.instances
    for i = #instances, 1, -1 do
        local inst = instances[i]
        self:destroy_instance(inst)
        t_remove(instances, i)
    end
end

-- [[ RENDER ]]
function world:draw()
    local instances = self.instances
    local systems   = self.systems
    local len = #instances
    for i = 1, len do
        local inst = instances[i]
        
        for i, system in pairs(systems) do
            if system.draw then
                if system:match(inst) then
                    system:draw(inst)
                end
            end
        end
    end
end

function world:update(dt)
    local instances = self.instances
    local systems   = self.systems
    local len = #instances
    print(len)
    for i = len, 1, -1 do
        local inst = instances[i]
        if inst.delete then
            print('deleted')
            for i, system in pairs(systems) do
                if system.destroy and system:match(inst) then
                    system:destroy(inst)
                end
            end

            t_remove(instances, i)
        else
            for i, system in pairs(systems) do
                if system:match(inst) then
                    if system.load and not inst.loaded then
                        system:load(inst)
                    end

                    if system.update then
                        system:update(inst, dt)
                    end
                end
            end

            inst.loaded = true
        end
    end
end

function world.new(data)
    local data     = data or {}
    data.systems   = data.systems or {}
    data.instances = data.instances or {}

    return setmetatable(data, world)
end

return world