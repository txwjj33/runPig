local scheduler = require("framework.scheduler")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

COLLISION_TYPE_BOTTOM_LINE = 0   --下面的线用来判定玩家死亡
COLLISION_TYPE_ROLE        = 1
COLLISION_TYPE_ROAD        = 2
COLLISION_TYPE_ITEM1  = 3
COLLISION_TYPE_ROAD_TOP  = 4
COLLISION_TYPE_ROAD_LEFT = 5

MAP_COUNT = 1

local MAP_ITEMS = 
{
    road = COLLISION_TYPE_ROAD,
    --item1 = COLLISION_TYPE_ITEM1,
    road_top = COLLISION_TYPE_ROAD_TOP,
    road_left = COLLISION_TYPE_ROAD_LEFT,
}

function MainScene:ctor()
    self.collisionRoadCount = 0

    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)

    local baseLayer = display.newLayer()
	baseLayer:setTouchEnabled(true)
	baseLayer:setTouchMode(kCCTouchesOneByOne)

    local startPos = 0
	self.m_pOldMapBody = self:addMapBody(startPos)
	self.m_pOldMap = self:addNewMap(startPos, self.m_pOldMapBody)

	local oldMapWidth = self.m_pOldMap:getContentSize().width + startPos
	print("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED)
	self.m_pNewMapBody = self:addMapBody(oldMapWidth)
	self.m_pNewMap = self:addNewMap(oldMapWidth, self.m_pNewMapBody)

	self:createRole(ccp(ROLE_POS_X, ROLE_POS_Y))
	self:addBottomLineShape()

    for k, v in pairs(MAP_ITEMS) do
        self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), COLLISION_TYPE_ROLE, v)
    end

    -- add debug node
    self.worldDebug = self.world:createDebugNode()
    self:addChild(self.worldDebug)
end

function MainScene:addNewMap(posX, body)
	local mapID = math.random(1, MAP_COUNT)
	print("create new map, id: %d", mapID)
    local mapPath = string.format("map%d.tmx", mapID)
	local map = CCTMXTiledMap:create(mapPath)
	map:setPosition(posX, 0)
    self:addChild(map)

    body:bind(map)

	for layerName, v in pairs(MAP_ITEMS) do
		local layer = map:layerNamed(layerName)
		local mapSize = map:getMapSize()
		for x = 0, mapSize.width - 1 do
			for y = 0, mapSize.height - 1 do
				local tile = layer:tileAt(ccp(x, y))
				if tile then
					local tileSize = tile:getContentSize()
					local pos = ccpAdd(ccp(tile:getPosition()), ccp(tileSize.width / 2, tileSize.height / 2))

                    local shape = nil
                    if v == COLLISION_TYPE_ROAD_TOP then
                        shape = body:addSegmentShape(
								ccp(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2), 
								ccp(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2), 1)
                        shape:setElasticity(1)
                    elseif v == COLLISION_TYPE_ROAD_LEFT then
                        --左边的弹性屏障，上下各留点空隙，
                        shape = body:addSegmentShape(
							    ccp(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2 + 3), 
							    ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2 - 3), 1)
                        shape:setElasticity(1)
                    elseif v == COLLISION_TYPE_ROAD then
                        shape = body:addSegmentShape(
								ccp(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2), 
								ccp(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2), 1)
                    else
                        local vertexes = CCPointArray:create(4)
					    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2))
					    vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2))
					    vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2))
					    vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2))

					    shape = body:addPolygonShape(vertexes)
                        shape:setFriction(0)
                        shape:setElasticity(0)
                    end

					shape:setCollisionType(v)
                end
            end
        end
    end

	return map
end

function MainScene:update()
    self.m_pOldMapBody:setPosition(self.m_pOldMapBody:getPositionX() - MAP_MOVE_SPEED * dt, 0)
    self.m_pNewMapBody:setPosition(self.m_pNewMapBody:getPositionX() - MAP_MOVE_SPEED * dt, 0)
    --self.m_pOldMapBody:setPosition(ccpSub(ccp(self.m_pOldMapBody:getPosition()), ccpMult(ccp(MAP_MOVE_SPEED, 0), dt)))
    --self.m_pNewMapBody:setPosition(ccpSub(ccp(self.m_pNewMapBody:getPosition()), ccpMult(ccp(MAP_MOVE_SPEED, 0), dt)))
    --body->p = cpvadd(body->p, cpvmult(cpv(-MAP_MOVE_SPEED, 0), dt));
	local oldMapWidth = self.m_pOldMap:getContentSize().width
	local oldBodyPos = self.m_pOldMapBody:getPositionX()
	--地图已出界，删除旧地图，添加新地图
	if (oldBodyPos <= - oldMapWidth) then
		self:removeOldMapAddNewMap()
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

	--创建新地图
	local newMapPosX = self.m_pOldMapBody:getPositionX() + self.m_pOldMap:getContentSize().width
	self.m_pNewMapBody = self:addMapBody(newMapPosX)
	self.m_pNewMap = self:addNewMap(newMapPosX, self.m_pNewMapBody)

	print("end create new map")
end

function MainScene:addMapBody(posX)
	local body = CCPhysicsBody:create(self.world, 1, 1)
    self.world:addBody(body)
	body:setPosition(ccp(posX, 0))
	--body:setVelocity(-MAP_MOVE_SPEED, 0)
	body:setForce(0, -GRAVITY)
	--body->position_func = updateBodyPostion;

	return body
end

function MainScene:createRole(pos)
	local layer = self.m_pOldMap:layerNamed("road")
	local tilePos = layer:positionAt(pos)

	local role = display.newSprite("grapes.png")
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

--bool GameLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
--{
--	if (collisionRoadCount > 0)
--	{
--		m_pRole->getCPBody()->v = cpv(0, ROLE_JUMP_SPEED);
--	}

--	return true;
--}


function MainScene:addBottomLineShape()
    local bottomWallBody = self.world:createBoxBody(0, WIN_WIDTH, 1)
    bottomWallBody:setFriction(0)
    bottomWallBody:setElasticity(0)
    bottomWallBody:setPosition(0, 0)
    bottomWallBody:setCollisionType(COLLISION_TYPE_BOTTOM_LINE)
end

function MainScene:onCollisionListener(phase, event)
    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body
    if phase == "begin" then
        return self:onCollisionBegin(event)
    elseif phase == "preSolve" then
        return true
    elseif phase == "postSolve" then
        return true
    elseif phase == "separate" then
        return self:onSeparate(event)
    end
end

function MainScene:onCollisionBegin(event)
    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body
    local collisionType = body2:getCollisionType()
	print("begin collision collision_type: " .. collisionType)
	if (collisionType == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount + 1
		--DLOG("begin collision v_x:%1.1f v_y:%1.1f, collisionRoadCount: %d",b->body->v.x,b->body->v.y, collisionRoadCount); 

		--给role一个力抵消重力
        body1:setForce(ccp(0, -GRAVITY))
        body1:setVelocity(ccp(0, 0))
    elseif (collisionType == COLLISION_TYPE_ITEM1) then
        self:gameOver()
    elseif (collisionType == COLLISION_TYPE_BOTTOM_LINE) then
        self:gameOver()
    elseif (collisionType == COLLISION_TYPE_ROAD_LEFT) then
        self:gameOver()
    end

	--每次碰撞以后强制设置速度
	body2:setVelocity(ccp(0, 0))

    return true
end

function MainScene:onSeparate(event)
    local body1 = event:getBody1()   --角色body
    local body2 = event:getBody2()   --地图body
    local collisionType = body2:getCollisionType()
	print("onSeparate collision_type: " .. collisionType)
	if (collisionType == COLLISION_TYPE_ROAD) then
		self.collisionRoadCount = self.collisionRoadCount - 1
		--DLOG("begin collision v_x:%1.1f v_y:%1.1f, collisionRoadCount: %d",b->body->v.x,b->body->v.y, collisionRoadCount); 

		--离开所有的道路，恢复重力效果
		if (self.collisionRoadCount == 0) then
			body1:setForce(ccp(0, 0))
        end
    end

    return true
end

function MainScene:gameOver()
    MAP_MOVE_SPEED = 0
	self.roleBody:setVelocity(ccp(0, 0))
	print("you lose!")
end

function MainScene:onEnter()
    self.world:start()
    
    scheduler.scheduleUpdateGlobal(function()
        self:update()
    end)
end

function MainScene:onExit()
    self.world:removeAllCollisionListeners()
end

return MainScene
