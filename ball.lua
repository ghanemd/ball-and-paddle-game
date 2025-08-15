 
Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y 
    self.width = width
    self.height = height
    -- The ball can move in two directions
    self.dx = 0
    self.dy = 0
end

function Ball:collides(paddle)

    if self.y + self.height < paddle.y then 
        return false
    end
    if self.y > paddle.y + paddle.height then 
        return false
    end
    if self.x + self.width < paddle.x then 
        return false
    end
    if self.x > paddle.x + paddle.width then 
        return false
    end
    return true

end

function Ball:update(dt)
    self.x = self.x + dt * self.dx
    self.y = self.y + dt * self.dy
end

function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end