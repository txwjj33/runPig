#include "cocos2d.h"
#include "C2DXShareSDK/C2DXShareSDK.h"
#include "LuaExport.h"

using namespace std;
using namespace cocos2d;
using namespace cn::sharesdk;

void shareResultHandler(C2DXResponseState state, C2DXPlatType platType, CCDictionary *shareInfo, CCDictionary *error)
{
	switch (state) {
	case C2DXResponseStateSuccess:
		CCLog("分享成功");
		break;
	case C2DXResponseStateFail:
		CCLog("分享失败");
		break;
	default:
		break;
	}
}

void LuaExport::showShareMenu(const char *content, const char* image, const char* title, const char* des, const char* url)
{
	CCDictionary *dic = CCDictionary::create();
	dic->setObject(CCString::create(content), "content");
	string path = CCFileUtils::sharedFileUtils()->fullPathForFilename(image);
	CCLog("path:%s", path.c_str());
	dic->setObject(CCString::create(image), "image");
	dic->setObject(CCString::create(title), "title");
	dic->setObject(CCString::create(des), "description");
	dic->setObject(CCString::create(url), "url");
	dic->setObject(CCString::createWithFormat("%d", C2DXContentTypeNews), "type");
	dic->setObject(CCString::create("http://sharesdk.cn"), "siteUrl");
	dic->setObject(CCString::create("ShareSDK"), "site");
	dic->setObject(CCString::create("http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"), "musicUrl");
	dic->setObject(CCString::create("extInfo"), "extInfo");

	C2DXShareSDK::showShareMenu(NULL, dic, CCPointMake(100, 100), C2DXMenuArrowDirectionUp, shareResultHandler);
}
