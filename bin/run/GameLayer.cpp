#include "GameLayer.h"
#include <map>
#include <string>
#include "Random.h"
#include "GameConf.h"
#include "GameBasePCH.h"
#include "VisibleRect.h"
#include "Settings.h"
#include "UIHelper.h"

using std::map;
using std::string;

#define BOTTOM_LINE_COLLISION_TYPE 0   //下面的线用来判定玩家死亡
#define ROLE_COLLISION_TYPE 1
#define ROAD_COLLISION_TYPE 2
#define ITEM1_COLLISION_TYPE 3
#define ROAD_TOP_COLLISION_TYPE 4
#define ROAD_LEFT_COLLISION_TYPE 5

#define MAP_COUNT 1

const char *g_mapItems[] = 
{
	"road",
	//"item1",
	"road_top",
	"road_left",
};

int g_mapItemsCollisionType[] = 
{
	ROAD_COLLISION_TYPE,
	//ITEM1_COLLISION_TYPE,
	ROAD_TOP_COLLISION_TYPE,
	ROAD_LEFT_COLLISION_TYPE,
};

enum {
	Z_PHYSICS_DEBUG = 100,
};

static int collisionRoadCount = 0;

class GameOverDialog: public AlertDialogDelegate
{
	virtual void onAlertDialogFinished(AlertDialog* dialog, int clickedButtonIndex)
	{
		if (clickedButtonIndex == 0)
		{
			DLOG("restart");
		}
	}

};

void gameOver(cpBody *role)
{
	//MAP_MOVE_SPEED = 0;
	//role->v = cpv(0, 0);
	DLOG("you lose!");

	//Baina::UIHelper::showPromptDialog(1, new GameOverDialog, "重新开始游戏？");
}

cpBool beginCollision(cpArbiter *arb, cpSpace *space, void *data)
{  
	//获取碰撞的shape，a代表用cpSpaceAddCollisionHandler添加碰撞回调时的碰撞对象类型a，b亦然  
	CP_ARBITER_GET_SHAPES(arb, a, b);  
	//DLOG("begin collision collision_type: %d",b->collision_type); 
	switch (b->collision_type)
	{
	case ROAD_COLLISION_TYPE:
		{
			++collisionRoadCount;
			//DLOG("begin collision v_x:%1.1f v_y:%1.1f, collisionRoadCount: %d",b->body->v.x,b->body->v.y, collisionRoadCount); 

			cpVect speed = b->body->v;
			if (abs(speed.x - 0.f) < 0.1 && speed.y < 0)  //从上面撞击道路，说明是跳起落下
			{
				//给role一个力抵消重力
				a->body->f = cpvneg(space->gravity);
				a->body->v = cpv(0, 0);

			}
		}
		break;
	case ITEM1_COLLISION_TYPE:
		{
			gameOver(a->body);
		}
		break;
	case BOTTOM_LINE_COLLISION_TYPE:
		{
			gameOver(a->body);
		}
		break;
	case ROAD_LEFT_COLLISION_TYPE:
		{
			gameOver(a->body);
		}
		break;
	default:
		break;
	}

	//每次碰撞以后强制设置速度为0
	b->body->v = cpv(0, 0);

	//设置物理空间在结束当前动作时的回调函数，用于安全释放对象，此调用只会在完成当前动作后调用一次  
	//cpSpaceAddPostStepCallback(space,(cpPostStepFunc)postStepRemove,a,NULL);  

	//返回值为false时，碰撞对象会只在初次碰撞时执行回调函数，两个碰撞对象会重叠在一起  
	return true;  
}  

void whenSeparate(cpArbiter *arb, cpSpace *space, void *data)
{  
	//获取碰撞的shape，a代表用cpSpaceAddCollisionHandler添加碰撞回调时的碰撞对象类型a，b亦然  
	CP_ARBITER_GET_SHAPES(arb, a, b);  
	//DLOG("whenSeparate collision_type: %d",b->collision_type); 
	switch (b->collision_type)
	{
	case ROAD_COLLISION_TYPE:
		{
			--collisionRoadCount;
			//离开所有的道路，恢复重力效果
			if (collisionRoadCount == 0)
			{
				a->body->f = cpvzero;
			}
			//DLOG("whenSeparate v_x:%1.1f v_y:%1.1f, collisionRoadCount: %d",b->body->v.x,b->body->v.y, collisionRoadCount); 
		}


	default:
		break;
	}

}

void updateBodyPostion(cpBody *body, cpFloat dt)
{
	body->p = cpvadd(body->p, cpvmult(cpv(-MAP_MOVE_SPEED, 0), dt));
}

GameLayer::GameLayer()
	: m_pSpace(0)
	, m_pOldMap(NULL)
	, m_pNewMap(NULL)
{
	
}

GameLayer::~GameLayer()
{
	cpSpaceFree( m_pSpace );
}

CCScene* GameLayer::createScene()
{
    CCScene *scene = CCScene::create();
    scene->addChild(create());
    return scene;
}

bool GameLayer::init()
{
    if (!CCLayer::init())
    {
        return false;
    }

	initGameConf();

	setTouchEnabled(true);
	setTouchMode(kCCTouchesOneByOne);
	setTouchPriority(1);

	m_pSpace = cpSpaceNew();
	m_pSpace->gravity = cpv(0, GRAVITY);

	m_pOldMapBody = createMapBody(0.f);
	m_pOldMap = createNewMap(0.f, m_pOldMapBody);
	addChild(m_pOldMap);

	float oldMapWidth = m_pOldMap->getContentSize().width;
	DLOG("width :%f, needTime: %f", oldMapWidth, oldMapWidth / MAP_MOVE_SPEED);
	m_pNewMapBody = createMapBody(oldMapWidth);
	m_pNewMap = createNewMap(oldMapWidth, m_pNewMapBody);
	addChild(m_pNewMap);

	createRole(ccp(ROLE_POS_X, ROLE_POS_Y));

	addBottomLineShape();

	int mapItemsCount = sizeof(g_mapItemsCollisionType) / sizeof(g_mapItemsCollisionType[0]);
	for (int i = 0; i != mapItemsCount; ++i)
	{
		cpSpaceAddCollisionHandler(m_pSpace, ROLE_COLLISION_TYPE, g_mapItemsCollisionType[i], 
			beginCollision, NULL, NULL, whenSeparate, NULL); 
	}
	cpSpaceAddCollisionHandler(m_pSpace, ROLE_COLLISION_TYPE, BOTTOM_LINE_COLLISION_TYPE, 
		beginCollision, NULL, NULL, whenSeparate, NULL); 

	scheduleUpdate();

	// Physics debug layer
	m_pDebugLayer = CCPhysicsDebugNode::create(m_pSpace);
	this->addChild(m_pDebugLayer, Z_PHYSICS_DEBUG);

    return true;
}

CCTMXTiledMap* GameLayer::createNewMap(float posX, cpBody* body)
{
	int mapID = Random::Rand(MAP_COUNT);
	DLOG("create new map, id: %d", mapID);
	char mapPath[64];
	sprintf(mapPath, "images/canNotPackage/map%d.tmx", mapID);
	CCTMXTiledMap *map = CCTMXTiledMap::create(mapPath);
	map->setPosition(posX, 0);

	vector<cpShape*> shapes;

	int mapItemsCount = sizeof(g_mapItems) / sizeof(g_mapItems[0]);
	for (int i = 0; i != mapItemsCount; ++i)
	{
		const char *layerName = g_mapItems[i];
		CCTMXLayer *layer = map->layerNamed(layerName);
		CCSize mapSize = map->getMapSize();
		for (int x = 0; x != mapSize.width; ++x)
		{
			for (int y = 0; y != mapSize.height; ++y)
			{
				CCSprite *tile = layer->tileAt(ccp(x, y));
				if (tile != 0)
				{
					CCPoint tilePos = tile->getPosition();
					CCSize tileSize = tile->getContentSize();
					CCPoint pos = tilePos + ccp(tileSize.width / 2, tileSize.height / 2);

					int num = 4;
					cpVect verts[] = {
						cpv(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2),
						cpv(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2),
						cpv(pos.x + tileSize.width / 2, pos.y + tileSize.height / 2),
						cpv(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2),
					};

					cpShape* shape = cpPolyShapeNew(body, num, verts, cpv(0, 0));
					shape->e = 0.f; 
					shape->u = 0.f;
					cpSpaceAddShape(m_pSpace, shape);
					shapes.push_back(shape);

					if (g_mapItemsCollisionType[i] == ROAD_TOP_COLLISION_TYPE || g_mapItemsCollisionType[i] == ROAD_LEFT_COLLISION_TYPE)
					{
						shape->collision_type = ROAD_COLLISION_TYPE;

						cpShape* shape1 = NULL;
						if (g_mapItemsCollisionType[i] == ROAD_TOP_COLLISION_TYPE)
						{
							shape1 = cpSegmentShapeNew(body, 
								cpv(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2), 
								cpv(pos.x + tileSize.width / 2, pos.y - tileSize.height / 2), 0);
						}
						else
						{
							//左边的弹性屏障，上下各留点空隙，
							shape1 = cpSegmentShapeNew(body, 
								cpv(pos.x - tileSize.width / 2, pos.y - tileSize.height / 2 + 3), 
								cpv(pos.x - tileSize.width / 2, pos.y + tileSize.height / 2 - 3), 0);
						}
							
						shape1->e = 1.f; 
						shape1->u = 0.f;
						shape1->collision_type = g_mapItemsCollisionType[i];
						cpSpaceAddShape(m_pSpace, shape1);
						shapes.push_back(shape1);
					}
					else
					{
						shape->collision_type = g_mapItemsCollisionType[i];
					}
				}
			}
		}
	}

	m_shapesMap.insert(make_pair(body, shapes));

	return map;
}

void GameLayer::update(float delta)
{
	// Should use a fixed size step based on the animation interval.
	int steps = 2;
	float dt = CCDirector::sharedDirector()->getAnimationInterval()/(float)steps;
	 
	for(int i = 0; i < steps; i++)
	{
		cpSpaceStep(m_pSpace, dt);
	}

	float oldMapWidth = m_pOldMap->getContentSize().width;
	cpVect oldBodyPos = m_pOldMapBody->p;
	//地图已出界，删除旧地图，添加新地图
	if (oldBodyPos.x <= - oldMapWidth)
	{
		removeOldMapAddNewMap();
	}
	else
	{
		m_pNewMap->setPosition(m_pNewMapBody->p.x, 0);
		m_pOldMap->setPosition(m_pOldMapBody->p.x, 0);
	}
}

void GameLayer::removeOldMapAddNewMap()
{
	DLOG("start remove old");

	//移除旧地图
	m_pOldMap->removeFromParent();
	vector<cpShape*> shapes = m_shapesMap[m_pOldMapBody];
	for (vector<cpShape*>::iterator iter = shapes.begin(); iter != shapes.end(); ++iter)
	{
		cpSpaceRemoveShape(m_pSpace, *iter);
		cpShapeFree(*iter);
	}
	shapes.clear();
	m_shapesMap.erase(m_pOldMapBody);
	
	cpSpaceRemoveBody(m_pSpace, m_pOldMapBody);
	cpBodyFree(m_pOldMapBody);

	m_pNewMap->setPosition(m_pNewMapBody->p.x, 0);

	//将之前的新地图赋值给旧地图
	m_pOldMap = m_pNewMap;
	m_pOldMapBody = m_pNewMapBody;

	//创建新地图
	float newMapPosX = m_pOldMapBody->p.x + m_pOldMap->getContentSize().width;
	m_pNewMapBody = createMapBody(newMapPosX);
	m_pNewMap = createNewMap(newMapPosX, m_pNewMapBody);
	addChild(m_pNewMap);	

	DLOG("end create new map");
}

cpBody * GameLayer::createMapBody(float posX)
{
	cpBody *body = cpBodyNew(INFINITY, INFINITY);
	//cpBody *body = cpBodyNewStatic();
	body->p = cpv(posX, 0);
	//body->v = cpv(-MAP_MOVE_SPEED, 0);
	body->f = cpvneg(m_pSpace->gravity);
	body->position_func = updateBodyPostion;
	cpSpaceAddBody(m_pSpace, body);

	return body;
}

CCPhysicsSprite* GameLayer::createRole(const CCPoint& pos)
{
	CCTMXLayer *layer = m_pOldMap->layerNamed(g_mapItems[0]);
	CCPoint tilePos = layer->positionAt(pos);

	CCTexture2D *roleTexture = CCTextureCache::sharedTextureCache()->addImage("images/grossini.png");
	CCSize roleSize = roleTexture->getContentSize();
	CCPoint rolePos = tilePos + roleSize / 2;

	int num = 4;
	cpVect verts[] = {
		cpv(- roleSize.width / 2, - roleSize.height / 2),
		cpv(- roleSize.width / 2, + roleSize.height / 2),
		cpv(+ roleSize.width / 2, + roleSize.height / 2),
		cpv(+ roleSize.width / 2, - roleSize.height / 2),
	};

	cpBody *body = cpBodyNew(1.f, cpMomentForPoly(1.0f, num, verts, cpvzero));
	body->p = cpv(rolePos.x, rolePos.y);
	cpSpaceAddBody(m_pSpace, body);

	cpShape* shape = cpPolyShapeNew(body, num, verts, cpvzero);
	shape->e = 1.f; 
	shape->u = 0.f;
	shape->collision_type = ROLE_COLLISION_TYPE;
	cpSpaceAddShape(m_pSpace, shape);

	m_pRole = CCPhysicsSprite::createWithTexture(roleTexture);
	addChild(m_pRole);

	m_pRole->setCPBody(body);
	m_pRole->setPosition(rolePos);

	return m_pRole;
}

bool GameLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	if (collisionRoadCount > 0)
	{
		m_pRole->getCPBody()->v = cpv(0, ROLE_JUMP_SPEED);
	}

	return true;
}

int getConf(const char *name, int defaultValue)
{
	int value = Settings::GetDefaultSettings()->GetValue(name, defaultValue);
	if(defaultValue == value)
	{
		Settings::GetDefaultSettings()->SetValue(name, defaultValue);
	}
	return value;
}

void GameLayer::initGameConf()
{
	MAP_MOVE_SPEED = getConf("MAP_MOVE_SPEED", 400);
	ROLE_JUMP_SPEED = getConf("ROLE_JUMP_SPEED", 200);
	GRAVITY = getConf("GRAVITY", -100);

	ROLE_POS_X = getConf("ROLE_POS_X", 5);
	ROLE_POS_Y = getConf("ROLE_POS_Y", 3);
}

void GameLayer::addBottomLineShape()
{
	cpShape* shape = cpSegmentShapeNew(m_pSpace->staticBody, cpvzero, cpv(WIN_WIDTH, 0), 0);
	shape->e = 0.f; 
	shape->u = 0.f;
	shape->collision_type = BOTTOM_LINE_COLLISION_TYPE;
	cpSpaceAddShape(m_pSpace, shape);
}