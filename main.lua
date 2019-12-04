anim = require 'anim8'

larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

pontos = 0
telaInicial = true

function love.load()
    vidas = 3
    coracao = love.graphics.newImage("imagens/vidas.png")
    gamerOver = false
    pause = true

    --fonte
    fonte = love.graphics.newImageFont("imagens/Fonte.png", " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ".."0123456789.,!?-+/():;%&`´*#=[]")
    --fonte

    --fisica
    love.physics.setMeter(64)
    mundo = love.physics.newWorld(0,9.81*64,true)
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
    gameOverBackground = love.graphics.newImage("imagens/GameOverBackground.png")
    gameStartBackground = love.graphics.newImage("imagens/GameStartBackground.png")
    startButton = love.graphics.newImage("imagens/StartButton.png")
    restartButton = love.graphics.newImage("imagens/restart.png")
    configButton = love.graphics.newImage("imagens/config.png")
    backButton = love.graphics.newImage("imagens/back.png")
    --background

    --chao
    chao = {}
    chao.body = love.physics.newBody(mundo, 0, alturaTela, "static")
    chao.width = 150
    chao.shape = love.physics.newRectangleShape(larguraTela*2,chao.width)
    chao.fixture = love.physics.newFixture(chao.body, chao.shape)
    --chao

    --sons
    explosao = love.audio.newSource("sons/explosao.mp3", "static")
    pulo = love.audio.newSource("sons/pulo.mp3", "static")
    fogo = love.audio.newSource("sons/fogo.mp3", "static")
    --sons

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
    catAttackAnimation = anim.newAnimation(catGrid('1-6',2),0.05)
    catAnimation = anim.newAnimation(catGrid('4-8',1),0.05)
    catFighter = {
        x = catBody.body:getX() - 50,
        y = catBody.body:getY() - 45,
        imagem = catFighterImagem,
        animation = catAnimation,
        estaVivo = true,
        atacando = false,
        wait = false,
        waitTime = 0
    }
   
    deadCat = love.graphics.newImage("imagens/SadCat.png")

    --catPower
    power = {}
    ataque = {}
    catPowerImagem = love.graphics.newImage("imagens/CatPower.png")
    catPowerGrid = anim.newGrid(32,32,catPowerImagem:getWidth(),catPowerImagem:getHeight())
    catPowerAnimation = anim.newAnimation(catPowerGrid('1-4',1),0.1)

    explosaoImagem = love.graphics.newImage("imagens/Explosao.png")
    explosaoGrid = anim.newGrid(192,192, explosaoImagem:getWidth(), explosaoImagem:getHeight())
    explosaoAnimation = anim.newAnimation(explosaoGrid('1-5',2,'1-5',3,'1-5',4,'1-4',5),0.055)
    --catPower
    --Cat Fighter

    --robot
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
    --robot

    --fogo
    fogoImagem = love.graphics.newImage("imagens/RobotFire.png")
    fogoGrid = anim.newGrid(256, 300, fogoImagem:getWidth(), fogoImagem:getHeight())
    fogoAnimation = anim.newAnimation(fogoGrid('1-8',1,'1-8',2,'1-8',3,'1-8',4,'1-8',5,'1-8',6,'1-1',7),0.01)
    --fogo
end

function love.update(dt)
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
    if not pause then
        chao.body:setPosition(0, alturaTela)
        mundo:update(dt)
        catMovimento(dt)
        catFighter.x = catBody.body:getX() - 50
        catFighter.y = catBody.body:getY() - 45
        criaRobot(dt)
        colisao(dt)
        pontuacao(dt)
        catAtaque(dt)
    end
end

function love.draw()
    love.graphics.setFont(fonte)
    if not gamerOver and not telaInicial then

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
        if catFighter.estaVivo and not catFighter.atacando then
            catFighter.animation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
        elseif catFighter.estaVivo and catFighter.atacando then
            catAttackAnimation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
        else
            catDieAnimation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
        end
        for i, poder in ipairs(ataque) do
            catPowerAnimation:draw(catPowerImagem,poder.x,poder.y,0,2.5,2.5)
        end

        if robotAtingido.wait then
            explosaoAnimation:draw(explosaoImagem,robotAtingido.x, robotAtingido.y)
        end
        --Cat Animation

        --robot
        for i, robot in ipairs(robots)  do
            robotAnimation:draw(robotImagem, robot.x, robot.y)
            --fogo
            if not catFighter.estaVivo and robot.atacou then
                fogoAnimation:draw(fogoImagem, robot.x-70,robot.y-170)
            end
            --fogo
        end
        --robot

        --pontuacao
        love.graphics.print("Pontuacao:",30,30,0,1.5,1.5,0,2,0,0)
        love.graphics.print(pontos, 180,33,0,1.5,1.5,5,5,0,0)
        love.graphics.print("Poder:", 30, 60,0,1.5,1.5)
        love.graphics.setColor(0/255,191/255,255/255)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line",125,65,200,15)
        for i=1, #power do
            love.graphics.rectangle("fill",125,65,i*(200/3),15)
        end
        love.graphics.setColor(255,255,255)
        love.graphics.print("Vidas: ",larguraTela/2,35,0,1.5,1.5)
        for i=1, vidas do
            love.graphics.draw(coracao,  (larguraTela/2 + 50) + i*40, 30)
        end
        --pontuacao
    elseif not telaInicial then
        --tela de game over
        love.graphics.draw(gameOverBackground, 0,0,0,larguraTela/gameOverBackground:getWidth(), alturaTela/gameOverBackground:getHeight())
        love.graphics.print("Pontos: ".. pontos, larguraTela/2 - 85, 50 ,0,1.8,1.8)
        love.graphics.draw(deadCat, larguraTela/2 - deadCat:getWidth()/2,alturaTela/2 - 400, 0, 1,1)
        love.graphics.draw(restartButton, larguraTela/2 - restartButton:getWidth()/2,alturaTela/2 +100)
        love.graphics.draw(backButton, larguraTela/2 - backButton:getWidth()/2, alturaTela/2+300)
    else
        --tela inicial
        love.graphics.draw(gameStartBackground, 0,0, 0, larguraTela/gameStartBackground:getWidth(),alturaTela/gameStartBackground:getHeight())
        love.graphics.draw(startButton, larguraTela/2 - startButton:getWidth()/2, alturaTela/2 - startButton:getHeight()/2)
        love.graphics.draw(configButton, larguraTela/2 - configButton:getWidth()/2, alturaTela/2 - configButton:getHeight()/2 + 200)
    end
end

function catMovimento(dt)
    if catFighter.estaVivo then
        if love.keyboard.isDown('right') then
            if catBody.body:getX() < larguraTela/2 - 25 then
                catBody.body:setX(catBody.body:getX() + planoDeFundo.vel*dt)
            end
            planoDeFundo.x = planoDeFundo.x - planoDeFundo.vel*dt
            planoDeFundo.x2 = planoDeFundo.x2 - planoDeFundo.vel*dt

            if planoDeFundo.x < -larguraTela then
                planoDeFundo.x = larguraTela
                planoDeFundo.x2 = 0
            end
            if planoDeFundo.x2 < -larguraTela then
                planoDeFundo.x2 = larguraTela
                planoDeFundo.x = 0
            end
            andaRobot(dt)
            catFighter.animation:update(dt)
        end 
        if love.keyboard.isDown('left') and catFighter.x > 0 then
            catBody.body:setX(catBody.body:getX() - planoDeFundo.vel*dt)
            catFighter.animation:update(dt)
        end  
    end
end

function love.keypressed(key)
    if key == 'space' and catBody.body:getY() > alturaTela-150 and catFighter.estaVivo then
        pulo:play()
        catBody.body:applyForce(0,-60000)
    end
    if key == 'p' and not pause then
        pause = true
    elseif key == 'p' and pause then
        pause = false
    end
    if key == 'return' and gamerOver then
        gamerOver = false
        pause = false
        pontos = 0
    end
    if key == 'return' and telaInicial then
        telaInicial = false
        pause = false
    end
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'a' and not pause and catFighter.estaVivo then
        if #power > 0 then
            catFighter.atacando = true
            wait = true
            power[1].x, power[1].y = catBody.body:getX(), catBody.body:getY() - 10 
            table.insert( ataque,power[1] )
            table.remove( power,1 )
        end
    end
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

function colisao(dt)
    for i, robot in ipairs(robots) do
        if (catFighter.estaVivo) and checaColisao(robot.x +20, robot.y, 40, 100, catBody.body:getX()-30, catBody.body:getY(), 50, 50)then
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

function pontuacao(dt)
    for i, robot in ipairs(robots) do
        if catFighter.estaVivo and not robot.verificado and not robot.atacou and robot.x + 105/2  < catFighter.x then
            pontos = pontos + 1 
            if pontos%2 == 0 and #power < 3 then
                catPower = {
                    x = 0,
                    y = 0
                }
                table.insert( power,catPower )
            end
            robot.verificado = true
        end
    end
end

function love.mousepressed(mx,my,button)
    if telaInicial and button == 1 and mx >= (larguraTela/2-startButton:getWidth()/2) and mx < (larguraTela/2 + startButton:getWidth()/2) and my >= (alturaTela/2 - startButton:getHeight()/2) and my < (alturaTela/2 + startButton:getHeight()/2) then
        telaInicial = false
        pause = false
        gamerOver = false
        print("sim")
    end
    if telaInicial and button == 1 and mx >= (larguraTela/2-configButton:getWidth()/2) and mx < (larguraTela/2 + configButton:getWidth()/2) and my >= (alturaTela/2 - configButton:getHeight()/2+200) and my < (alturaTela/2 + configButton:getHeight()/2 + 200) then
        print("sim")
    end
    if gamerOver and button == 1 and mx >= (larguraTela/2-restartButton:getWidth()/2) and mx < (larguraTela/2 + restartButton:getWidth()/2) and my >= (alturaTela/2 - (restartButton:getHeight()/2+300)) and my < (alturaTela/2 + restartButton:getHeight()/2 + 300) then
        gamerOver = false
        pause = false
        pontos = 0
    end
    if gameOver and button == 1 and mx >= (larguraTela/2-backButton:getWidth()/2) and mx < (larguraTela/2 + backButton:getWidth()/2) and my >= (alturaTela/2 - (backButton:getHeight()/2+300)) and my < (alturaTela/2 + backButton:getHeight()/2 + 300) then
        telaInicial = true
        pause = true

    end
end

function catAtaque(dt)
    catAttackAnimation:update(dt) 
    for i, poder in ipairs(ataque) do
        for j, robot in ipairs(robots) do
            if checaColisao(poder.x, poder.y, 64, 64, robot.x +20, robot.y, 40, 100) then
                explosao:play()
                robotAtingido.x, robotAtingido.y = robot.x, robot.y - 20
                robotAtingido.wait = true
                table.remove( robots,j )
                table.remove( ataque, i )
                pontos = pontos + 1
            end
        end
        poder.x = poder.x + 300*dt
        catPowerAnimation:update(dt)
        if poder.x > larguraTela then
            table.remove( ataque,i )
        end
    end
    if catFighter.atacando then
        catFighter.waitTime = catFighter.waitTime + dt
        if catFighter.waitTime > 0.5 then
            catFighter.wait = false
            catFighter.waitTime = 0
            catFighter.atacando = false
        end
    end
    if robotAtingido.wait then
        explosaoAnimation:update(dt)
        robotAtingido.waitTime = robotAtingido.waitTime + dt
        if robotAtingido.waitTime > 1 then
            robotAtingido.waitTime = 0
            robotAtingido.wait = false
        end
    end

end