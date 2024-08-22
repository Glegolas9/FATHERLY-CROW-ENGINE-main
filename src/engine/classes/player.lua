return {
    init = function(self, x, y)
        self.components.transform.x = x or self.components.transform.x
        self.components.transform.y = y or self.components.transform.y
    end
}