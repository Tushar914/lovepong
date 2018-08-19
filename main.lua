function love.load()
    math.randomseed(os.time())
    for i=10,3,1 do math.random() end
    win_height = love.graphics.getHeight()
    win_width = love.graphics.getWidth()
    paddle_width = 25
    paddle_height = 150
    l_x, l_y = win_height/2, 10
    r_x, r_y = win_height/2, win_width-paddle_width-10
    b_x, b_y, b_r = win_height/2, win_width/2, 10
    paddle_speed = 500
    ball_speed = 500
    direction_v = "down"
    direction_h = "right"
    score_l = 0
    score_r = 0
    font = love.graphics.newFont("BALLSONTHERAMPAGE.ttf", 100)
    isPaused = true
    start = true
    gameOver = false
    cpu = true
end

function love.draw()
    --love.graphics.setBackgroundColor(0, 0.5, 0)
    if not gameOver then
        --left paddle
        love.graphics.rectangle("fill", l_y, l_x, paddle_width, paddle_height)
        --right paddle
        love.graphics.rectangle("fill", r_y, r_x, paddle_width, paddle_height)
        --ball
        love.graphics.circle("fill", b_y, b_x, b_r)

        --partitionline
        for i=10,win_height,20 do
            love.graphics.line(win_width/2, i, win_width/2, i + 10)
        end

        love.graphics.setFont(font)
        love.graphics.print(score_l, win_width/2-100, 50)
        love.graphics.print(score_r, win_width/2+50, 50)

        --startscreen
        if start then
            love.graphics.print("PRESS SPACE TO START", win_width/4, 0, 0, 0.5, 0.5)
            love.graphics.print("Left Paddle\nW -> Move Up\nS -> Move Down", win_width/4, 200, 0, 0.3, 0.3)
            love.graphics.print("Right Paddle\nUp Arrow-> Move Up\nDown Arrow -> Move Down", win_width/2 + win_width/16, 200, 0, 0.3, 0.3)
            love.graphics.print("Esc -> Exit", win_width/2 - 80, win_height/4, 0, 0.3, 0.3)
        end

        --pausescreen
        if isPaused and not start then
            love.graphics.print("PRESS SPACE TO CONTINUE", win_width/4, 0, 0, 0.5, 0.5)
            love.graphics.print("Esc -> Restart", win_width/2 - 80, win_height/4, 0, 0.3, 0.3)
        end
    end
    --scoring
    if score_l == 10 then
        gameOver = true
        love.graphics.print("Left Player Wins", win_width/2 - 140, win_height/2, 0, 0.5, 0.5)
        love.graphics.print("Esc -> Restart", win_width/2 - 80, win_height/4, 0, 0.3, 0.3)
    elseif score_r == 10 then
        gameOver = true
        love.graphics.print("Right Player Wins", win_width/2 - 140, win_height/2, 0, 0.5, 0.5)
        love.graphics.print("Esc -> Restart", win_width/2 - 80, win_height/4, 0, 0.3, 0.3)
    end
end

function love.update(dt)
    if not isPaused and not gameOver then
        ---left paddle
        if not cpu then
            if love.keyboard.isDown("s") and (l_x+paddle_height) < win_height then
                l_x = l_x + paddle_speed * dt
            end
            if love.keyboard.isDown("w") and l_x > 0 then
                l_x = l_x - paddle_speed * dt
            end
        else
            if direction_v == "down" and (l_x+paddle_height) < win_height then
                l_x = l_x + paddle_speed * dt
            end
            if direction_v == "up" and l_x > 0 then
                l_x = l_x - (paddle_speed - math.floor((math.random() * 150) + 1)) * dt
            end
        end

        --right paddle
        if love.keyboard.isDown("down") and (r_x+paddle_height) < win_height then
            r_x = r_x + paddle_speed * dt
        end
        if love.keyboard.isDown("up") and r_x > 0 then
            r_x = r_x - paddle_speed * dt
        end

        --ball
        if (b_x + b_r) < win_height and direction_v == "down" then
            b_x = b_x + ball_speed * dt
        else
            direction_v = "up"
        end

        if (b_x - b_r) > 0 and direction_v == "up" then
            b_x = b_x - ball_speed * dt
        else
            direction_v = "down"
        end

        if direction_h == "right" then
            b_y = b_y + ball_speed * dt
        else
            direction_h = "left"
        end

        if b_y + b_r >= r_y and b_x > r_x and b_x < r_x + paddle_height then
            direction_h = "left"
        end

        if direction_h == "left" then
            b_y = b_y - ball_speed * dt
        else
            direction_h = "right"
        end

        if b_y - b_r <= l_y + paddle_width and b_x > l_x and b_x < l_x + paddle_height then
            direction_h = "right"
        end

        --score
        if b_y > win_width then
            score_l = score_l + 1
            reset_continue("right")
        elseif b_y < 0 then
            score_r = score_r + 1
            reset_continue("left")
        end
    end
end

function love.keyreleased(key)
    if key == "space" then
        isPaused = not isPaused
        start = false
    end

    if key == "escape" then
        if start then
            love.event.quit()
        else
            reset_start()
        end
        gameOver = false
    end
end

function reset_continue(dir)
    b_x = win_height/2
    b_y = win_width/2
    l_x, l_y = win_height/2, 10
    r_x, r_y = win_height/2 , win_width-paddle_width-10
    direction_h = dir
    isPaused = true
end

function reset_start()
    reset_continue("right")
    score_l = 0
    score_r = 0
    start = true
end