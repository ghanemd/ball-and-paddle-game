
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

    math.randomseed(os.time())

    paddle = Paddle(VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT - 15, 20, 5)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    lifes = 3

    gameState = 'start'

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

    if gameState == 'start' or gameState == 'serve' then

        ball.dx = math.random(-100, 100)
        ball.dy = math.random(-100, 100)

    end

    if gameState == 'play' then

        -- Check if the ball touches the edges
        if ball.x <= 0 then
            ball.x = 0
            ball.dx = -ball.dx
        end

        if ball.x + ball.width >= VIRTUAL_WIDTH then
            ball.x = VIRTUAL_WIDTH - ball.width
            ball.dx = -ball.dx
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end 

        if ball.y >= VIRTUAL_HEIGHT then 
            lifes = lifes - 1
            ball:reset()
            if lifes == 0 then
                gameState = 'lost'
            else
                gameState = 'serve'
            end
        end

        -- Check collisions with the paddle
        if ball:collides(paddle) then 
            ball.y = paddle.y - ball.height
            -- Increment the velocity by 4%
            ball.dy = -ball.dy * 1.04
            if ball.dx < 0 then 
                ball.dx = -math.random(50, 150)
            else 
                ball.dx = math.random(50, 150)
            end
        end
    
    end

    -- Move the paddle no matter what state we are in
    if love.keyboard.isDown('left') then
        paddle.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        paddle.dx = PADDLE_SPEED
    else
        paddle.dx = 0
    end

    paddle:update(dt)
    if gameState == 'play' then
        ball:update(dt)
    end

end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'return' or key == 'enter' then
        if gameState == 'start' or gameState == 'serve' then
            gameState = 'play'
        end
        if gameState == 'lost' then
            lifes = 3
            gameState = 'start'
            ball:reset()
        end
    end
end


function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    love.graphics.print('Lifes: ' .. tostring(lifes), 10, 10)

    if gameState == 'start' then
        love.graphics.printf('Press enter to begin the game!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    if gameState == 'serve' then
        love.graphics.printf('Press enter to serve the ball!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    if gameState == 'lost' then
        love.graphics.printf('You lost the game!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press enter to restart!', 0, 40, VIRTUAL_WIDTH, 'center')
    end

    ball:draw()
    paddle:draw()

    -- end our drawing to push
    push:apply('end')
end