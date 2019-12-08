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
    velocidade = 200
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
    if pontos > 5 then
        delayRobot = 3
        velocidade = 250
    elseif pontos > 10 then
        delayRobot = 1
        velocidade = 350
    elseif pontos > 20 then
        delayRobot = 0.5
        velocidade = 450
    end
    tempoCriacaoRobot = tempoCriacaoRobot - dt

    if tempoCriacaoRobot < 0 then
        tempoCriacaoRobot = delayRobot
        x,y = chao.body:getPosition()
        novoRobot = {x = larguraTela, y = y-105-chao.height/2, imagem = robotImagem}
        table.insert(robots,novoRobot)
    end
end

function andaRobot(dt)
    for i, robot in ipairs(robots) do
        if love.keyboard.isDown("right") and catFighter.estaVivo then
            robot.x = robot.x - (velocidade+planoDeFundo.vel)*dt
        else
            robot.x = robot.x - (velocidade)*dt
        end
        robotAnimation:update(dt)
        if robot.x < 0 - robotImagem:getWidth() then
            table.remove(robots, i )
        end
    end
end

