function sonsLoad(  )
    explosao = love.audio.newSource("sons/explosao.mp3", "static")
    pulo = love.audio.newSource("sons/pulo.mp3", "static")
    fogo = love.audio.newSource("sons/fogo.mp3", "static")
    ohno = love.audio.newSource("sons/ohno.wav", "static")
    gameOverSound = love.audio.newSource("sons/gameover.mp3", "static")
    backgroundSound = love.audio.newSource("sons/backgroundsound.mp3", "static")
    backgroundSound:setLooping(true)
end