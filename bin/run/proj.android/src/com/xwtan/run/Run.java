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
import org.cocos2dx.lib.Cocos2dxHelper;

import cn.sharesdk.ShareSDKUtils;

import com.adsmogo.adapters.AdsMogoCustomEventPlatformEnum;
import com.adsmogo.adview.AdsMogoLayout;
import com.adsmogo.controller.listener.AdsMogoListener;
import com.adsmogo.interstitial.AdsMogoInterstitialListener;
import com.adsmogo.interstitial.AdsMogoInterstitialManager;
import com.tendcloud.tenddata.TalkingDataGA;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.tendcloud.tenddata.TalkingDataGA;

public class Run extends Cocos2dxActivity {
	static private Run sInstance;
	
	//芒果广告
	private static Handler handler;
	private static RelativeLayout bannerLayout;
	private AdsMogoLayout adView;
	//private static String mogoAppid = "8f6c1a9a237a49c9bfd9c4dae5c192a2";
	private static String mogoAppid = "93535c6092f543e8a257ee435a69da06";
	
	private static Cocos2dxActivity context;
	
    public static Run getInstance() { return sInstance; }

    public static void setInstance(final Run instance) { sInstance = instance; }

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.activity_ad);
		setInstance(this);
		
		initMogo();
		
		context = (Cocos2dxActivity) Cocos2dxActivity.getContext();
		
		ShareSDKUtils.prepare();
		
	}

	@Override
    protected void onDestroy() {
		super.onDestroy();
		AdsMogoLayout.clear();
		//adsMogoLayoutCode.clearThread();
		if (adView != null) {
			adView.clearThread();
		}
		Log.e("AdsMogo", "onDestroy");
		System.exit(0);
    }
	
	@Override
	protected void onResume() {
		super.onResume();
		
		TalkingDataGA.onResume(this);
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		TalkingDataGA.onPause(this);
	}

    public static void vibrate() {
        final Vibrator vib = (Vibrator) sInstance.getSystemService(Context.VIBRATOR_SERVICE);
        vib.vibrate(500);
    }
    
    //芒果广告香瓜
    public static void showBannerStatic() {
		Message msg = handler.obtainMessage();
		msg.what = 0;
		handler.sendMessage(msg);
	}

	public static void hideBannerStatic() {
		Message msg = handler.obtainMessage();
		msg.what = 1;
		handler.sendMessage(msg);
	}

	public static void initInterstitialStatic() {
		Message msg = handler.obtainMessage();
		msg.what = 2;
		handler.sendMessage(msg);
	}

	public static void showInterstitialStatic() {
		Message msg = handler.obtainMessage();
		msg.what = 3;
		handler.sendMessage(msg);
	}

	public static void close() {
		Message msg = handler.obtainMessage();
		msg.what = 4;
		handler.sendMessage(msg);
	}
	
	public static void closeInterstitial() {
		Message msg = handler.obtainMessage();
		msg.what = 5;
		handler.sendMessage(msg);
	}

	public void onClickHideShow() {
		if (adView != null) {
			adView
					.setVisibility(adView.getVisibility() == View.VISIBLE ? View.GONE
							: View.VISIBLE);
		}
	}
	
	private void initMogo(){
		bannerLayout = new RelativeLayout(this);
		RelativeLayout.LayoutParams parentLayputParams = new RelativeLayout.LayoutParams(
				RelativeLayout.LayoutParams.FILL_PARENT,
				RelativeLayout.LayoutParams.FILL_PARENT);
		this.addContentView(bannerLayout, parentLayputParams);
		
		/**
		* 设置在初始化之前
		* 设置默认的全插屏轮换模式
		* true：手动轮换，false：自动轮换
		* 如果设置全插屏轮换方式为手动轮换true，
		* 请在App信息界面中，将全/插屏间隔时间设置为禁用，
		* 注意需要全插屏初始化完成后才可以调用刷新方	法。
		* if(AdsMogoInterstitialManager.shareInstance().containDefaultInterstitia())
		* { AdsMogoInterstitialManager.shareInstance()
                               .defaultInterstitial().refreshAd(); 
          }
          	注：调用refreshAd方法时，请确保广告初始化已完成，否则该方法不起作用。
          	建议在广告初始化完成的回调onInitFinish()中调用刷新广告的方法。
		*/
		AdsMogoInterstitialManager.setDefaultInitManualRefresh(false);
		/**
		 * 初始化全插屏对象
		 * 初始化之前必须设置默认的AppKey和Activity
		 */
		AdsMogoInterstitialManager.setDefaultInitAppKey(mogoAppid);
		AdsMogoInterstitialManager.setInitActivity(this);
		AdsMogoInterstitialManager.shareInstance()
				.initDefaultInterstitial();
		
		
		AdsMogoInterstitialManager.shareInstance()
				.defaultInterstitial()
				.setAdsMogoInterstitialListener(new AdsMogoInterstitialListener() {
					
//					@Override
//					public void onInterstitialStartReady(String adName){
//						// TODO Auto-generated method stub
//						Log.e("MogoCocos2dx Demo", "onShowInterstitialScreen");
//					}
					
					@Override
					public void onShowInterstitialScreen(String arg0) {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onShowInterstitialScreen");
					}
					
					@Override
					public boolean onInterstitialStaleDated(String arg0) {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialStaleDated");
						return false;
					}
					
					@Override
					public void onInterstitialRealClickAd(String arg0) {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialRealClickAd");
					}
					
					@Override
					public View onInterstitialGetView() {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialGetView");
						return bannerLayout;
					}
					
					@Override
					public void onInterstitialCloseAd(boolean arg0) {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialCloseAd");
					}
					
					@Override
					public boolean onInterstitialClickCloseButton() {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialClickCloseButton");
						return false;
					}
					
					@Override
					public void onInterstitialClickAd(String arg0) {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitialClickAd");
					}
					
					@Override
					public Class getCustomEvemtPlatformAdapterClass(
							AdsMogoCustomEventPlatformEnum arg0) {
						// TODO Auto-generated method stub
						return null;
					}

					@Override
					public void onInitFinish() {
						// TODO Auto-generated method stub
						Log.e("MogoCocos2dx Demo", "onInterstitial  onInitFinish");
//						if(AdsMogoInterstitialManager.shareInstance().containDefaultInterstitia())
//						{ 
//							AdsMogoInterstitialManager.shareInstance()
//					                               .defaultInterstitial().refreshAd(); 
//			            }
					}
				});
		
		
		handler = new Handler() {

			@Override
			public void handleMessage(Message msg) {
				// TODO Auto-generated method stub
				switch (msg.what) {
				case 0:
					/**
					* 初始化banner，
					* 第一个参数：activity
					* 第二个参数：mogoID
					* 第三个参数：是否是手动轮换方式，true：是，false：不是
					*/
					if (bannerLayout.getChildCount() == 0) {
						adView = new AdsMogoLayout(Run.this,
								mogoAppid,false);
						/***
						 * 如果设置轮换方式为true,
						 * 在芒果后台配置，需要把横幅刷新时间设置为禁用
						 * 需要调用adView.refreshAd();//调用刷新方法，会轮换一次广告
						 * 注：调用refreshAd方法时，请确保广告初始化已完成，否则该方法不起作用。建议在onInitFinish
						 * 回调中调用刷新广告的方法。
						 */
						adView.setAdsMogoListener(new AdsMogoListener() {

							@Override
							public void onRequestAd(String arg0) {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onRequestAd");
							}

							@Override
							public void onReceiveAd(ViewGroup arg0, String arg1) {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onReceiveAd");
							}

							@Override
							public void onRealClickAd() {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onRealClickAd");
							}

							@Override
							public void onFailedReceiveAd() {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onFailedReceiveAd");
							}

							@Override
							public void onCloseMogoDialog() {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onCloseMogoDialog");
							}

							@Override
							public boolean onCloseAd() {
								// TODO Auto-generated method stub
								return false;
							}

							@Override
							public void onClickAd(String arg0) {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "onClickAd");
							}

							@Override
							public Class getCustomEvemtPlatformAdapterClass(
									AdsMogoCustomEventPlatformEnum arg0) {
								// TODO Auto-generated method stub
								return null;
							}

							@Override
							public void onInitFinish() {
								// TODO Auto-generated method stub
								Log.e("MogoCocos2dx Demo", "banner onInitFinish");
							}
						});
						RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
								RelativeLayout.LayoutParams.FILL_PARENT,
								RelativeLayout.LayoutParams.WRAP_CONTENT);
						layoutParams.addRule(
								RelativeLayout.ALIGN_PARENT_BOTTOM,
								RelativeLayout.TRUE);
						bannerLayout.addView(adView, layoutParams);
					}
					break;
				case 1:
					onClickHideShow();
					break;
				case 3:
					/**
					 *进入展示时机
					 *当应用需要展示全屏广告调用interstitialShow(boolean isWait);
					 *通知SDK进入展示时机,SDK会竭尽全力展示出广告,当然由于网络等问题不能立即展示
					 *广告的,您可以通过参数isWait来控制授权SDK在获得到广告后立即展示广告。
					 */
					AdsMogoInterstitialManager.shareInstance()
					.defaultInterstitial().interstitialShow(true);
					break;
				case 4:
					Run.this.finish();
					break;
				case 5:
					/**
					 *退出展示时机
					 *如果您之前进入了展示时机,并且isWait参数设置为YES,那么在需要取消等待广告展示的
					 *时候调用方法interstitialCancel();来通知SDK
					 */
					AdsMogoInterstitialManager.shareInstance()
					.defaultInterstitial().interstitialCancel();
					break;
				}
			}
		};
	}
	
	static {
    	System.loadLibrary("game");
    }

}
