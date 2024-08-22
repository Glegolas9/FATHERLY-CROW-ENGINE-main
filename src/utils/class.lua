local class = {

    modify = function(self, component_id, ...)
        self.components[component_id]:init(...)
    end,

    get  = function(self, component_id)
        return self.components[component_id]
    end,

    add  = function(self, component_id, component_value)
        self.components[component_id] = component_value
    end,

    remove = function(self, component_id)
        self.components[component_id] = nil
    end,

    init = function(self)

    end,

    new = function(self, ...)

        local instance = setmetatable({}, self)

        for i, v in pairs(self) do

            -- TODO: Optimize (also make it work for index.)
            if type(v) == 'table' then
                local new_table = {}
                for index, value in pairs(v) do
                    new_table[index] = value
                end

                if getmetatable(v) then
                    setmetatable(new_table, getmetatable(v))
                end

                instance[i] = new_table
            end

        end

        if instance.init then
            instance:init(...)
        end

        return instance
    end

}

class.__index = class

return setmetatable(class, {
    __call = function(self, data, components)
        local instance = setmetatable(data, self)
        data.__index = data
        data.components = components or {}

        return instance
    end
})