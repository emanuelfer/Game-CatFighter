function checaColisao(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function colisao(dt)
    for i, robot in ipairs(robots) do
        if (catFighter.estaVivo) and checaColisao(robot.x +20, robot.y, 40, 100, catBody.body:getX()-30, catBody.body:getY(), 50, 50)then
            ohno:play()
            catFighter.estaVivo = false
            vidas = vidas - 1
            robot.atacou = true
            robot.verificado = true
            catFighter.wait = true
            break
        elseif not catFighter.estaVivo and robot.atacou then
            fogo:play()
            catDieAnimation:update(dt)
            fogoAnimation:update(dt)
            catFighter.waitTime = catFighter.waitTime + dt
            if catFighter.waitTime > 1 then
                fogo:stop()
                robot.atacou = false
                catFighter.wait = false
                catFighter.waitTime = 0
                if vidas < 0 then
                    backgroundSound:stop()
                    gameOverSound:play()
                    love.load()
                    gamerOver = true
                    pause = true
                else
                    catFighter.estaVivo = true
                end
            end
        end

    end
end