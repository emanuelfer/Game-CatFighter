anim = require 'anim8'

larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

function love.load()
    stop = false

    --fisica
    love.physics.setMeter(64)
    mundo = love.physics.newWorld(0,9.81*64,true)
    gravidade = 400
    --fisica

    --background
    bg_image = love.graphics.newImage("imagens/Background.png")
    bg_image2 = love.graphics.newImage("imagens/Background.png")
    planoDeFundo = {
        x = 0,
        y = 0,
        x2 = larguraTela,
        vel = 200
    }
    --background

    --chao
    chao = {}
    chao.body = love.physics.newBody(mundo, 0, alturaTela, "static")
    chao.shape = love.physics.newRectangleShape(larguraTela,90)
    chao.fixture = love.physics.newFixture(chao.body, chao.shape)
    --chao


    --Cat Fighter
    --catBody
        catBody = {}
        catBody.body = love.physics.newBody(mundo, larguraTela/2 - 100,alturaTela/2-100, "dynamic")
        catBody.shape = love.physics.newRectangleShape(100,100)
        catBody.fixture = love.physics.newFixture(catBody.body,catBody.shape, 1)
        catBody.fixture:setRestitution(0.2)
    --catBody

    catFighterImagem = love.graphics.newImage("imagens/cat.png")
    catGrid = anim.newGrid(50,50, catFighterImagem:getWidth(), catFighterImagem:getHeight())
    catDieAnimation = anim.newAnimation(catGrid('7-3',4),0.1)
    catAnimation = anim.newAnimation(catGrid('4-8',1),0.05)
    catFighter = {
        posx = catBody.body:getX() - 50,
        posy = catBody.body:getY() - 50,
        imagem = catFighterImagem,
        animation = catAnimation,
        vely = 0,
        alturaPulo = 450,
        estaVivo = true
    }
    --Cat Fighter

    --robot
    delayRobot = 5
    tempoCriacaoRobot = delayRobot
    robots = {}

    robotImagem = love.graphics.newImage("imagens/robot.png")
    robotGrid = anim.newGrid(105,105, robotImagem:getWidth(), robotImagem:getHeight())
    robotAnimation = anim.newAnimation(robotGrid('1-9',5),0.25)
    --robot
end

function love.update(dt)
    mundo:update(dt)
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
    catMovimento(dt)
    catFighter.posx = catBody.body:getX() - 50
    catFighter.posy = catBody.body:getY() - 50
    criaRobot(dt)
    colisao(dt)
end

function love.draw()
    --chao
    love.graphics.polygon("fill", catBody.body:getWorldPoints(catBody.shape:getPoints()))

    --chao

    --catBody
    love.graphics.polygon("fill", chao.body:getWorldPoints(chao.shape:getPoints()))

    --catBody

    --background
    love.graphics.draw(bg_image, planoDeFundo.x, planoDeFundo.y, 0,  larguraTela/bg_image:getWidth(), alturaTela/bg_image:getHeight())
    love.graphics.draw(bg_image2, planoDeFundo.x2, planoDeFundo.y, 0,  larguraTela/bg_image:getWidth(), alturaTela/bg_image:getHeight())
    --background


    --Cat Animation
    if not stop then
        if catFighter.estaVivo then
            catFighter.animation:draw(catFighter.imagem, catFighter.posx, catFighter.posy,0,2,2)
        else
            catDieAnimation:draw(catFighter.imagem, catFighter.posx, catFighter.posy,0,2,2)
            stop =true
        end
    else

    end
    --Cat Animation

    --robot
    for i, robot in ipairs(robots)  do
        robotAnimation:draw(robotImagem, robot.x, robot.y)
    end
    --robot
end

function catMovimento(dt)
    if love.keyboard.isDown('right') then
        if catBody.body:getX() < larguraTela/2 - 50 then
            catBody.body:setX(catBody.body:getX() + planoDeFundo.vel*dt)
        end

        planoDeFundo.x = planoDeFundo.x - planoDeFundo.vel*dt
        planoDeFundo.x2 = planoDeFundo.x2 - planoDeFundo.vel*dt

        if planoDeFundo.x < -larguraTela then
            planoDeFundo.x = larguraTela
        end
        if planoDeFundo.x2 < -larguraTela then
            planoDeFundo.x2 = larguraTela
        end
        andaRobot(dt)
        catFighter.animation:update(dt)
    end 
    if love.keyboard.isDown('left') and catFighter.posx > 0 then
        catBody.body:setX(catBody.body:getX() - planoDeFundo.vel*dt)
        catFighter.animation:update(dt)
    end 
end

function love.keypressed(key)
    if key == 'space' and catBody.body:getY() > alturaTela-100 then
        catBody.body:applyForce(0,-60000)
    end
end

function criaRobot(dt)
    tempoCriacaoRobot = tempoCriacaoRobot - dt

    if tempoCriacaoRobot < 0 then
        tempoCriacaoRobot = delayRobot
        novoRobot = {x = larguraTela, y = alturaTela - 165, imagem = robotImagem}
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

function colisao(dt)
    for i, robot in ipairs(robots) do
        if catFighter.estaVivo and checaColisao(robot.x, robot.y, robotImagem:getWidth(), robotImagem:getHeight(), catBody.body:getX()- (catFighterImagem:getWidth()), catBody.body:getY(), catFighterImagem:getWidth(), catFighterImagem:getHeight())then
            catFighter.estaVivo = false
            catDieAnimation:update(dt)
            --catBody.body:setX(catBody.body:getX() - planoDeFundo.vel*dt)
            break
        end
    end
end
