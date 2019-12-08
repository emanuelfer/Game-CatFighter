
function teleInicialLoad()
    startButton = love.graphics.newImage("imagens/StartButton.png")
    gameStartBackground = love.graphics.newImage("imagens/GameStartBackground.png")
    configButton = love.graphics.newImage("imagens/config.png")
end

function telaInicialDraw()
    love.graphics.draw(gameStartBackground, 0,0, 0, larguraTela/gameStartBackground:getWidth(),alturaTela/gameStartBackground:getHeight())
    love.graphics.draw(startButton, larguraTela/2 - startButton:getWidth()/2, alturaTela/2 - startButton:getHeight()/2)
    love.graphics.draw(configButton, larguraTela/2 - configButton:getWidth()/2, alturaTela/2 - configButton:getHeight()/2 + 200)
end