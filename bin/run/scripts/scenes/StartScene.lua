local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)

function StartScene:ctor()
    cc.ui.UIImage.new("interface_loading_03.png")
        :align(display.CENTER, WIN_WIDTH / 2, WIN_HEIGHT / 2)
        :addTo(self)

    cc.ui.UIImage.new("interface_loading.png")
        :align(display.CENTER, WIN_WIDTH / 2 - 10, 114)
        :addTo(self)
    cc.ui.UIImage.new("interface_loading_01.png")
        :align(display.CENTER, 744, 105)
        :addTo(self)
end

function StartScene:onEnter()
    display.replaceScene(require("scenes.MainScene").new(), "fade", 1.6, display.COLOR_WHITE)
end

return StartScene