
print("game")
require("config")
require("framework.init")

-- define global module
game = {}

function game.startup()
    display.replaceScene(require("scenes.StartScene").new())
end

function game.exit()
    os.exit()
end