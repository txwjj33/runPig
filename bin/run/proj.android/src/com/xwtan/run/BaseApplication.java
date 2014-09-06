package com.xwtan.run;

import android.app.Application;

//import com.mrocker.push.PushManager;
import com.tendcloud.tenddata.TalkingDataGA;

public class BaseApplication extends Application {
	private String talkingDataAppID =  "97EFCFB9737C78FDFCF55D94C49BB2CA";
	private String talkingDataChannelID =  "360";
	
	@Override
	public void onCreate() {
		super.onCreate();
		//PushManager.startPushService(getApplicationContext());
		TalkingDataGA.sPlatformType = TalkingDataGA.PLATFORM_TYPE_COCOS2DX;
		TalkingDataGA.init(this, talkingDataAppID, talkingDataChannelID);
	}
	static {
        //System.loadLibrary("talkingdata");
    }
}
