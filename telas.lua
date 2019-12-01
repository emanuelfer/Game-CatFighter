gameStartBackground = love.graphics.newImage("imagens/GameStartBackground.png")
startButton = love.graphics.newImage("imagens/StartButton.png")

function inicio()
    love.graphics.draw(gameStartBackground, 0,0, 0, larguraTela/gameStartBackground:getWidth(),alturaTela/gameStartBackground:getHeight())
    love.graphics.draw(startButton, larguraTela/2 - startButton:getWidth()/2, alturaTela/2 - startButton:getHeight()/2)

end