anim = require 'anim8'
require("componentes/telaInicial")
require("componentes/telaGameOver")
require("componentes/sons")
require("componentes/fisica")
require("componentes/background")
require("componentes/catFighter")
require("componentes/robot")
require("componentes/colisoes")
require("componentes/telaConfig")
require("componentes/mouse_keyboard")


larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

pontos = 0
telaInicial = true
telaGameOver = false
somAtivo = true

function love.load()
    telaConfig = false
    vidas = 3
    gamerOver = false
    pause = true
    velocidade = 150

    telaConfigLoad()
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
    if telaConfig then
        telaConfigDraw()
    elseif telaInicial then
        telaInicialDraw()
    elseif telaGameOver then
        telaGameOverDraw()
    else
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
    end
end

