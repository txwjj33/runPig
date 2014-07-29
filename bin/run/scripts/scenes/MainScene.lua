local scheduler = require("framework.scheduler")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

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

MAP_COUNT = 1

local currentLevel = -1
local score = 0
--钻石shape与
local diamondTable = {}

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
end

function MainScene:addCollisionScriptListener(collitionType)
    self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), COLLISION_TYPE_ROLE, collitionType)
end

function MainScene:ctor()
    self.collisionRoadCount = 0

    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)

    local startPos = 0
	self.m_pOldMapBody = {}
    self.m_pOldDiamonds = {}
	self.m_pOldMap = self:addNewMap(startPos, self.m_pOldMapBody, self.m_pOldDiamonds)

	local oldMapWidth = self.m_pOldMap:getContentSize().width + startPos
	print("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED)
	self.m_pNewMapBody = {}
    self.m_pNewDiamonds = {}
	self.m_pNewMap = self:addNewMap(oldMapWidth, self.m_pNewMapBody, self.m_pNewDiamonds)

	--self:createRole(ccp(ROLE_POS_X, ROLE_POS_Y))
	self:addBottomLineShape()

    for k, v in pairs(MAP_ITEMS) do
        self:addCollisionScriptListener(v)
    end
    self:addCollisionScriptListener(COLLISION_TYPE_ROAD_LEFT)

    -- add debug node
    self.worldDebug = self.world:createDebugNode()
    self:addChild(self.worldDebug)

    local baseLayer = display.newLayer()
	baseLayer:setTouchEnabled(true)
    self:addChild(baseLayer)
    baseLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        if (self.collisionRoadCount > 0) then
            self.roleBody:setVelocity(ccp(0, ROLE_JUMP_SPEED))
        end
    end)
end

function MainScene:addNewMap(posX, bodys, diamondTable)
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

    local function getBody(collitionType)
        if bodys[collitionType] then 
            return bodys[collitionType]
        else
            local body = self:addMapBody(posX)
            body:bind(map)
            bodys[collitionType] = body
            return body
        end
    end

    --添加road对应的形状
    local function addRoadShape(collitionType, pos1, pos2)
        local shape = getBody(collitionType):addSegmentShape(pos1, pos2, 1)
        shape:setCollisionType(collitionType)
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
                            addRoadShape(COLLISION_TYPE_ROAD,
								    ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
								    ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))

                            checkLeftRoad()
                        else
                            local vertexes = CCPointArray:create(4)
					        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
					        vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2))
					        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
					        vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))

					        local shape = getBody(v):addPolygonShape(vertexes)
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
    --print("dt" .. dt)
    --self.m_pOldMapBody:setPosition(self.m_pOldMapBody:getPositionX() - MAP_MOVE_SPEED * dt, 0)
    --self.m_pNewMapBody:setPosition(self.m_pNewMapBody:getPositionX() - MAP_MOVE_SPEED * dt, 0)
     --print("dt" .. dt .. "end")
    --self.m_pOldMapBody:setPosition(ccpSub(ccp(self.m_pOldMapBody:getPosition()), ccpMult(ccp(MAP_MOVE_SPEED, 0), dt)))
    --self.m_pNewMapBody:setPosition(ccpSub(ccp(self.m_pNewMapBody:getPosition()), ccpMult(ccp(MAP_MOVE_SPEED, 0), dt)))
    --body->p = cpvadd(body->p, cpvmult(cpv(-MAP_MOVE_SPEED, 0), dt));
	local oldMapWidth = self.m_pOldMap:getContentSize().width
	local oldBodyPos = self.m_pOldMap:getPosition()
	--地图已出界，删除旧地图，添加新地图
	if (oldBodyPos <= - oldMapWidth) then
		self:removeOldMapAddNewMap()
    end
end

function MainScene:removeOldMapAddNewMap()
	print("start remove old")

	--移除旧地图
	self.m_pOldMap:removeFromParent()
    for _, v in pairs(self.m_pOldMapBody) do
        v:removeSelf()
    end

	--将之前的新地图赋值给旧地图
	self.m_pOldMap = self.m_pNewMap
	self.m_pOldMapBody = self.m_pNewMapBody
    self.m_pOldDiamonds = self.m_pNewDiamonds

	--创建新地图
    local odMapPosX = self.m_pOldMap:getPosition()
	local newMapPosX = odMapPosX + self.m_pOldMap:getContentSize().width
	self.m_pNewMapBody = {}
    self.m_pNewDiamonds = {}
	self.m_pNewMap = self:addNewMap(newMapPosX, self.m_pNewMapBody, self.m_pNewDiamonds)

	print("end create new map")
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

	local role = display.newSprite("grossini.png")
    self:addChild(role)

	local roleSize = role:getContentSize()
	local rolePos = ccpAdd(tilePos, ccp(roleSize.width / 2, roleSize.height / 2))

	local vexArray = CCPointArray:create(4)
	vexArray:add(ccp(- roleSize.width / 2, - roleSize.height / 2))
	vexArray:add(ccp(- roleSize.width / 2,   roleSize.height / 2))
	vexArray:add(ccp(  roleSize.width / 2,   roleSize.height / 2))
	vexArray:add(ccp(  roleSize.width / 2, - roleSize.height / 2))

	local roleBody = self.world:createPolygonBody(1, vexArray)
    roleBody:setFriction(0)
    roleBody:setElasticity(1)
    roleBody:setCollisionType(COLLISION_TYPE_ROLE)
    roleBody:setPosition(rolePos)
    roleBody:bind(role)

    self.roleBody = roleBody
end

function MainScene:addBottomLineShape()
    local bottomWallBody = self.world:createBoxBody(0, WIN_WIDTH, 1)
    --bottomWallBody:setFriction(0)
    --bottomWallBody:setElasticity(0)
    bottomWallBody:setPosition(0, 0)
    bottomWallBody:setCollisionType(COLLISION_TYPE_BOTTOM_LINE)
    self:addCollisionScriptListener(COLLISION_TYPE_BOTTOM_LINE)
end

function MainScene:onCollisionListener(phase, event)
    if phase == "begin" then
        return self:onCollisionBegin(event)
    elseif phase == "preSolve" then
        --local body1 = event:getBody1()   --地图body
        --local body2 = event:getBody2()   --地图body
        --local x1, y1 = body1:getPosition()
        --local x2, y2 = body2:getPosition()
        --self.body1PrePos = ccp(body1:getPosition())
        --self.body2PrePos = ccp(body2:getPosition())
        ----event:setSurfaceVelocities(0, 0)
        --local collisionType = body2:getCollisionType()
        --if (collisionType == COLLISION_TYPE_ROAD) then
            --body1:setVelocity(ccp(0, 0))
            --body1:setForce(ccp(0, -GRAVITY))
        --end
        return false
    elseif phase == "postSolve" then
     --   local body1 = event:getBody1()   --地图body
     --   local body2 = event:getBody2()   --地图body
     --   local x1, y1 = body1:getPosition()
     --   local x2, y2 = body2:getPosition()
     --   --body1:setPosition(self.body1PrePos)
     --   --body2:setPosition(self.body2PrePos)
     --   local collisionType = body2:getCollisionType()
	    --print("begin collision collision_type: " .. collisionType)
	    --if (collisionType == COLLISION_TYPE_ROAD) then
		   -- --self.collisionRoadCount = self.collisionRoadCount + 1
		   -- ----给role一个力抵消重力
     -- --      body1:setForce(ccp(0, -GRAVITY))
     -- --      body1:setVelocity(ccp(0, 0))
     --   --elseif (collisionType == COLLISION_TYPE_ITEM1) then
     --   --    self:gameOver()
     --   --elseif (collisionType == COLLISION_TYPE_BOTTOM_LINE) then
     --   --    self:gameOver()
     --   --elseif (collisionType == COLLISION_TYPE_ROAD_LEFT) then
     --   --    self:gameOver()
     --   elseif (collisionType == COLLISION_TYPE_ROAD_TOP) then
     --       local vx, vy = body1:getVelocity()
     --       print(vx .. vy)
     --       --body1:setVelocity(vx, -vy)
     --   end
        return false
    elseif phase == "separate" then
        return self:onSeparate(event)
    end
end

function MainScene:onCollisionBegin(event)
    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body
    local collisionType = body2:getCollisionType()
	--print("begin collision collision_type: " .. collisionType)
	if (collisionType == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount + 1
		--给role一个力抵消重力
        body1:setForce(ccp(0, -GRAVITY))
        body1:setVelocity(ccp(0, 0))

        --local oldBodyPosX, posY = self.m_pOldMapBody[COLLISION_TYPE_ROAD]:getPosition()
        --print("oldBody posX, posY" .. oldBodyPosX .. "  " .. posY)

        local shape2 = event:getShape2()
    elseif (collisionType == COLLISION_TYPE_ROAD_TOP) then
        local vx, vy = body1:getVelocity()
        print(vx .. vy)
        if vy > 0 then
            body1:setVelocity(vx, -vy)
        end
    elseif (collisionType == COLLISION_TYPE_DIAMOND) then
        score = score + DIAMOND_SCORE
        local shape2 = event:getShape2()
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

	--每次碰撞以后强制设置速度
	--body2:setVelocity(ccp(-MAP_MOVE_SPEED, 0))

    return false
end

function MainScene:onSeparate(event)
    local body1 = event:getBody1()   --地图body
    local body2 = event:getBody2()   --地图body

    local collisionType = body2:getCollisionType()
	--print("onSeparate collision_type: " .. collisionType)
	if (collisionType == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount - 1
		
		--离开所有的道路，恢复重力效果
		if (self.collisionRoadCount == 0) then
			body1:setForce(ccp(0, 0))
        end
    end

    return true
end

function MainScene:gameOver()
    self.world:stop()
	self.roleBody:setVelocity(ccp(0, 0))
	print("you lose!")
end

function MainScene:onEnter()
    self.world:start()
    
    scheduler.scheduleUpdateGlobal(function(dt)
        self:update(dt)
    end)
end

function MainScene:onExit()
    self.world:removeAllCollisionListeners()
end

return MainScene
