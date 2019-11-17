anim = require 'anim8'

larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

function love.load()

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

    --catBody
        catBody = {}
        catBody.body = love.physics.newBody(mundo, larguraTela/2 - 100,alturaTela/2-100, "dynamic")
        catBody.shape = love.physics.newRectangleShape(100,100)
        catBody.fixture = love.physics.newFixture(catBody.body,catBody.shape, 1)
        catBody.fixture:setRestitution(0.2)
    --catBody

    --Cat Fighter
    catFighterImagem = love.graphics.newImage("imagens/cat.png")
    catGrid = anim.newGrid(50,50, catFighterImagem:getWidth(), catFighterImagem:getHeight())
    catAnimation = anim.newAnimation(catGrid('4-8',1),0.05)
    catFighter = {
        posx = catBody.body:getX() - 50,
        posy = catBody.body:getY() - 50,
        imagem = catFighterImagem,
        animation = catAnimation,
        vely = 0,
        alturaPulo = 450
    }
    --Cat Fighter
end

function love.update(dt)
    mundo:update(dt)
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
    catMovimento(dt)
    catFighter.posx = catBody.body:getX() - 50
    catFighter.posy = catBody.body:getY() - 50
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
    catFighter.animation:draw(catFighter.imagem, catFighter.posx, catFighter.posy,0,2,2)
    --Cat Animation
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


