anim = require 'anim8'
require("componentes/telaInicial")
require("componentes/telaGameOver")
require("componentes/sons")
require("componentes/fisica")
require("componentes/background")
require("componentes/catFighter")
require("componentes/robot")
require("componentes/colisoes")


larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

pontos = 0
telaInicial = true

function love.load()
    vidas = 3
    gamerOver = false
    pause = true
    velocidade = 150

    fisicaLoad()
    backgroundLoad()
    telaGameOverLoad()
    teleInicialLoad()
    sonsLoad()
    catFighterLoad()
    robotLoad()

end

function love.update(dt)
    backgroundUpdate(dt)
    if not pause then
        fisicaUpdate(dt)
        catMovimento(dt)
        catUpdate(dt)
        criaRobot(dt)
        colisao(dt)
        pontuacao(dt)
        catAtaque(dt)
        andaRobot(dt)
    end
end

function love.draw()
    love.graphics.setFont(fonte)
    if not gamerOver and not telaInicial then

        fisicaDraw()

        backgroundDraw()

        if catFighter.estaVivo and not catFighter.atacando then
            catFighterDraw()
        elseif catFighter.estaVivo and catFighter.atacando then
            catFighterAttack()
        else
            catFighterDie()
        end
        catFighterPower()

        if robotAtingido.wait then
            robotExplosao()
        end

        robotDraw()

        pontuacaoDraw()

    elseif not telaInicial then
        telaGameOverDraw()
    else
        telaInicialDraw()
    end
end

function love.keypressed(key)
    if key == 'space' and catBody.body:getY() > alturaTela-chao.width and catFighter.estaVivo then
        pular()
    end
    if key == 'p' and not pause then
        pause = true
        backgroundSound:stop()
    elseif key == 'p' and pause then
        pause = false
        backgroundSound:play()
    end
    if key == 'return' and gamerOver then
        gamerOver = false
        pause = false
        pontos = 0
    end
    if key == 'return' and telaInicial then
        telaInicial = false
        pause = false
        backgroundSound:play()
    end
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'a' and not pause and catFighter.estaVivo then
        lancaPoder()
    end
end

function love.mousepressed(mx,my,button)
    if telaInicial and button == 1 and mx >= (larguraTela/2-startButton:getWidth()/2) and mx < (larguraTela/2 + startButton:getWidth()/2) and my >= (alturaTela/2 - startButton:getHeight()/2) and my < (alturaTela/2 + startButton:getHeight()/2) then
        pontos = 0
        telaInicial = false
        pause = false
        gamerOver = false

        backgroundSound:play()
    end
    if telaInicial and button == 1 and mx >= (larguraTela/2-configButton:getWidth()/2) and mx < (larguraTela/2 + configButton:getWidth()/2) and my >= (alturaTela/2 - configButton:getHeight()/2+200) and my < (alturaTela/2 + configButton:getHeight()/2 + 200) then
        print("sim")
    end
    if gamerOver and button == 1 and mx >= (larguraTela/2-restartButton:getWidth()/2) and mx < (larguraTela/2 + restartButton:getWidth()/2) and my >= (alturaTela/2 + 100) and my < (alturaTela/2 + restartButton:getHeight() + 100) then
        gamerOver = false
        pause = false
        pontos = 0
        backgroundSound:play()
    end
    if gamerOver and button == 1 and mx >= (larguraTela/2-backButton:getWidth()/2) and mx < (larguraTela/2 + backButton:getWidth()/2) and my >= (alturaTela/2 +300) and my < (alturaTela/2 + backButton:getHeight() + 300) then
        telaInicial = true
        pause = true
    end
end

