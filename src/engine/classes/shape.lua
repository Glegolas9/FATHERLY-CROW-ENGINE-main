return {
    init = function(self, type, drawtype, color)
        self.type     = type or 'rectangle'
        self.drawtype = drawtype or 'fill'
        self.color    = color or {
            0,
            0,
            0,
            1
        }
    end
}