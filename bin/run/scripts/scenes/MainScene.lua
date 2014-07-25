local scheduler = require("framework.scheduler")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local GRAVITY         = -0
local WALL_THICKNESS  = 64
local WALL_FRICTION   = 1.0
local WALL_ELASTICITY = 0.5

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

local mapShapes = {}

--region File1.lua
--local bottomWallSprite = display.newSprite("#Wall.png")
--bottomWallSprite:setScaleX(display.width / WALL_THICKNESS)
--self:addChild(bottomWallSprite)
--local bottomWallBody = self.world:createBoxBody(0, display.width, WALL_THICKNESS)
--bottomWallBody:setFriction(WALL_FRICTION)
--bottomWallBody:setElasticity(WALL_ELASTICITY)
--bottomWallBody:bind(bottomWallSprite)
--bottomWallBody:setPosition(display.cx, display.bottom + WALL_THICKNESS / 2)


--endregion

function MainScene:ctor()
    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)

    local baseLayer = display.newLayer()
	baseLayer:setTouchEnabled(true)
	baseLayer:setTouchMode(kCCTouchesOneByOne)
	baseLayer:setTouchPriority(1)

	self.m_pOldMapBody = self:createMapBody(0)
	self.m_pOldMap = self:createNewMap(0, self.m_pOldMapBody)
	self:addChild(self.m_pOldMap)

	--local oldMapWidth = self.m_pOldMap:getContentSize().width
	--print("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED)
	--self.m_pNewMapBody = self:createMapBody(oldMapWidth)
	--self.m_pNewMap = self:createNewMap(oldMapWidth, self.m_pNewMapBody)
	--self:addChild(self.m_pNewMap)

	--self:createRole(ccp(ROLE_POS_X, ROLE_POS_Y))

	--self:addBottomLineShape()

    for k, v in pairs(MAP_ITEMS) do
        self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), COLLISION_TYPE_ROLE, v)
    end

    -- add debug node
    self.worldDebug = self.world:createDebugNode()
    self:addChild(self.worldDebug)
end

function MainScene:createFruit()
    local fruitName = FRUITS[math.random(1, #FRUITS)]

    local fruitBody = nil
    local physicsData = self.fruitsPhysics:get(fruitName)
    for i, shape in ipairs(physicsData.shapes) do
        local polygons = shape.polygons

        for n, v in ipairs(polygons) do
            local vertexes = CCPointArray:create(#v / 2)
            for j = 1, #v, 2 do
                vertexes:add(cc.p(v[j], v[j+1]))
            end

            if not fruitBody then
                fruitBody = self.world:createPolygonBody(shape.mass, vertexes)
            else
                fruitBody:addPolygonShape(vertexes)
            end
        end
        fruitBody:setFriction(shape.friction)
        fruitBody:setElasticity(shape.elasticity)
        fruitBody:setCollisionType(shape.collision_type)
    end

    local fruitResName = fruitName .. ".png"
    local fruit = display.newSprite(fruitResName)
    self:addChild(fruit)

    fruitBody:bind(fruit)
    fruitBody:setPosition(math.random(display.width-100) + 50, display.height+100)
end


function MainScene:createNewMap(posX, body)
	local mapID = math.random(1, MAP_COUNT)
	print("create new map, id: %d", mapID)
    local mapPath = string.format("map%d.tmx", mapID)
	local map = CCTMXTiledMap:create(mapPath)
	map:setPosition(0, 0)
    --self:addChild(map)

    local shapes = {}
    mapShapes[body] = shapes

	for layerName, v in pairs(MAP_ITEMS) do
		local layer = map:layerNamed(layerName)
		local mapSize = map:getMapSize()
		for x = 0, mapSize.width - 1 do
			for y = 0, mapSize.height - 1 do
				local tile = layer:tileAt(ccp(x, y))
				if tile then
					--local tilePos = tile:getPosition()
					local tileSize = tile:getContentSize()
					local pos = ccpAdd(ccp(tile:getPosition()), ccp(tileSize.width / 2, tileSize.height / 2))

                    local vertexes = CCPointArray:create(4)
					vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2 +50))
					vertexes:add(cc.p(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2 +50))
					vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2 +50))
					vertexes:add(cc.p(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2 +50))

					local shape = self.world:createPolygonBody(1, vertexes)
                    shape:setFriction(0)
                    shape:setElasticity(0)

                    --shape:bind(tile)
                    --shape:setPosition(pos)
                    table.insert(shapes, shape)

                    shape:setCollisionType(COLLISION_TYPE_ROAD)

					--if (v == COLLISION_TYPE_ROAD_TOP) or (v == COLLISION_TYPE_ROAD_LEFT) then
     --                   shape:setCollisionType(COLLISION_TYPE_ROAD)

					--	local shape1 = NULL;
					--	if (g_mapItemsCollisionType[i] == COLLISION_TYPE_ROAD_TOP)
					--	{
					--		shape1 = cpSegmentShapeNew(body, 
					--			cpv(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2), 
					--			cpv(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2), 0);
					--	}
					--	else
					--	{
					--		//左边的弹性屏障，上下各留点空隙，
					--		shape1 = cpSegmentShapeNew(body, 
					--			cpv(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2 + 3), 
					--			cpv(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2 - 3), 0);
					--	}
							
					--	shape1->e = 1.f; 
					--	shape1->u = 0.f;
					--	shape1->collision_type = g_mapItemsCollisionType[i];
					--	cpSpaceAddShape(m_pSpace, shape1);
					--	shapes.push_back(shape1);
					--}
					--else
					--{
					--	shape->collision_type = g_mapItemsCollisionType[i];
					--}
                end
            end
        end
    end

	return map
end

--void GameLayer::update(float delta)
--{
--	// Should use a fixed size step based on the animation interval.
--	int steps = 2;
--	float dt = CCDirector::sharedDirector()->getAnimationInterval()/(float)steps;
	 
--	for(int i = 0; i < steps; i++)
--	{
--		cpSpaceStep(m_pSpace, dt);
--	}

--	float oldMapWidth = self.m_pOldMap->getContentSize().width;
--	cpVect oldBodyPos = self.self.m_pOldMapBody->p;
--	//地图已出界，删除旧地图，添加新地图
--	if (oldBodyPos.x <= - oldMapWidth)
--	{
--		removeOldMapAddNewMap();
--	}
--	else
--	{
--		self.m_pNewMap->setPosition(self.self.m_pNewMapBody->p.x, 0);
--		self.m_pOldMap->setPosition(self.self.m_pOldMapBody->p.x, 0);
--	}
--}

--void GameLayer::removeOldMapAddNewMap()
--{
--	DLOG("start remove old");

--	//移除旧地图
--	self.m_pOldMap->removeFromParent();
--	vector<cpShape*> shapes = m_shapesMap[self.self.m_pOldMapBody];
--	for (vector<cpShape*>::iterator iter = shapes.begin(); iter != shapes.end(); ++iter)
--	{
--		cpSpaceRemoveShape(m_pSpace, *iter);
--		cpShapeFree(*iter);
--	}
--	shapes.clear();
--	m_shapesMap.erase(self.self.m_pOldMapBody);
	
--	cpSpaceRemoveBody(m_pSpace, self.self.m_pOldMapBody);
--	cpBodyFree(self.self.m_pOldMapBody);

--	self.m_pNewMap->setPosition(self.self.m_pNewMapBody->p.x, 0);

--	//将之前的新地图赋值给旧地图
--	self.m_pOldMap = self.m_pNewMap;
--	self.self.m_pOldMapBody = self.self.m_pNewMapBody;

--	//创建新地图
--	float newMapPosX = self.self.m_pOldMapBody->p.x + self.m_pOldMap->getContentSize().width;
--	self.self.m_pNewMapBody = createMapBody(newMapPosX);
--	self.m_pNewMap = createNewMap(newMapPosX, self.self.m_pNewMapBody);
--	addChild(self.m_pNewMap);	

--	DLOG("end create new map");
--}

function MainScene:createMapBody(posX)
	--cpBody *body = cpBodyNew(INFINITY, INFINITY);
	--//cpBody *body = cpBodyNewStatic();
	--body->p = cpv(posX, 0);
	--//body->v = cpv(-MAP_MOVE_SPEED, 0);
	--body->f = cpvneg(m_pSpace->gravity);
	--body->position_func = updateBodyPostion;
	--cpSpaceAddBody(m_pSpace, body);

	--return body;
    return 1
end

--CCPhysicsSprite* GameLayer::createRole(const CCPoint& pos)
--{
--	CCTMXLayer *layer = self.m_pOldMap->layerNamed(g_mapItems[0]);
--	CCPoint tilePos = layer->positionAt(pos);

--	CCTexture2D *roleTexture = CCTextureCache::sharedTextureCache()->addImage("images/grossini.png");
--	CCSize roleSize = roleTexture->getContentSize();
--	CCPoint rolePos = tilePos + roleSize / 2;

--	int num = 4;
--	cpVect verts[] = {
--		cpv(- roleSize.width / 2, - roleSize.height / 2),
--		cpv(- roleSize.width / 2, + roleSize.height / 2),
--		cpv(+ roleSize.width / 2, + roleSize.height / 2),
--		cpv(+ roleSize.width / 2, - roleSize.height / 2),
--	};

--	cpBody *body = cpBodyNew(1.f, cpMomentForPoly(1.0f, num, verts, cpvzero));
--	body->p = cpv(rolePos.x, rolePos.y);
--	cpSpaceAddBody(m_pSpace, body);

--	cpShape* shape = cpPolyShapeNew(body, num, verts, cpvzero);
--	shape->e = 1.f; 
--	shape->u = 0.f;
--	shape->collision_type = COLLISION_TYPE_ROLE;
--	cpSpaceAddShape(m_pSpace, shape);

--	m_pRole = CCPhysicsSprite::createWithTexture(roleTexture);
--	addChild(m_pRole);

--	m_pRole->setCPBody(body);
--	m_pRole->setPosition(rolePos);

--	return m_pRole;
--}

--bool GameLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
--{
--	if (collisionRoadCount > 0)
--	{
--		m_pRole->getCPBody()->v = cpv(0, ROLE_JUMP_SPEED);
--	}

--	return true;
--}


--void GameLayer::addBottomLineShape()
--{
--	cpShape* shape = cpSegmentShapeNew(m_pSpace->staticBody, cpvzero, cpv(WIN_WIDTH, 0), 0);
--	shape->e = 0.f; 
--	shape->u = 0.f;
--	shape->collision_type = COLLISION_TYPE_BOTTOM_LINE;
--	cpSpaceAddShape(m_pSpace, shape);
--}

function MainScene:onCollisionListener(phase, event)
    if phase == "begin" then
        print("collision begin")
        local body1 = event:getBody1()
        local body2 = event:getBody2()
        body1:getNode():removeFromParentAndCleanup(true)
        body2:getNode():removeFromParentAndCleanup(true)
        self.world:removeBody(body1, true)
        self.world:removeBody(body2, true)
    elseif phase == "preSolve" then
        print("collision preSolve")
    elseif phase == "postSolve" then
        print("collision postSolve")
    elseif phase == "separate" then
        print("collision separate")
    end

end

function MainScene:onEnter()
    self.world:start()
    --scheduler.scheduleGlobal(function()
    --    self:createFruit()
    --end, 1.0)
    self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), 1, 2)
end

function MainScene:onExit()
    self.world:removeAllCollisionListeners()
end

return MainScene
