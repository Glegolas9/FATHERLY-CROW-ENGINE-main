System = Class(require('src.engine.classes.system'))
return {
    ShapeRenderer = System:new(
        'shaperenderer',        -- [ID]
        {'shape', 'transform'}, -- [COMPONENTS]
        false,
        function(self, inst) -- [DRAW]
            local components= inst.components

            local shape     = components.shape
            local type      = shape.type
            local drawtype  = shape.drawtype
            local color     = shape.color

            local transform = components.transform

            local EndColor  = ColorThread(color[1], color[2], color[3], color[4])

            if type == 'rectangle' then
                rect(drawtype, transform.x, transform.y, transform.w, transform.h)
            end

            EndColor()

        end, 
        false
    )
}