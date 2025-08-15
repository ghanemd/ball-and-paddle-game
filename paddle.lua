
Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y 
    self.width = width
    self.height = height
    self.dx = 0
end

function Paddle:update(dt)
    -- ! We need to check if the paddle is not out of the screen
    self.x = math.min(VIRTUAL_WIDTH - self.width, math.max(self.x + dt * self.dx, 0))
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end