function fisicaLoad()
    love.physics.setMeter(64)
    mundo = love.physics.newWorld(0,9.81*64,true)

    --chao
    chao = {}
    chao.body = love.physics.newBody(mundo, 0, alturaTela, "static")
    chao.height = alturaTela*0.15
    chao.shape = love.physics.newRectangleShape(larguraTela*2,chao.height)
    chao.fixture = love.physics.newFixture(chao.body, chao.shape)
    --chao
end

function fisicaUpdate(dt)
    chao.body:setPosition(0, alturaTela)
    mundo:update(dt)
end

function fisicaDraw()
    love.graphics.polygon("fill", chao.body:getWorldPoints(chao.shape:getPoints()))
    love.graphics.polygon("fill", catBody.body:getWorldPoints(catBody.shape:getPoints()))
end