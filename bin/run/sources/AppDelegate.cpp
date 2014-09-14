
#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "support/CCNotificationCenter.h"
#include "CCLuaEngine.h"
#include <string>
#include "LuaSpine.h"
#include "C2DXShareSDK/C2DXShareSDK.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "LuaTalkingData.h"
#include "TalkingData.h"
#endif

static const string shareAppKey = "27707843bfb0";

using namespace std;
using namespace cocos2d;
using namespace CocosDenshion;
using namespace cn::sharesdk;

AppDelegate::AppDelegate()
{
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
}

void authResultHandler(C2DXResponseState state, C2DXPlatType platType, CCDictionary *error)
{
	switch (state) {
	case C2DXResponseStateSuccess:
		CCLog("授权成功");
		break;
	case C2DXResponseStateFail:
		CCLog("授权失败");
		break;
	default:
		break;
	}
}

void getUserResultHandler(C2DXResponseState state, C2DXPlatType platType, CCDictionary *userInfo, CCDictionary *error)
{
	if (state == C2DXResponseStateSuccess)
	{
		//输出用户信息
		CCArray *allKeys = userInfo -> allKeys();
		for (int i = 0; i < allKeys -> count(); i++)
		{
			CCString *key = (CCString *)allKeys -> objectAtIndex(i);
			CCObject *obj = userInfo -> objectForKey(key -> getCString());

			CCLog("key = %s", key -> getCString());
			if (dynamic_cast<CCString *>(obj))
			{
				CCLog("value = %s", dynamic_cast<CCString *>(obj) -> getCString());
			}
			else if (dynamic_cast<CCInteger *>(obj))
			{
				CCLog("value = %d", dynamic_cast<CCInteger *>(obj) -> getValue());
			}
			else if (dynamic_cast<CCDouble *>(obj))
			{
				CCLog("value = %f", dynamic_cast<CCDouble *>(obj) -> getValue());
			}
		}
	}
}

bool AppDelegate::applicationDidFinishLaunching()
{
	 /**
     注册SDK应用，此应用请到http://mob.com/中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
     C2DXShareSDK::open(CCString::create(shareAppKey), false);
                /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
    **/ 
    CCDictionary *sinaConfigDict = CCDictionary::create();
    sinaConfigDict -> setObject(CCString::create("568898243"), "app_key");
    sinaConfigDict -> setObject(CCString::create("38a4f8204cc784f81f9f0daaf31e02e3"), "app_secret");
    sinaConfigDict -> setObject(CCString::create("http://www.sharesdk.cn"), "redirect_uri");
    C2DXShareSDK::setPlatformConfig(C2DXPlatTypeSinaWeibo, sinaConfigDict);

	CCDictionary *weixinConfigDict = CCDictionary::create();
	weixinConfigDict -> setObject(CCString::create("568898243"), "app_id");
	C2DXShareSDK::setPlatformConfig(C2DXPlatTypeWeixiSession, weixinConfigDict);
	C2DXShareSDK::setPlatformConfig(C2DXPlatTypeWeixiTimeline, weixinConfigDict);

	C2DXShareSDK::authorize(C2DXPlatTypeSinaWeibo, authResultHandler);
	C2DXShareSDK::authorize(C2DXPlatTypeWeixiSession, authResultHandler);
	C2DXShareSDK::authorize(C2DXPlatTypeWeixiTimeline, authResultHandler);

	C2DXShareSDK::getUserInfo(C2DXPlatTypeSinaWeibo, getUserResultHandler);
	C2DXShareSDK::getUserInfo(C2DXPlatTypeWeixiSession, getUserResultHandler);
	C2DXShareSDK::getUserInfo(C2DXPlatTypeWeixiTimeline, getUserResultHandler);

    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
    pDirector->setProjection(kCCDirectorProjection2D);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    // register lua engine
    CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *m_state = pStack->getLuaState();
	tolua_spine_open(m_state);

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    // load framework
    pStack->loadChunksFromZIP("res/framework_precompiled.zip");

	tolua_talkingdata_open(m_state);
	CCLog("init talking data");
	TDCCAccount* account = TDCCAccount::setAccount(TDCCTalkingDataGA::getDeviceId());
	account->setAccountType(TDCCAccount::kAccountAnonymous);

    // set script path
    string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("scripts/main.lua");
#else
    // load framework
    if (m_projectConfig.isLoadPrecompiledFramework())
    {
        const string precompiledFrameworkPath = SimulatorConfig::sharedDefaults()->getPrecompiledFrameworkPath();
        pStack->loadChunksFromZIP(precompiledFrameworkPath.c_str());
    }

    // set script path
    string path = CCFileUtils::sharedFileUtils()->fullPathForFilename(m_projectConfig.getScriptFileRealPath().c_str());
#endif

    size_t pos;
    while ((pos = path.find_first_of("\\")) != std::string::npos)
    {
        path.replace(pos, 1, "/");
    }
    size_t p = path.find_last_of("/\\");
    if (p != path.npos)
    {
        const string dir = path.substr(0, p);
        pStack->addSearchPath(dir.c_str());

        p = dir.find_last_of("/\\");
        if (p != dir.npos)
        {
            pStack->addSearchPath(dir.substr(0, p).c_str());
        }
    }

    string env = "__LUA_STARTUP_FILE__=\"";
    env.append(path);
    env.append("\"");
    pEngine->executeString(env.c_str());

    CCLOG("------------------------------------------------");
    CCLOG("LOAD LUA FILE: %s", path.c_str());
    CCLOG("------------------------------------------------");
    pEngine->executeScriptFile(path.c_str());

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();
    CCDirector::sharedDirector()->pause();
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
    SimpleAudioEngine::sharedEngine()->pauseAllEffects();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_BACKGROUND_EVENT");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();
    CCDirector::sharedDirector()->resume();
    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
    SimpleAudioEngine::sharedEngine()->resumeAllEffects();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_FOREGROUND_EVENT");
}

void AppDelegate::setProjectConfig(const ProjectConfig& config)
{
    m_projectConfig = config;
}
