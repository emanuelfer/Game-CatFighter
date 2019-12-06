function robotLoad(  )
    delayRobot = 5
    tempoCriacaoRobot = delayRobot
    robots = {}
    robotAtingido = {
        wait = false,
        waitTime = 0,
        x = 0,
        y = 0
    }

    robotImagem = love.graphics.newImage("imagens/robot.png")
    robotGrid = anim.newGrid(105,105, robotImagem:getWidth(), robotImagem:getHeight())
    robotAnimation = anim.newAnimation(robotGrid('1-9',5),0.25)

    fogoImagem = love.graphics.newImage("imagens/RobotFire.png")
    fogoGrid = anim.newGrid(256, 300, fogoImagem:getWidth(), fogoImagem:getHeight())
    fogoAnimation = anim.newAnimation(fogoGrid('1-8',1,'1-8',2,'1-8',3,'1-8',4,'1-8',5,'1-8',6,'1-1',7),0.01)
end

function robotDraw()
    for i, robot in ipairs(robots)  do
        robotAnimation:draw(robotImagem, robot.x, robot.y)
        --fogo
        if not catFighter.estaVivo and robot.atacou then
            fogoAnimation:draw(fogoImagem, robot.x-70,robot.y-170)
        end
        --fogo
    end
end

function robotExplosao()
    explosaoAnimation:draw(explosaoImagem,robotAtingido.x, robotAtingido.y)
end

function criaRobot(dt)
    tempoCriacaoRobot = tempoCriacaoRobot - dt

    if tempoCriacaoRobot < 0 then
        tempoCriacaoRobot = delayRobot
        x,y = chao.body:getPosition()
        novoRobot = {x = larguraTela, y = y-105-chao.width/2, imagem = robotImagem}
        table.insert(robots,novoRobot)
    end
    andaRobot(dt)
end

function andaRobot(dt)
    for i, robot in ipairs(robots) do
        robot.x = robot.x - 150*dt
        robotAnimation:update(dt)
        if robot.x < 0 - robotImagem:getWidth() then
            table.remove(robots, i )
        end
    end
end

function checaColisao(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end