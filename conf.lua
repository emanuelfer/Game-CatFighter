function love.conf( t )
    --local onde o jogo é salvo
    t.identity = nil
    t.version = "11.1"
    t.console = true
    t.accelerometerjoystick = true
    t.externalstorage = false
    t.gamacorrect = false

    t.window.title = "Zombel"
    t.window.icon = nil
    t.window.width = 928/1.2
    t.window.height = 793/1.2
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 928/1.2
    t.window.minheight = 793/1.2
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.iamge = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end