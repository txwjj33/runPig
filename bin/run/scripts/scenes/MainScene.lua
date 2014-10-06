local scheduler = require("framework.scheduler")
if ANDOIRD then
    local scheduler = require("framework.luaj")
end
local audio = require("framework.audio")
local mapName = require("mapName")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

COLLISION_TYPE_ROLE_LINE = -1
COLLISION_TYPE_BOTTOM_LINE = 0   --ÏÂÃæµÄÏßÓÃÀ´ÅÐ¶¨Íæ¼ÒËÀÍö
COLLISION_TYPE_ROLE        = 1
COLLISION_TYPE_ROAD        = 2
COLLISION_TYPE_ROAD_TOP  = 3
COLLISION_TYPE_ROAD_LEFT = 4
COLLISION_TYPE_DIAMOND = 5
COLLISION_TYPE_STUCK1 = 10
COLLISION_TYPE_STUCK2 = 11
COLLISION_TYPE_STUCK3 = 12
COLLISION_TYPE_STUCK4 = 13

COLLISION_TYPE_ROAD_FIX        = 20
COLLISION_TYPE_REMOVE_SHAPE_LINE        = 21

ROLE_STATE_ROAD = 1                   --ÔÚÂ·ÉÏ
ROLE_STATE_JUMP = 2                   --ÌøÆð
--ROLE_STATE_JUMP_FALL = 3              --ÌøÔ¾µ½×î¸ßµãÂäÏÂ
ROLE_STATE_FALL = 4                   --×Ô¶¯ÂäÏÂ
--ROLE_STATE_COLLSION_TOP = 5           --×²µ½ÉÏÃæµÄ¸ñ×Ó

local roleState = ROLE_STATE_JUMP_FALL

local STRING_MAX_SCORE = "MAX_SCORE"
local STRING_MUSIC = "MUSIC"
local STRING_ZHEN_DONG = "ZHEN_DONG"
local STRING_DIAMOND_COUNT = "SSSSSSSSSSSSSS"

local rolePosX = 0
local sYunWidth = 0

local wudi = fasle       --µ±×Ô¶¯ÂäÏÂµÄÊ±ºòÊÇÎÞµÐµÄ

local roleSize = 0
local isGamePause = false
--local jumping = false

local font = "AGENTORANGE.ttf"

local levelNums = {0, 7, 7, 1}
local firstLoadMap = true

local score = 0
local maxScore = 0
local yunCount = 0
local caodiCount = 0
--×êÊ¯shape±í
local diamondTable = {}
local roadShapeTable = {}
local stuckShapeTable = {}

local diamondCount = 0

local newMapShapeInited = false

local roleHeight = 0

local rolePosX = 0

MAP_MOVE_SPEED = MAP_MOVE_SPEED_START
GRAVITY = 0
ROLE_JUMP_SPEED = 0
ROLE_FALL_SPEED = 0

TILE_WIDTH = 60

local wudiWhenResume = false
local resumeWudiTime = 0

local MAP_ITEMS = 
{
     road1 = COLLISION_TYPE_ROAD,
     road2 = COLLISION_TYPE_ROAD_TOP,
     diamond = COLLISION_TYPE_DIAMOND,
     stuck1 = COLLISION_TYPE_STUCK1,
     stuck2 = COLLISION_TYPE_STUCK2,
     stuck3 = COLLISION_TYPE_STUCK3,
     stuck4 = COLLISION_TYPE_STUCK4,
}

function MainScene:addCollisionToRoleScriptListener(collisionType)
    self:addCollisionScriptListener(COLLISION_TYPE_ROLE, collisionType)
end

function MainScene:addCollisionScriptListener(type1, type2)
    self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), type1, type2)
end

function MainScene:ctor()
    self.collisionRoadCount = 0
    self.shapes = {}

    self.mapBodys = {}

    self:calSpeed()

    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)

    self:initUI()
    self:addLabel()

    local startPos = 0
	self.m_pOldMapBody = self:addMapBody(0)
	self.m_pOldMap = self:addNewMap(startPos, self.m_pOldMapBody)

	for i = ROLE_POS_X, ROLE_POS_X + ROAD_SHAPE_NUM - 1 do 
		self:addShapesAtPos(i, self.m_pOldMapBody, self.m_pOldMap)
	end

	local oldMapWidth = self.m_pOldMap:getContentSize().width + startPos
	--print("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED)
	self.m_pNewMapBody = self:addMapBody(oldMapWidth)
	self.m_pNewMap = self:addNewMap(oldMapWidth, self.m_pNewMapBody)

    table.insert(self.mapBodys, 1, self.m_pOldMapBody) 
    table.insert(self.mapBodys, 2, self.m_pNewMapBody) 

	self:createRole()
	self:addBottomLineShape()
	self:addRoleLineShape(COLLISION_TYPE_ROLE_LINE, 1)   --Ìí¼Ó½ÇÉ«ËùÔÚÎ»ÖÃµÄÊúÏß£¬ÓÃÓÚ¼ì²âÌø¹ýµÄÕÏ°­Êý
	self:addRoleLineShape(COLLISION_TYPE_REMOVE_SHAPE_LINE, 3)   --Ìí¼Ó½ÇÉ«ËùÔÚÎ»ÖÃµÄÊúÏß£¬ÓÃÓÚ¼ì²âÌø¹ýµÄÕÏ°­Êý

    for k, v in pairs(MAP_ITEMS) do
        self:addCollisionToRoleScriptListener(v)
    end
    self:addCollisionToRoleScriptListener(COLLISION_TYPE_ROAD_LEFT)
    self:addCollisionToRoleScriptListener(COLLISION_TYPE_ROAD_FIX)

    -- add debug node
    if DEBUG_COLLSION then
        self.worldDebug = self.world:createDebugNode()
        self:addChild(self.worldDebug)
    end

    local baseLayer = display.newLayer()
	baseLayer:setTouchEnabled(true)
    self:addChild(baseLayer)
    baseLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        if not self.started then
            self.started = true
            self:startGame()
            self.world:start()
        else
            if (self.collisionRoadCount > 0) then
                self:roleJump()
            end
        end
    end)
    self.baseLayer = baseLayer

    self.startLayerNode = CCNode:create()
    self:addChild(self.startLayerNode)
    self:addButtons()
    cc.ui.UIImage.new("interface_dianjikaishi.png")
        :align(display.CENTER, CONFIG_SCREEN_WIDTH / 2, 494)
        :addTo(self.startLayerNode)

    self:playMusic("sounds/start.ogg")
end

function MainScene:startGame()
    if self.updateSchedule then scheduler.unscheduleGlobal(self.updateSchedule) end
    self.updateSchedule = scheduler.scheduleUpdateGlobal(function(dt)
        self:update(dt)
    end)

    if self.updateSpeedSchedule then scheduler.unscheduleGlobal(self.updateSpeedSchedule) end
    self.updateSpeedSchedule = scheduler.scheduleGlobal(function(dt)
        --print("add speed")
        self:calSpeed()
        for _, body in ipairs(self.mapBodys) do 
            body:setVelocity(-MAP_MOVE_SPEED, 0)           
            body:setForce(0, -GRAVITY)           
        end
        if roleState == ROLE_STATE_ROAD then
            self.roleBody:setForce(0, -GRAVITY) 
        end
        self.world:setGravity(0, GRAVITY)
    end, SPEED_CHANGE_TIME)

    self.startLayerNode:setVisible(false)
    self.pigAnimation:setAnimation(0, "run", true)

    self.callJavaFunc("com/xwtan/run/Run", "closeInterstitial")
end

function MainScene:roleJump()
    --jumping = true
    roleState = ROLE_STATE_JUMP
    self:playSound("sounds/jump.ogg")

    self.roleBody:setVelocity(ccp(0, ROLE_JUMP_SPEED))
    self.roleBody:setForce(ccp(0, 0))
    self.pigAnimation:setAnimation(0, "jump", true)
    --print("jump speed: " .. ROLE_JUMP_SPEED)
end

function MainScene:initUI()
    cc.ui.UIImage.new("interface_background.png")
        :align(display.LEFT_BOTTOM)
        :addTo(self)
    self:addYun()
    self:addSun()
    self:addCaodi()
end

function MainScene:addCaodi()
    self.caodiBody = self:addMapBody(0)
    table.insert(self.mapBodys, self.caodiBody) 
    self.caodiNode = display.newNode()
    self:addChild(self.caodiNode)
    self.caodiBody:bind(self.caodiNode)

    self.caodiTable = {}
    --self.caodiBatchNode = CCSpriteBatchNode:create("interface_caodi.png", 50)
    --    :addTo(self.caodiNode)

    local caodi = cc.ui.UIImage.new("interface_caodi.png")
        :align(display.LEFT_BOTTOM, 0, 0)
        :addTo(self.caodiNode)

    table.insert(self.caodiTable, caodi)

    local caodi2 = cc.ui.UIImage.new("interface_caodi.png")
        :align(display.LEFT_BOTTOM, WIN_WIDTH, 0)
        :addTo(self.caodiNode)

    table.insert(self.caodiTable, caodi2)
end

function MainScene:addYun()
    self.yunBody = self:addMapBody(0)
    table.insert(self.mapBodys, self.yunBody) 
    self.yunNode = display.newNode()
    self:addChild(self.yunNode)
    self.yunBody:bind(self.yunNode)

    self.yunsTable = {}
    self.yunBatchNode = CCSpriteBatchNode:create("interface_yun_02.png", 100)
        :addTo(self.yunNode)
    sYunWidth = self.yunBatchNode:getTexture():getContentSize().width - 3
    local yunCount = math.floor(CONFIG_SCREEN_WIDTH / sYunWidth) + 2
    local posX = 0

    for k = 1, yunCount do
        self:addAYun(posX)
        posX = posX + sYunWidth
    end
end

function MainScene:addAYun(posX)
    local yun = cc.ui.UIImage.new(self.yunBatchNode:getTexture())
        :align(display.LEFT_BOTTOM, posX, 39)
        :addTo(self.yunNode)

    local randPosX = math.random(8, sYunWidth - 8)
    local randPosY = math.random(-8, 7)
    cc.ui.UIImage.new("interface_hua.png")
        :align(display.LEFT_BOTTOM, randPosX, randPosY)
        :addTo(yun)

    table.insert(self.yunsTable, yun)
end

function MainScene:addSun()
end

function MainScene:addLabel()
    local height = 685
    local heightDiamond = 625
    local fontSize = 40

    self.scoreLabel = CCLabelTTF:create("0", font, fontSize)
    self.scoreLabel:setColor(ccc3(255,254,219))
    self.scoreLabel:setPosition(CONFIG_SCREEN_WIDTH / 2, height)
    self:addChild(self.scoreLabel)

    maxScore = CCUserDefault:sharedUserDefault():getIntegerForKey(STRING_MAX_SCORE, 0)
    self.maxScoreLabel = CCLabelTTF:create(maxScore, font, fontSize)
    self.maxScoreLabel:setColor(ccc3(255,232,111))
    self.maxScoreLabel:setPosition(1177, height)
    self.maxScoreLabel:setAnchorPoint(ccp(0, 0.5))
    self:addChild(self.maxScoreLabel)

    local bestLabel = CCLabelTTF:create("最高分", font, fontSize)
    bestLabel:setColor(ccc3(255,232,111))
    bestLabel:setPosition(1049, height)
    bestLabel:setAnchorPoint(ccp(0, 0.5))
    self:addChild(bestLabel)

    local diamondLabel = CCLabelTTF:create("钻石", font, fontSize)
    diamondLabel:setColor(ccc3(255,232,111))
    diamondLabel:setPosition(1049, heightDiamond)
    diamondLabel:setAnchorPoint(ccp(0, 0.5))
    self:addChild(diamondLabel)

    diamondCount = CCUserDefault:sharedUserDefault():getIntegerForKey(STRING_DIAMOND_COUNT, 0)
    self.diamondCountLabel = CCLabelTTF:create(diamondCount, font, fontSize)
    self.diamondCountLabel:setColor(ccc3(255,232,111))
    self.diamondCountLabel:setPosition(1177, heightDiamond)
    self.diamondCountLabel:setAnchorPoint(ccp(0, 0.5))
    self:addChild(self.diamondCountLabel)
end

function MainScene:addButtons()
    local height = 645
    local showSetting = false

    local function updateCheckBoxButton(checkbox, confStr)
        if checkbox:isButtonSelected() then
            CCUserDefault:sharedUserDefault():setBoolForKey(confStr, true)
            if confStr == STRING_MUSIC then
                self:playMusic("sounds/start.ogg")
            else
                if ANDOIRD then
                    luaj.callStaticMethod("com/xwtan/run/Run", "vibrate")
                end
            end
        else
            CCUserDefault:sharedUserDefault():setBoolForKey(confStr, false)
            if confStr == STRING_MUSIC then
                audio.stopMusic()
            end
        end
        self:playSound("sounds/button.ogg")
    end

    musicImg = {on = "button_yinxiao.png", off = "button_off.png"}
    zhendongImg = {on = "button_zhengdong.png", off = "button_off.png"}

    cc.ui.UIImage.new(musicImg.on)
        :align(display.CENTER, 75, height)
        :addTo(self.startLayerNode)
    checkBoxMusic = cc.ui.UICheckBoxButton.new(musicImg)
        :onButtonStateChanged(function(event)
            updateCheckBoxButton(event.target, STRING_MUSIC)
        end)
        :align(display.CENTER, 75, height)
        :addTo(self.startLayerNode)
        :setButtonSelected(CCUserDefault:sharedUserDefault():getBoolForKey(STRING_MUSIC, true))

    cc.ui.UIImage.new(zhendongImg.on)
        :align(display.CENTER, 200, height)
        :addTo(self.startLayerNode)
    zhendongMusic = cc.ui.UICheckBoxButton.new(zhendongImg)
        :onButtonStateChanged(function(event)
            updateCheckBoxButton(event.target, STRING_ZHEN_DONG)
        end)
        :align(display.CENTER, 200, height)
        :addTo(self.startLayerNode)
        :setButtonSelected(CCUserDefault:sharedUserDefault():getBoolForKey(STRING_ZHEN_DONG, true))
end

function MainScene:addAButton(img, clickCallback, pos, anchor, parent)
    local pAnchor = anchor or display.CENTER
    local pParent = parent or self
    local btn = cc.ui.UIPushButton.new(img)
        :onButtonPressed(function(event)
            event.target:setScale(1.2)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(clickCallback)
        :align(pAnchor, pos.x, pos.y)
        :addTo(pParent)
    return btn
end

function MainScene:addGamePauseButtons()
    self.gamePauseNode = CCNode:create()
    self:addChild(self.gamePauseNode)

    local fontSize = 50

    cc.ui.UIImage.new("interface_youxijieshu.png")
        :align(display.CENTER, WIN_WIDTH / 2, 607)
        :addTo(self.gamePauseNode)

    local bg = CCScale9Sprite:create("interface_diguang.png", CCRect(0, 0, 66, 51), CCRect(30, 25, 2, 2))
    bg:setContentSize(CCSize(410, 300))
    bg:setPosition(WIN_WIDTH / 2, 400)
    self.gamePauseNode:addChild(bg)

    cc.ui.UIImage.new("interface_fengshu.png")
        :align(display.CENTER, WIN_WIDTH / 2, 500)
        :addTo(self.gamePauseNode)

    local scoreLabel = CCLabelTTF:create(tostring(score), font, fontSize)
    scoreLabel:setColor(ccc3(255,254,219))
    scoreLabel:setPosition(WIN_WIDTH / 2, 435)
    self.gamePauseNode:addChild(scoreLabel)

    cc.ui.UIImage.new("interface_zuigaofeng.png")
        :align(display.CENTER, WIN_WIDTH / 2, 366)
        :addTo(self.gamePauseNode)

    local maxScoreLabel = CCLabelTTF:create(tostring(maxScore), font, fontSize)
    maxScoreLabel:setColor(ccc3(255,254,219))
    maxScoreLabel:setPosition(WIN_WIDTH / 2, 300)
    self.gamePauseNode:addChild(maxScoreLabel)

    local function clickTryAgain()
        self:gameOver()
        self:playSound("sounds/button.ogg")
        package.loaded["scenes.MainScene"] = nil
        display.replaceScene(require("scenes.MainScene").new())
    end
    self:addAButton("button_zailaiyici.png", clickTryAgain, ccp(WIN_WIDTH / 2 - 33, 160), 
            display.CENTER_RIGHT, self.gamePauseNode)

    local function clickShare()
        self:playSound("sounds/button.ogg")
        LuaExport:showShareMenu("content", "http://img0.bdstatic.com/img/image/shouye/systsy-11927417755.jpg", "title", "des", "url")
    end
    self:addAButton("button_fenxiang.png", clickShare, ccp(WIN_WIDTH / 2 + 33, 160), 
            display.CENTER_LEFT, self.gamePauseNode)

    if diamondCount >= DIAMOND_RESUME_GAME_NEEDED then
        local function clickResume()
            diamondCount = diamondCount - DIAMOND_RESUME_GAME_NEEDED
            CCUserDefault:sharedUserDefault():setIntegerForKey(STRING_DIAMOND_COUNT, diamondCount)
            self.gamePauseNode:removeFromParent()
            self:gameResume()
            self.world:start()
        end
        local resumeBtn = self:addAButton("button_zailaiyici.png", clickResume, ccp(WIN_WIDTH / 2 - 33, 60), 
                display.CENTER_RIGHT, self.gamePauseNode)
    end
end

local function getNums(path)
    local nums = {}
    local pos1 = string.find(path, '/') 
    local pos = string.find(path, '_') 
    while pos do
        local num = string.sub(path, pos1 + 1, pos -1)
        table.insert(nums, tonumber(num))
        pos1 = pos
        pos = string.find(path, '_', pos +1)
    end 
    pos = string.find(path, ".tmx", pos1 +1)
    if not pos then print(path) end
    local num = string.sub(path, pos1 + 1, pos - 1)
    table.insert(nums, tonumber(num))
    return nums
end

MAP_INDEX = 1
function MainScene:addNewMap(posX, body)
    mapPath = ""

    if MAP_TEST then
        mapPath = MAP_TEST_FILE
    elseif MAPS_TEST then
        mapPath = MAP_TEST_FILES[MAP_INDEX]
        MAP_INDEX = MAP_INDEX + 1
        if MAP_INDEX > #MAP_TEST_FILES then
            MAP_INDEX = 1
        end 
    else
        if firstLoadMap then
            mapPath = mapName[1]
            firstLoadMap = false
        else
            local nextLevel = {}
            nextLevel[1] = math.min(levelNums[1] + 1, LEVEL_MAX)
            nextLevel[2] = levelNums[3]
            local mapNameFirstPart = string.format("levels/%d_%d", nextLevel[1], nextLevel[2])
            local min, max
            for k, name in ipairs(mapName) do
                if string.find(name, mapNameFirstPart) then
                    if not min then
                        min = k
                    end
                else
                    if min then
                        max = k - 1
                        break
                    end
                end
            end

            local mapID = math.random(min, max)
            mapPath = mapName[mapID]
            levelNums = getNums(mapPath)
        end
    end

    print("create new map: " .. mapPath)
    local map = CCTMXTiledMap:create(mapPath)
	map:setPosition(posX, 0)
    self:addChild(map)
    body:bind(map)

	return map
end

function MainScene:addShapesAtPos(x, body, map)
    --Ìí¼Óroad¶ÔÓ¦µÄÐÎ×´
    --heightÏß¶ÎµÄºñ¶È
    local function addRoadShape(collisionType, pos1, pos2, height)
        local height_1 = height or 1
        local shape = body:addSegmentShape(pos1, pos2, height_1)
        shape:setCollisionType(collisionType)
        return shape
    end

    local mapSize = map:getMapSize()

    if x >= mapSize.width then return end

    local function addMapInTile()
    end

    local hasTile = false

    local function addShapeInLayer(layer, v)
        for y = 0, mapSize.height - 1 do
	        local tile = layer:tileAt(ccp(x, y))
	        if tile then
                hasTile = true

                local tileSize = tile:getContentSize()
		        local pos = ccpAdd(ccp(tile:getPosition()), ccp(tileSize.width / 2, tileSize.height / 2))

                --¼ì²éÊÇ²»ÊÇ×î×ó±ßµÄroad
                local function checkLeftRoad()
                    if (x == 0) or ( not layer:tileAt(ccp(x - 1, y)) ) then
                        addRoadShape(COLLISION_TYPE_ROAD_LEFT,
					        ccp(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2 + 5), 
					        ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2 - 5))
                    end
                end

                if v == COLLISION_TYPE_ROAD_TOP then
                    addRoadShape(COLLISION_TYPE_ROAD_TOP,
						        ccp(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2), 
						        ccp(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))

                    local shape = addRoadShape(COLLISION_TYPE_ROAD,
					        ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
					        ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2), 5)

                    checkLeftRoad()
                    roadShapeTable[shape] = {}
                    roadShapeTable[shape].posY = pos.y + tileSize.height / 2
                    roadShapeTable[shape].tilePosX = x
                    roadShapeTable[shape].isTop = true
                elseif v == COLLISION_TYPE_ROAD then
                    local shape = addRoadShape(COLLISION_TYPE_ROAD,
					        ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
					        ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2), 5)

                    checkLeftRoad()
                    roadShapeTable[shape] = {}
                    roadShapeTable[shape].posY = pos.y + tileSize.height / 2
                    roadShapeTable[shape].tilePosX = x
                    roadShapeTable[shape].isTop = false
                elseif v == COLLISION_TYPE_STUCK1 then
                    local vertexes = CCPointArray:create(3)
                    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
			        vertexes:add(cc.p(pos.x, pos.y + tileSize.height / 2 - STUCK_TOP_JULI))
			        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))
			        local shape = body:addPolygonShape(vertexes)
                    shape:setCollisionType(v)
                    stuckShapeTable[shape] = ccp(pos.x, pos.y + tileSize.height / 2)
                elseif v == COLLISION_TYPE_STUCK2 then
                    local vertexes = CCPointArray:create(3)
                    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2))
                    vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
			        vertexes:add(cc.p(pos.x, pos.y - tileSize.height / 2 + STUCK_TOP_JULI))
			        local shape = body:addPolygonShape(vertexes)
                    shape:setCollisionType(v)
                elseif v == COLLISION_TYPE_STUCK3 then
                    local vertexes = CCPointArray:create(3)
                    vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
                    vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))
			        vertexes:add(cc.p(pos.x - tileSize.width / 2 + STUCK_TOP_JULI, pos.y))
			        local shape = body:addPolygonShape(vertexes)
                    shape:setCollisionType(v)
                elseif v == COLLISION_TYPE_STUCK4 then
                    local vertexes = CCPointArray:create(3)
                    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
                    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2))
			        vertexes:add(cc.p(pos.x + tileSize.width / 2 - STUCK_TOP_JULI, pos.y))
			        local shape = body:addPolygonShape(vertexes)
                    shape:setCollisionType(v)
                else
                    local vertexes = CCPointArray:create(4)
                    local offset = 0
                    tileSize = CCSize(tileSize.width - 2 * offset, tileSize.height - 2 * offset)
			        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
			        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2)) 
			        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
			        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))


        --               vertexes:add(cc.p(pos.x, pos.y - tileSize.height / 2))
			        --vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y))
			        --vertexes:add(cc.p(pos.x, pos.y + tileSize.height / 2))
			        --vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y))
			        local shape = body:addPolygonShape(vertexes)
                    shape:setCollisionType(v)

                    if v == COLLISION_TYPE_DIAMOND then
                        diamondTable[shape] = tile
                    end
                end
            end
        end
    end

    for layerName, v in pairs(MAP_ITEMS) do
		local layer = map:layerNamed(layerName)
        if not layer then
            --do nothing
        else
		    addShapeInLayer(layer, v)
        end
    end  

    --没有tile时，添加�?��用于碰撞到roleLine时增加后三个的tile
    if not hasTile then
        local layer = self.m_pOldMap:layerNamed("road1")
	    local tilePos = layer:positionAt(ccp(x, 0))
        local shape = addRoadShape(COLLISION_TYPE_ROAD_FIX,
				ccp(tilePos.x, 10), 
				ccp(tilePos.x + TILE_WIDTH, 10), 1)

        roadShapeTable[shape] = {}
        roadShapeTable[shape].tilePosX = x
        roadShapeTable[shape].isTop = false
    end
end

function MainScene:addShapes(map, tilePosX)
end

function MainScene:update(dt)
	local oldMapWidth = self.m_pOldMap:getContentSize().width
	local oldBodyPos = self.m_pOldMap:getPosition()
	--µØÍ¼ÒÑ³ö½ç£¬É¾³ý¾ÉµØÍ¼£¬Ìí¼ÓÐÂµØÍ¼
	if (oldBodyPos <= - oldMapWidth) then
		self:removeOldMapAddNewMap()
    end

    if not newMapShapeInited then
        local layer = self.m_pOldMap:layerNamed("road1")
	    --local tilePos = layer:positionAt(ccp(ROLE_POS_X - 1, ROLE_POS_Y))
        if self.m_pNewMap:getPositionX() < rolePosX + TILE_WIDTH * 2 then
            newMapShapeInited = true
            for i = 0, ROAD_SHAPE_NUM - 1 do 
		        self:addShapesAtPos(i, self.m_pNewMapBody, self.m_pNewMap)
	        end
        end
    end

    if (self.yunNode:getPositionX() < - sYunWidth * (yunCount + 1)) then
        self:removeOldYun()
    end

    if (self.caodiNode:getPositionX() < - WIN_WIDTH * (caodiCount + 1)) then
        self:removeOldCaodi()
    end
end

function MainScene:removeOldMapAddNewMap()
	print("start remove old")

	--ÒÆ³ý¾ÉµØÍ¼
	self.m_pOldMap:removeFromParent()
    self.m_pOldMapBody:removeSelf()

	--½«Ö®Ç°µÄÐÂµØÍ¼¸³Öµ¸ø¾ÉµØÍ¼
	self.m_pOldMap = self.m_pNewMap
	self.m_pOldMapBody = self.m_pNewMapBody
    self.mapBodys[1] = self.m_pOldMapBody

	--´´½¨ÐÂµØÍ¼
    local odMapPosX = self.m_pOldMap:getPosition()
	local newMapPosX = odMapPosX + self.m_pOldMap:getContentSize().width
	self.m_pNewMapBody = self:addMapBody(newMapPosX)
	self.m_pNewMap = self:addNewMap(newMapPosX, self.m_pNewMapBody)
    self.mapBodys[2] = self.m_pNewMapBody

    newMapShapeInited = false

	print("end create new map")
end

function MainScene:removeOldCaodi()
    caodiCount = caodiCount + 1

    local caodi = self.caodiTable[1]
    caodi:removeFromParentAndCleanup(true)
    table.remove(self.caodiTable, 1)

    local lastCaodi = self.caodiTable[#self.caodiTable]
    local pos = lastCaodi:getPositionX() + WIN_WIDTH

    local caodi2 = cc.ui.UIImage.new("interface_caodi.png")
        :align(display.LEFT_BOTTOM, pos, 0)
        :addTo(self.caodiNode)

    table.insert(self.caodiTable, caodi2)
end

function MainScene:removeOldYun()
    yunCount = yunCount + 1

    local yun = self.yunsTable[1]
    yun:removeFromParentAndCleanup(true)
    table.remove(self.yunsTable, 1)

    local lastYun = self.yunsTable[#self.yunsTable]
    local pos = lastYun:getPositionX() + sYunWidth
    self:addAYun(pos)
end

function MainScene:addMapBody(posX)
	local body = CCPhysicsBody:create(self.world, 1, 1)
    self.world:addBody(body)
	body:setPosition(ccp(posX, 0))
	body:setVelocity(-MAP_MOVE_SPEED, 0)
	body:setForce(0, -GRAVITY)

    --body:setBodyPostionHandle(handler(self, self.onBodyPostionListener))

	return body
end

function MainScene:createRole()
	local layer = self.m_pOldMap:layerNamed("road1")
	local tilePos = layer:positionAt(ccp(ROLE_POS_X, ROLE_POS_Y))
    rolePosX = tilePos.x
    
    self.pigAnimation = SkeletonAnimation:createWithFile("pig/skeleton.json", "pig/skeleton.atlas", 1)
    self:addChild(self.pigAnimation)

	--roleSize = role:getContentSize()
	roleSize = self.m_pOldMap:getTileSize()
    roleHeight = roleSize.height
	local rolePos = ccpAdd(tilePos, ccp(roleSize.width / 2, roleSize.height / 2))

    self.pigAnimation:setPosition(rolePos)

    self.pigAnimation:setAnchorPoint(ccp(0, 0.5))
    self.pigAnimation:setContentSize(roleSize)

	--local vexArray = CCPointArray:create(4)
	--vexArray:add(ccp(- roleSize.width / 2, - roleSize.height / 2))
	--vexArray:add(ccp(- roleSize.width / 2,   roleSize.height / 2))
	--vexArray:add(ccp(  roleSize.width / 2,   roleSize.height / 2))
	--vexArray:add(ccp(  roleSize.width / 2, - roleSize.height / 2))

    local vexArray = CCPointArray:create(8)
    vexArray:add(ccp(- roleSize.width / 2 + ROLE_HOR_XIANG_SU, - roleSize.height / 4))
	vexArray:add(ccp(- roleSize.width / 2 + ROLE_HOR_XIANG_SU,   roleSize.height / 4))
	vexArray:add(ccp(- roleSize.width / 4,   roleSize.height / 2 - ROLE_VER_XIANG_SU))
	vexArray:add(ccp(  roleSize.width / 4,   roleSize.height / 2 - ROLE_VER_XIANG_SU))
    vexArray:add(ccp(  roleSize.width / 2 - ROLE_HOR_XIANG_SU,   roleSize.height / 4))
	vexArray:add(ccp(  roleSize.width / 2 - ROLE_HOR_XIANG_SU, - roleSize.height / 4))
	vexArray:add(ccp(  roleSize.width / 4, - roleSize.height / 2 + ROLE_VER_XIANG_SU))
	vexArray:add(ccp( -roleSize.width / 4, - roleSize.height / 2 + ROLE_VER_XIANG_SU))

	local roleBody = self.world:createPolygonBody(1, vexArray)
    roleBody:setCollisionType(COLLISION_TYPE_ROLE)
    roleBody:setPosition(rolePos)
    roleBody:setVelocity(0, -MAP_MOVE_SPEED)
    roleBody:bind(self.pigAnimation)

    --roleBody:setBodyPostionHandle(handler(self, self.onRolePostionListener))

    self.roleBody = roleBody
end

function MainScene:addBottomLineShape()
    local bottomWallBody = self.world:createBoxBody(0, WIN_WIDTH, 1)
    bottomWallBody:setPosition(0, 0)
    bottomWallBody:setCollisionType(COLLISION_TYPE_BOTTOM_LINE)
    self:addCollisionToRoleScriptListener(COLLISION_TYPE_BOTTOM_LINE)
end

function MainScene:addRoleLineShape(collisionType, tileDisWithRole)
    local width = 20
    local roleWallBody = self.world:createBoxBody(0, width, WIN_HEIGHT)
    roleWallBody:setPosition(rolePosX - TILE_WIDTH * tileDisWithRole - width / 2, WIN_HEIGHT / 2)
    roleWallBody:setCollisionType(collisionType)

    for k, v in pairs(MAP_ITEMS) do
        self:addCollisionScriptListener(collisionType, v)
    end
    self:addCollisionScriptListener(collisionType, COLLISION_TYPE_ROAD_LEFT)
    self:addCollisionScriptListener(collisionType, COLLISION_TYPE_ROAD_FIX)
end

function MainScene:onCollisionListener(phase, event)
    if phase == "begin" then
        return self:onCollisionBegin(event)
    elseif phase == "preSolve" then
        return false
    elseif phase == "postSolve" then
        return false
    elseif phase == "separate" then
        return self:onSeparate(event)
    end
end

function MainScene:onCollisionBegin(event)
    if isGamePause then return false end

    local body1 = event:getBody1()   --½ÇÉ«body
    local body2 = event:getBody2()   --µØÍ¼body

    local shape1 = event:getShape1()   --½ÇÉ«shape
    local shape2 = event:getShape2()   --µØÍ¼shape

    local shape1CollisionType = shape1:getCollisionType()
    if shape1CollisionType == COLLISION_TYPE_ROLE_LINE then
        local collisionType = shape2:getCollisionType()

        if collisionType == COLLISION_TYPE_STUCK1 
            or collisionType == COLLISION_TYPE_STUCK2
            or collisionType == COLLISION_TYPE_STUCK3
            or collisionType == COLLISION_TYPE_STUCK4
            then
            score  = score + 1
            self.scoreLabel:setString(score)
            if stuckShapeTable[shape2] then
                stuckShapeTable[shape2] = nil
            end
        end
        return false
    elseif shape1CollisionType == COLLISION_TYPE_REMOVE_SHAPE_LINE then
        local collisionType = shape2:getCollisionType()
        if collisionType == COLLISION_TYPE_ROAD or collisionType == COLLISION_TYPE_ROAD_FIX then
            if not roadShapeTable[shape2].isTop then
        	    local map = body2:getNode()
        	    self:addShapesAtPos(roadShapeTable[shape2].tilePosX + ROAD_SHAPE_NUM, body2, map)
                roadShapeTable[shape2] = nil
            end
        elseif collisionType == COLLISION_TYPE_DIAMOND then
            diamondTable[shape2] = nil
        end
        body2:removeShape(shape2)
        return false
    elseif shape1CollisionType == COLLISION_TYPE_ROLE then
        if self.collisionLeft then 
            self:gamePause()
            self.collisionLeft = false
            return false
        end

        local collisionType = shape2:getCollisionType()
	    --print("begin collision collision_type: " .. collisionType)
	    if (collisionType == COLLISION_TYPE_ROAD) then
            if roleState ~= ROLE_STATE_ROAD then
                self.pigAnimation:setAnimation(0, "run", true)
                --local x, y = body1:getPosition()
                --body1:setPosition(ccp(x, roadShapeTable[shape2].posY + roleHeight / 2))
            end

            wudi = false
		    self.collisionRoadCount = self.collisionRoadCount + 1
            print("onCollisionBegin collisionRoadCount: " .. self.collisionRoadCount)
		    --¸øroleÒ»¸öÁ¦µÖÏûÖØÁ¦
            body1:setForce(ccp(0, -GRAVITY))
            body1:setVelocity(ccp(0, 0))

            roleState = ROLE_STATE_ROAD
        elseif collisionType == COLLISION_TYPE_ROAD_TOP then
            local vx, vy = body1:getVelocity()
            print(vx .. vy)
            if vy > 0 then
                body1:setVelocity(vx, -JUMP_FAN_TAN_XI_SHU * vy)
            end
            --roleState = ROLE_STATE_COLLSION_TOP
        elseif collisionType == COLLISION_TYPE_DIAMOND then
            diamondCount = diamondCount + 1
            self.diamondCountLabel:setString(diamondCount)
            CCUserDefault:sharedUserDefault():setIntegerForKey(STRING_DIAMOND_COUNT, diamondCount)
            diamondTable[shape2]:removeFromParent()
            body2:removeShape(shape2)
            self:playSound("sounds/diamond.ogg")
            --print("remove diamond")
        elseif collisionType == COLLISION_TYPE_BOTTOM_LINE then
            if wudiWhenResume then
                self:gameResume()
                return false
            end

            self:gamePause()
        elseif collisionType == COLLISION_TYPE_ROAD_LEFT then
            if wudiWhenResume then
                self:gameResume()
                return false
            end

            self:playSound("sounds/left_road.ogg")
            if roleState ~= ROLE_STATE_ROAD then
                body1:setVelocity(-10, -100)
                --body1:setVelocity(0, 0)
                --body1:setForce(0, -GRAVITY)  
                for _, body in ipairs(self.mapBodys) do 
                    body:setVelocity(0, 0)           
                    body:setForce(0, -GRAVITY)           
                end
                scheduler.unscheduleGlobal(self.updateSchedule)
                scheduler.unscheduleGlobal(self.updateSpeedSchedule)
                self.collisionLeft = true
            else
                self:gamePause()
            end
        --遇到仙人掌了
        else
            if CHEAT_MODE or wudi or wudiWhenResume then return false end

            if stuckShapeTable[shape2] then
                local map = body2:getNode()
                body1:setPosition(ccpAdd(stuckShapeTable[shape2], ccp(map:getPosition())))
            end
            self:playSound("sounds/truck.ogg")
            self:gamePause()
        end
    end

    return false
end

function MainScene:onSeparate(event)
    if isGamePause then return false end

    local body1 = event:getBody1()   --½ÇÉ«body
    local body2 = event:getBody2()   --µØÍ¼body

    local shape1 = event:getShape1()   --½ÇÉ«shape
    local shape2 = event:getShape2()   --µØÍ¼shape

    local collisionType = shape1:getCollisionType()
    --print("onSeparate collision_type: " .. collisionType)
    if collisionType == COLLISION_TYPE_ROLE_LINE then
        return false
	elseif collisionType == COLLISION_TYPE_ROLE and shape2 and (shape2:getCollisionType() == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount - 1
        print("onSeparate collisionRoadCount: " .. self.collisionRoadCount)
		
		--Àë¿ªËùÓÐµÄµÀÂ·£¬»Ö¸´ÖØÁ¦Ð§¹û
		if (self.collisionRoadCount == 0) then
			body1:setForce(ccp(0, 0))
            if roleState ~= ROLE_STATE_JUMP then
                body1:setVelocity(0, -ROLE_FALL_SPEED)
                roleState = ROLE_STATE_FALL
                wudi = true
            end
        end
    end

    return false
end

function MainScene:gameOver()
    --if CHEAT_MODE then return end
    --print("gameOver")

    --isGamePause = true

    --scheduler.unscheduleGlobal(self.updateSchedule)
    --scheduler.unscheduleGlobal(self.updateSpeedSchedule)
    --if self.jumpSchedule then
    --    scheduler.unscheduleGlobal(self.jumpSchedule)
    --    self.jumpSchedule = true
    --end

    --self.pigAnimation:setAnimation(0, "dead", true)
    --self.world:stop()
    --self.baseLayer:setTouchEnabled(false)

    --if score > maxScore then
    --    maxScore = score
    --    self.maxScoreLabel:setString(maxScore)
    --    CCUserDefault:sharedUserDefault():setIntegerForKey(STRING_MAX_SCORE, maxScore)
    --end

    --self:addGamePauseButtons()
    
    --if ANDOIRD then
    --    luaj.callStaticMethod("com/xwtan/run/Run", "showInterstitialStatic")
    --    luaj.callStaticMethod("com/xwtan/run/Run", "vibrate")
    --end
end

function MainScene:gamePause()
    --if CHEAT_MODE then return end
    print("gamePause")

    isGamePause = true

    if self.updateSchedule then
        scheduler.unscheduleGlobal(self.updateSchedule)
        self.updateSchedule = nil
    end
    if self.updateSpeedSchedule then
        scheduler.unscheduleGlobal(self.updateSpeedSchedule)
        self.updateSpeedSchedule = nil
    end
    if self.jumpSchedule then
        scheduler.unscheduleGlobal(self.jumpSchedule)
        self.jumpSchedule = nil
    end
    if self.resumeSchedule then
        scheduler.unscheduleGlobal(self.resumeSchedule)
        self.resumeSchedule = nil
    end

    self.pigAnimation:setAnimation(0, "dead", true)
    self.world:stop()
    self.baseLayer:setTouchEnabled(false)

    if score > maxScore then
        maxScore = score
        self.maxScoreLabel:setString(maxScore)
        CCUserDefault:sharedUserDefault():setIntegerForKey(STRING_MAX_SCORE, maxScore)
    end

    self:addGamePauseButtons()
    
    if ANDOIRD then
        luaj.callStaticMethod("com/xwtan/run/Run", "showInterstitialStatic")
        luaj.callStaticMethod("com/xwtan/run/Run", "vibrate")
    end
end

function MainScene:gameResume()
     --if CHEAT_MODE then return end
    print("gameResume")
    
    self:startGame()
    self:resetParms()

    self.baseLayer:setTouchEnabled(true)

    local layer = self.m_pOldMap:layerNamed("road1")
    local tilePos = layer:positionAt(ccp(ROLE_POS_X, 0))
    self.roleBody:setPosition(tilePos)
    self.roleBody:setForce(ccp(0, 0))
    self.roleBody:setVelocity(ccp(0, 0))
    roleState = ROLE_STATE_FALL

    wudiWhenResume = true
    if self.resumeSchedule then scheduler.unscheduleGlobal(self.resumeSchedule) end
    self.resumeSchedule = scheduler.scheduleGlobal(function()
        wudiWhenResume = false
        scheduler.unscheduleGlobal(self.resumeSchedule)
        self.resumeSchedule = nil
    end, resumeWudiTime)
end

function MainScene:resetParms()
    self.collisionRoadCount = 0
    wudi = false
    isGamePause = false
end

function MainScene:onEnter()
    if ANDOIRD then
        luaj.callStaticMethod("com/xwtan/run/Run", "showBannerStatic")
    end
end

function MainScene:onExit()
    self.world:removeAllCollisionListeners()
end

function MainScene:calSpeed()
    if MAP_MOVE_SPEED >= MAP_MOVE_SPEED_LIMIT then return end

    MAP_MOVE_SPEED = MAP_MOVE_SPEED + SPEED_CHANGE_NUM
    local time = (JUMP_GE_ZI_HOR * TILE_WIDTH) / MAP_MOVE_SPEED
    ROLE_JUMP_SPEED = 2 * (2 * (JUMP_GE_ZI_VER * TILE_WIDTH + JUMP_XIANG_SU_VER) / time) 
    GRAVITY = - 2 * ROLE_JUMP_SPEED / time
    --print("ROLE_JUMP_SPEED :", ROLE_JUMP_SPEED)
    --print("GRAVITY :", GRAVITY)

    ROLE_FALL_SPEED = MAP_MOVE_SPEED

    --resumeWudiTime = math.sqrt(CONFIG_SCREEN_HEIGHT / (GRAVITY /  2)) + 0.5
    resumeWudiTime = 5
end

function MainScene:vibrate()
    if ANDOIRD and CCUserDefault:sharedUserDefault():getBoolForKey(STRING_ZHEN_DONG, true) then
        luaj.callStaticMethod("com/xwtan/run/Run", "vibrate")
    end
end

function MainScene:playMusic(filename)
    if CCUserDefault:sharedUserDefault():getBoolForKey(STRING_MUSIC, true) then
        audio.playMusic(filename)
    end
end

function MainScene:playSound(filename)
    if CCUserDefault:sharedUserDefault():getBoolForKey(STRING_MUSIC, true) then
        audio.playSound(filename)
    end
end

function MainScene:callJavaFunc(className, methodName, args, sig)
    if ANDOIRD then
        luaj.callStaticMethod(className, methodName, args, sig)
    end
end

return MainScene
