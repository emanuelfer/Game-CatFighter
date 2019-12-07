function backgroundLoad()
    fonte = love.graphics.newImageFont("imagens/Fonte.png", " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ".."0123456789.,!?-+/():;%&`´*#=[]")
    coracao = love.graphics.newImage("imagens/vidas.png")
    bg_image = love.graphics.newImage("imagens/Background.png")
    bg_image2 = love.graphics.newImage("imagens/Background.png")
    planoDeFundo = {
        x = 0,
        y = 0,
        x2 = larguraTela,
        vel = 200
    }
end

function backgroundDraw()
    love.graphics.draw(bg_image, planoDeFundo.x, planoDeFundo.y, 0,  larguraTela/bg_image:getWidth(), alturaTela/bg_image:getHeight())
    love.graphics.draw(bg_image2, planoDeFundo.x2, planoDeFundo.y, 0,  larguraTela/bg_image:getWidth(), alturaTela/bg_image:getHeight())
end

function backgroundUpdate(dt)
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
end

function pontuacaoDraw()
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