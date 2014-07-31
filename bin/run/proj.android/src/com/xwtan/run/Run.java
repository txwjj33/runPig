/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.xwtan.run;

import org.cocos2dx.lib.Cocos2dxActivity;
//import com.pkag.m.MyMDListner;
//import com.pkag.m.MyMediaManager;

//import android.app.Activity；
import net.youmi.android.AdManager;
import net.youmi.android.spot.SpotDialogListener;
import net.youmi.android.spot.SpotManager;

import android.os.Bundle;
import android.util.Log;

public class Run extends Cocos2dxActivity {
	
	static private Run sInstance;
	
    public static Run getInstance() { return sInstance; }

    public static void setInstance(final Run instance) { sInstance = instance; }

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setInstance(this);
		
		AdManager.getInstance(this).init("6699b8ebfd92e055", "64956e39f0ed9461", true);
		SpotManager.getInstance(this).loadSpotAds();
	}
	
	@Override
    protected void onDestroy() {
            SpotManager.getInstance(this).unregisterSceenReceiver();
            super.onDestroy();
    }

    static {
    	System.loadLibrary("game");
    }
    
    static public void showSpotAd(){
    	if(SpotManager.getInstance(sInstance).checkLoadComplete()){
    		Log.d("Youmi", "checkLoadComplete, show ads!");
    		SpotManager.getInstance(sInstance).showSpotAds(sInstance, new SpotDialogListener() {
    		    @Override
    		    public void onShowSuccess() {
    		        Log.i("Youmi", "onShowSuccess");
    		    }

    		    @Override
    		    public void onShowFailed() {
    		        Log.i("Youmi", "onShowFailed");
    		    }
    		});
    	}
    	else{
    		Log.d("Youmi", "checkLoadComplete failed, not show ads!");
    	}
    	
    }
    
//    static public void onScreenADClick(){
//    	MyMediaManager.setListner(new MyMDListner() {
//			@Override
//			public void onMDShow() {
//				System.out.println("广告显示");
//			}
//			@Override
//			public void onMDClose() {
//				System.out.println("广告关闭");
//			}
//			@Override
//			public void onInstanll(int id) {
//				System.out.println("广告安装id："+id);
//			}
//			@Override
//			public void onMDLoadSuccess() {
//				System.out.println("广告加载成功");
//				//这里实现广告加载完成立即显示广告，更多用法可以查看开发文档的“方法调用时机”；
//				//具体参数参考开发文档参数说明：Context context,int type
//				MyMediaManager.show(Run.getInstance(),MyMediaManager.LEFT_TOP);
//			}
//			@Override
//			public void onMDExitInFinish() {
//				System.out.println("内部退出框退出按钮回调");
//			}
//			@Override
//			public void onMDExitOutFinish() {
//				System.out.println("外部退出框退出按钮回调");
//			}
//		});
//		
//		//请求广告
//		//具体参数参考开发文档参数说明：Context context,String cooId,String channelId
//		MyMediaManager.load(Run.getInstance(), "5b42cc6caef743e28eaf09c294e5d395", "m-appchina");
//    }
}
