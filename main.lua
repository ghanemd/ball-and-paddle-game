
push = require 'push'

Class = require 'class'

require 'Paddle'

require 'Ball'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200


function love.load()

    love.window.setTitle('Ball and Paddle game')

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    paddle = Paddle(VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT - 15, 20, 5)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

end


--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)

    paddle:update(dt)
    ball:update(dt)

end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    ball:draw()
    paddle:draw()

    -- end our drawing to push
    push:apply('end')
end