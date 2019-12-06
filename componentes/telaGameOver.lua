function telaGameOverLoad()
    gameOverBackground = love.graphics.newImage("imagens/GameOverBackground.png")
    restartButton = love.graphics.newImage("imagens/restart.png")
    backButton = love.graphics.newImage("imagens/back.png")
end

function telaGameOverDraw()
    love.graphics.draw(gameOverBackground, 0,0,0,larguraTela/gameOverBackground:getWidth(), alturaTela/gameOverBackground:getHeight())
    love.graphics.print("Pontos: ".. pontos, larguraTela/2 - 85, 50 ,0,1.8,1.8)
    love.graphics.draw(deadCat, larguraTela/2 - deadCat:getWidth()/2,alturaTela/2 - 400, 0, 1,1)
    love.graphics.draw(restartButton, larguraTela/2 - restartButton:getWidth()/2,alturaTela/2 +100)
    love.graphics.draw(backButton, larguraTela/2 - backButton:getWidth()/2, alturaTela/2+300)    
end