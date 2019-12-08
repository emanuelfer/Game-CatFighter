function telaConfigLoad()
    font8bit = love.graphics.newFont("imagens/8bitfont.TTF",60)
end


function telaConfigDraw()
    love.graphics.setFont(font8bit)
    love.graphics.draw(gameStartBackground, 0,0, 0, larguraTela/gameStartBackground:getWidth(),alturaTela/gameStartBackground:getHeight())
    love.graphics.print("Configs", larguraTela/2-205, 100)

    love.graphics.newFont(30)
    love.graphics.print("Music", larguraTela/2 - 480, alturaTela/2+10)


    if somAtivo then
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill",larguraTela/2-150,alturaTela/2,150,100)
        love.graphics.setColor(1,1,1)
        love.graphics.print("ON", larguraTela/2-150 + 20, alturaTela/2+ 15)
        love.graphics.rectangle("fill",larguraTela/2,alturaTela/2,210,100)
        love.graphics.setColor(0,0,0)
        love.graphics.print("OFF", larguraTela/2+20, alturaTela/2+ 15)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill",larguraTela/2-150,alturaTela/2,150,100)
        love.graphics.setColor(0,0,0)
        love.graphics.print("ON", larguraTela/2-150 + 20, alturaTela/2+ 15)
        love.graphics.rectangle("fill",larguraTela/2,alturaTela/2,210,100)
        love.graphics.setColor(1,1,1)
        love.graphics.print("OFF", larguraTela/2+20, alturaTela/2+ 15)
    end

    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line",larguraTela/2-150,alturaTela/2,150,100)
    love.graphics.rectangle("line",larguraTela/2,alturaTela/2,210,100)
    love.graphics.setColor(1,1,1)

    
    love.graphics.draw(backButton, larguraTela/2 - backButton:getWidth()/2, alturaTela/2+300)    
end