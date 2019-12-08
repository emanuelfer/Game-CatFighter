function catFighterLoad()
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
end

function catUpdate( dt )
    catFighter.x = catBody.body:getX() - 50
    catFighter.y = catBody.body:getY() - 45
end

function catFighterDraw()
    catFighter.animation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
end

function catFighterAttack(  )
    catAttackAnimation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
end

function catFighterDie(  )
    catDieAnimation:draw(catFighter.imagem, catFighter.x, catFighter.y,0,2.5,2.5)
end

function catFighterPower(  )
    for i, poder in ipairs(ataque) do
        catPowerAnimation:draw(catPowerImagem,poder.x,poder.y,0,2.5,2.5)
    end
end

function catMovimento(dt)
    if catFighter.estaVivo then
        if love.keyboard.isDown('right') then
            --impede catfighter de passar do meio da tela
            if catBody.body:getX() < larguraTela/2 - 25 then
                catBody.body:setX(catBody.body:getX() + planoDeFundo.vel*dt)
            end
            --movimento do background
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
            catFighter.animation:update(dt)
        end 
        if love.keyboard.isDown('left') and catFighter.x > 0 then
            catBody.body:setX(catBody.body:getX() - planoDeFundo.vel*dt)
            catFighter.animation:update(dt)
        end  
    end
end

function catAtaque(dt)
    catAttackAnimation:update(dt) 
    for i, poder in ipairs(ataque) do
        for j, robot in ipairs(robots) do
            if checaColisao(poder.x, poder.y, 64, 64, robot.x +20, robot.y, 40, 100) then
                if somAtivo then
                    explosao:stop()
                    explosao:play()
                end
                --posição do robô atingido para ocorrer a explosão
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
    --animação de ataque do catfighter
    if catFighter.atacando then
        catFighter.waitTime = catFighter.waitTime + dt
        if catFighter.waitTime > 0.5 then
            catFighter.wait = false
            catFighter.waitTime = 0
            catFighter.atacando = false
        end
    end
    --animação da explosão do robô
    if robotAtingido.wait then
        explosaoAnimation:update(dt)
        robotAtingido.waitTime = robotAtingido.waitTime + dt
        if robotAtingido.waitTime > 1 then
            robotAtingido.waitTime = 0
            robotAtingido.wait = false
        end
    end
end

function pular()
    if somAtivo then
        pulo:play()
    end
    catBody.body:applyForce(0,-60000)
end

function lancaPoder()
    if #power > 0 then
        catFighter.atacando = true
        power[1].x, power[1].y = catBody.body:getX(), catBody.body:getY()-20 
        table.insert( ataque,power[1] )
        table.remove( power,1 )
    end
end