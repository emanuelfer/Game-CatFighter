function love.keypressed(key)
    if key == 'space' and catBody.body:getY() > alturaTela-chao.height and catFighter.estaVivo then
        pular()
    end
    if key == 'p' and not pause then
        pause = true
        backgroundSound:stop()
    elseif key == 'p' and pause then
        pause = false
        if somAtivo then
            backgroundSound:play()
        end
    end
    if key == 'return' and gamerOver then
        gamerOver = false
        pause = false
        pontos = 0
    end
    if key == 'return' and telaInicial then
        telaInicial = false
        pause = false
        if somAtivo then
            backgroundSound:play()
        end
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
        if somAtivo then
            backgroundSound:play()
        end
    end
    if telaInicial and button == 1 and mx >= (larguraTela/2-configButton:getWidth()/2) and mx < (larguraTela/2 + configButton:getWidth()/2) and my >= (alturaTela/2 - configButton:getHeight()/2+200) and my < (alturaTela/2 + configButton:getHeight()/2 + 200) then
        telaConfig = true
        telaInicial = false
    end
    if telaGameOver and button == 1 and mx >= (larguraTela/2-restartButton:getWidth()/2) and mx < (larguraTela/2 + restartButton:getWidth()/2) and my >= (alturaTela/2 + 100) and my < (alturaTela/2 + restartButton:getHeight() + 100) then
        gamerOver = false
        telaGameOver = false
        pause = false
        pontos = 0
        if somAtivo then
            backgroundSound:play()
        end
    end
    if telaGameOver or telaConfig and button == 1 and mx >= (larguraTela/2-backButton:getWidth()/2) and mx < (larguraTela/2 + backButton:getWidth()/2) and my >= (alturaTela/2 +300) and my < (alturaTela/2 + backButton:getHeight() + 300) then
        telaInicial = true
        telaConfig = false
        pause = true
        if telaGameOver then
            telaGameOver = false
        end
    end
    if telaConfig and button == 1 and mx >= (larguraTela/2-150) and mx<larguraTela/2 and my >= alturaTela/2 and my < (alturaTela/2 + 100) then
        somAtivo = true
    end
    if telaConfig and button == 1 and mx >= (larguraTela/2) and mx< (larguraTela/2+210) and my >= alturaTela/2 and my < (alturaTela/2 + 100) then
        somAtivo = false
    end
end