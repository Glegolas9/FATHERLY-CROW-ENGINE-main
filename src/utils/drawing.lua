function ColorThread(r, g, b, a)
    local pr, pg, pb, pa = getColor()
    setColor(r, g, b, a)

    return function()
        setColor(pr, pg, pb, pa)
    end
end