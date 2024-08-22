return {
    Player    = Class(require('src.engine.classes.player'), {
        ['transform'] = Components.Transform:new(0, 0, 20, 20),
        ['shape']     = Components.Shape:new('rectangle', 'fill', {1, 1, 1, 1})
    })
}


