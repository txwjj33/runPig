local scheduler = require("framework.scheduler")
if ANDOIRD then
    local scheduler = require("framework.luaj")
end

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

COLLISION_TYPE_ROLE_LINE = -1
COLLISION_TYPE_BOTTOM_LINE = 0   --下面的线用来判定玩家死亡
COLLISION_TYPE_ROLE        = 1
COLLISION_TYPE_ROAD        = 2
COLLISION_TYPE_ROAD_TOP  = 3
COLLISION_TYPE_ROAD_LEFT = 4
COLLISION_TYPE_DIAMOND = 5
COLLISION_TYPE_STUCK1 = 10
COLLISION_TYPE_STUCK2 = 11
COLLISION_TYPE_STUCK3 = 12
COLLISION_TYPE_STUCK4 = 13

local STRING_MAX_SCORE = "MAX_SCORE"
local STRING_MUSIC = "MUSIC"

MAP_COUNT = 1
local rolePosX = 0
local sYunWidth = 0

local roleSize = 0
local isGameOver = false

local font = "AGENTORANGE.ttf"

local currentLevel = -1
local score = 0
local diamondScore = 0
local maxScore = 0
local yunCount = 0
local caodiCount = 0
--钻石shape表
local diamondTable = {}

local roleHeight = 0

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

function restartGame()
    currentLevel = -1
    score = 0
    yunCount = 0
end

function MainScene:addCollisionToRoleScriptListener(collisionType)
    self:addCollisionScriptListener(COLLISION_TYPE_ROLE, collisionType)
end

function MainScene:addCollisionScriptListener(type1, type2)
    self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), type1, type2)
end

function MainScene:ctor()
    self.collisionRoadCount = 0
    self.shapes = {}

    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)

    self:initUI()
    self:addLabel()
    

    local startPos = 0
	self.m_pOldMapBody = self:addMapBody(0)
    self.m_pOldDiamonds = {}  --记录钻石的shape，碰撞时删除
    self.m_pOldRoadPosY = {}  --记录道路的y坐标，重定位角色
	self.m_pOldMap = self:addNewMap(startPos, self.m_pOldMapBody, self.m_pOldDiamonds, self.m_pOldRoadPosY)

	local oldMapWidth = self.m_pOldMap:getContentSize().width + startPos
	print("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED)
	self.m_pNewMapBody = self:addMapBody(oldMapWidth)
    self.m_pNewDiamonds = {}
    self.m_pNewRoadPosY = {}
	self.m_pNewMap = self:addNewMap(oldMapWidth, self.m_pNewMapBody, self.m_pNewDiamonds, self.m_pNewRoadPosY)

	self:createRole(ccp(ROLE_POS_X, ROLE_POS_Y))
	self:addBottomLineShape()
	self:addRoleLineShape()   --添加角色所在位置的竖线，用于检测跳过的障碍数

    for k, v in pairs(MAP_ITEMS) do
        self:addCollisionToRoleScriptListener(v)
    end
    self:addCollisionToRoleScriptListener(COLLISION_TYPE_ROAD_LEFT)

    -- add debug node
    --self.worldDebug = self.world:createDebugNode()
    --self:addChild(self.worldDebug)

    local baseLayer = display.newLayer()
	baseLayer:setTouchEnabled(true)
    self:addChild(baseLayer)
    baseLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        if (self.collisionRoadCount > 0) then
            self.roleBody:setVelocity(ccp(0, ROLE_JUMP_SPEED))
            self.pigAnimation:setAnimation(0, "jump", true)
        end
    end)
    self.baseLayer = baseLayer
end

function MainScene:initUI()
    cc.ui.UIImage.new("interface_background.png")
        :align(display.LEFT_BOTTOM)
        :addTo(self)
    self:addYun()
    self:addSun()
    self:addCaodi()
    
    --self:addButtons()
end

function MainScene:addCaodi()
    self.caodiBody = self:addMapBody(0)
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
    self.yunNode = display.newNode()
    self:addChild(self.yunNode)
    self.yunBody:bind(self.yunNode)

    self.yunsTable = {}
    self.yunBatchNode = CCSpriteBatchNode:create("interface_yun_02.png", 100)
        :addTo(self.yunNode)
    sYunWidth = self.yunBatchNode:getTexture():getContentSize().width
    local yunCount = math.floor(CONFIG_SCREEN_WIDTH / sYunWidth) + 2
    local posX = 0

    for k = 1, yunCount do
        self:addAYun(posX)
        posX = posX + sYunWidth - 3
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

    local bestLabel = CCLabelTTF:create("Best", font, fontSize)
    bestLabel:setColor(ccc3(255,232,111))
    bestLabel:setPosition(1019, height)
    bestLabel:setAnchorPoint(ccp(0, 0.5))
    self:addChild(bestLabel)
end

function MainScene:addButtons()
    cc.ui.UIPushButton.new("button_try-again_02.png")
        :onButtonPressed(function(event)
            event.target:setScale(1.2)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
            package.loaded["scenes.MainScene"] = nil
            display.replaceScene(require("scenes.MainScene").new())
        end)
        :align(display.CENTER, WIN_WIDTH / 2, WIN_HEIGHT / 2)
        :addTo(self)
end

function MainScene:addNewMap(posX, body, diamondTable, roadPosYTable)
    currentLevel = currentLevel + 1
    local levelID = nil
    if currentLevel <= LEVEL_RECYCLE_MIN then
        levelID = currentLevel
    else
        levelID = math.random(LEVEL_RECYCLE_MIN, LEVEL_RECYCLE_MAX)
    end

    local mapID = math.random(1, LEVEL_NUM_CONF[levelID])
    local mapPath = string.format("levels/%d.%d.tmx", levelID, mapID)
	print("create new map: " .. mapPath)

	local map = CCTMXTiledMap:create(mapPath)
	map:setPosition(posX, 0)
    self:addChild(map)

    body:bind(map)

    --添加road对应的形状
    local function addRoadShape(collisionType, pos1, pos2)
        local shape = body:addSegmentShape(pos1, pos2, 1)
        shape:setCollisionType(collisionType)
        return shape
    end

	for layerName, v in pairs(MAP_ITEMS) do
		local layer = map:layerNamed(layerName)
        if not layer then
            --do nothing
        else
		    local mapSize = map:getMapSize()
		    for x = 0, mapSize.width - 1 do
			    for y = 0, mapSize.height - 1 do
				    local tile = layer:tileAt(ccp(x, y))
				    if tile then
                        local tileSize = tile:getContentSize()
					    local pos = ccpAdd(ccp(tile:getPosition()), ccp(tileSize.width / 2, tileSize.height / 2))

                        --检查是不是最左边的road
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

                            addRoadShape(COLLISION_TYPE_ROAD,
								    ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
								    ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))

                            checkLeftRoad()
                        elseif v == COLLISION_TYPE_ROAD then
                            local shape = addRoadShape(COLLISION_TYPE_ROAD,
								    ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
								    ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))

                            checkLeftRoad()
                            roadPosYTable[shape] = pos.y + tileSize.height / 2
                        else
                            local vertexes = CCPointArray:create(4)
					        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
					        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2))
					        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
					        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))

					        local shape = body:addPolygonShape(vertexes)
                            shape:setCollisionType(v)

                            if v == COLLISION_TYPE_DIAMOND then
                                diamondTable[shape] = tile
                            end
                        end
                    end
                end
            end
        end
    end

	return map
end

function MainScene:update(dt)
	local oldMapWidth = self.m_pOldMap:getContentSize().width
	local oldBodyPos = self.m_pOldMap:getPosition()
	--地图已出界，删除旧地图，添加新地图
	if (oldBodyPos <= - oldMapWidth) then
		self:removeOldMapAddNewMap()
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

	--移除旧地图
	self.m_pOldMap:removeFromParent()
    self.m_pOldMapBody:removeSelf()

	--将之前的新地图赋值给旧地图
	self.m_pOldMap = self.m_pNewMap
	self.m_pOldMapBody = self.m_pNewMapBody
    self.m_pOldDiamonds = self.m_pNewDiamonds
    self.m_pOldRoadPosY = self.m_pNewRoadPosY

	--创建新地图
    local odMapPosX = self.m_pOldMap:getPosition()
	local newMapPosX = odMapPosX + self.m_pOldMap:getContentSize().width
	self.m_pNewMapBody = self:addMapBody(newMapPosX)
    self.m_pNewDiamonds = {}
    self.m_pNewRoadPosY = {}
	self.m_pNewMap = self:addNewMap(newMapPosX, self.m_pNewMapBody, self.m_pNewDiamonds, self.m_pNewRoadPosY)

	print("end create new map")
end

function MainScene:removeOldCaodi()
    caodiCount = caodiCount + 1

    local caodi = self.caodiTable[1]
    caodi:removeFromParentAndCleanup(true)
    table.remove(self.caodiTable, 1)

    local lastCaodi = self.caodiTable[#self.caodiTable]
    local pos = lastCaodi:getPositionX() + WIN_WIDTH - 3

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
    local pos = lastYun:getPositionX() + sYunWidth - 3
    self:addAYun(pos)
end

function MainScene:addMapBody(posX)
	local body = CCPhysicsBody:create(self.world, 1, 1)
    self.world:addBody(body)
	body:setPosition(ccp(posX, 0))
	body:setVelocity(-MAP_MOVE_SPEED, 0)
	body:setForce(0, -GRAVITY)
	--body->position_func = updateBodyPostion;

	return body
end

function MainScene:createRole(pos)
	local layer = self.m_pOldMap:layerNamed("road1")
	local tilePos = layer:positionAt(pos)
    rolePosX = tilePos.x

	local role = display.newSprite("zhuti_zhu.png")
    self:addChild(role)
    
    self.pigAnimation = SkeletonAnimation:createWithFile("pig/skeleton.json", "pig/skeleton.atlas", 1)
    self.pigAnimation:setAnimation(0, "run", true)
    self:addChild(self.pigAnimation)

	--roleSize = role:getContentSize()
	roleSize = self.m_pOldMap:getTileSize()
    roleHeight = roleSize.height
	local rolePos = ccpAdd(tilePos, ccp(roleSize.width / 2, roleSize.height / 2))

    self.pigAnimation:setAnchorPoint(ccp(0, 0.5))
    self.pigAnimation:setContentSize(roleSize)

	local vexArray = CCPointArray:create(4)
	vexArray:add(ccp(- roleSize.width / 2, - roleSize.height / 2))
	vexArray:add(ccp(- roleSize.width / 2,   roleSize.height / 2))
	vexArray:add(ccp(  roleSize.width / 2,   roleSize.height / 2))
	vexArray:add(ccp(  roleSize.width / 2, - roleSize.height / 2))

	local roleBody = self.world:createPolygonBody(1, vexArray)
    roleBody:setCollisionType(COLLISION_TYPE_ROLE)
    roleBody:setPosition(rolePos)
    roleBody:bind(self.pigAnimation)

    self.roleBody = roleBody
end

function MainScene:addBottomLineShape()
    local bottomWallBody = self.world:createBoxBody(0, WIN_WIDTH, 1)
    bottomWallBody:setPosition(0, 0)
    bottomWallBody:setCollisionType(COLLISION_TYPE_BOTTOM_LINE)
    self:addCollisionToRoleScriptListener(COLLISION_TYPE_BOTTOM_LINE)
end

function MainScene:addRoleLineShape()
    local roleWallBody = self.world:createBoxBody(0, 1, WIN_HEIGHT)
    roleWallBody:setPosition(rolePosX - 2, WIN_HEIGHT / 2)
    roleWallBody:setCollisionType(COLLISION_TYPE_ROLE_LINE)

    for k, v in pairs(MAP_ITEMS) do
        self:addCollisionScriptListener(COLLISION_TYPE_ROLE_LINE, v)
    end
    self:addCollisionScriptListener(COLLISION_TYPE_ROLE_LINE, COLLISION_TYPE_ROAD_LEFT)
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
    if isGameOver then return false end

    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body

    local shape1 = event:getShape1()   --角色shape
    local shape2 = event:getShape2()   --地图shape
    if shape1:getCollisionType() == COLLISION_TYPE_ROLE_LINE then
        local collisionType = shape2:getCollisionType()
        if collisionType == COLLISION_TYPE_STUCK1 
            or collisionType == COLLISION_TYPE_STUCK2
            or collisionType == COLLISION_TYPE_STUCK3
            or collisionType == COLLISION_TYPE_STUCK4
            then
            score  = score + 1
            self.scoreLabel:setString(score)
        end

        return false
    end

    local collisionType = shape2:getCollisionType()
	--print("begin collision collision_type: " .. collisionType)
	if (collisionType == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount + 1
		--给role一个力抵消重力
        body1:setForce(ccp(0, -GRAVITY))
        body1:setVelocity(ccp(0, 0))

        local roadPosY = 0
        if self.m_pOldRoadPosY[shape2] then
            roadPosY = self.m_pOldRoadPosY[shape2]
        else
            roadPosY = self.m_pNewRoadPosY[shape2]
        end
        local x, y = body1:getPosition()
        body1:setPosition(ccp(x, roadPosY + roleHeight / 2))

        if self.pigAnimation:isPlayAnimation("jump") then
            self.pigAnimation:setAnimation(0, "run", true)
        end
    elseif (collisionType == COLLISION_TYPE_ROAD_TOP) then
        local vx, vy = body1:getVelocity()
        print(vx .. vy)
        if vy > 0 then
            body1:setVelocity(vx, -vy)
        end
    elseif (collisionType == COLLISION_TYPE_DIAMOND) then
        diamondScore = diamondScore + DIAMOND_SCORE
        if self.m_pOldDiamonds[shape2] then
            self.m_pOldDiamonds[shape2]:removeFromParent()
            body2:removeShape(shape2)
            print("remove diamond")
        elseif self.m_pNewDiamonds[shape2] then
            self.m_pNewDiamonds[shape2]:removeFromParent()
            body2:removeShape(shape2)
            print("remove diamond")
        end
    else
        self:gameOver()
    end

    return false
end

function MainScene:onSeparate(event)
    if isGameOver then return false end

    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body

    local shape1 = event:getShape1()   --角色shape
    local shape2 = event:getShape2()   --地图shape

    if shape1:getCollisionType() == COLLISION_TYPE_ROLE_LINE then
        return false
    end

    --local collisionType = event:getShape2():getCollisionType()
	--print("onSeparate collision_type: " .. collisionType)
	if shape2 and (event:getShape2():getCollisionType() == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount - 1
		
		--离开所有的道路，恢复重力效果
		if (self.collisionRoadCount == 0) then
			body1:setForce(ccp(0, 0))
        end
    end

    return false
end

function MainScene:gameOver()
    isGameOver = true

    self.pigAnimation:setAnimation(0, "dead", true)
    self.world:stop()
    scheduler.unscheduleGlobal(self.updateSchedule)
    self.baseLayer:removeFromParent()

    if score > maxScore then
        maxScore = score
        self.maxScoreLabel:setString(maxScore)
        CCUserDefault:sharedUserDefault():setIntegerForKey(STRING_MAX_SCORE, maxScore)
    end

    self:addButtons()
    if ANDOIRD then
        luaj.callStaticMethod("com/xwtan/run/Run", "showSpotAd")
        luaj.callStaticMethod("com/xwtan/run/Run", "vibrate")
    end
end

function MainScene:onEnter()
    self.world:start()
    
    self.updateSchedule = scheduler.scheduleUpdateGlobal(function(dt)
        self:update(dt)
    end)
end

function MainScene:onExit()
    self.world:removeAllCollisionListeners()
end

return MainScene
