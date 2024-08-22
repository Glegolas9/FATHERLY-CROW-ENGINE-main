local sys = {
    id       = 'unnamed',
    requires = requires
}

function sys:init(id, requires, load, draw, update)
    self.id       = id
    self.requires = requires
    self.draw     = draw
    self.update   = update
    self.load     = load
end

function sys:match(ent) 
    local needed = self.requires
    for i = 1, #needed do
        if not ent.components[needed[i]] then
            return false
        end
    end

    return true
end

function sys:draw(ent) end
function sys:update(ent, dt) end
function sys:load(ent) end

return sys