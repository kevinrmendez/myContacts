package com.kevinrmendez.contact_app;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


import java.io.File;
import java.io.IOException;

import android.util.DisplayMetrics;
import android.view.Display;

import 	android.util.Log;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.AdListener;
import 	java.util.Timer;
import 	java.util.TimerTask;
import java.lang.Runnable;


public class MainActivity extends FlutterActivity  {
private InterstitialAd mInterstitialAd;
 private Timer waitTimer;


  
     private static final String SHARE_CHANNEL = "setWallpaper";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);

mInterstitialAd = new InterstitialAd(this);
        // mInterstitialAd.setAdUnitId("ca-app-pub-7306861253247220/9870338122");
        mInterstitialAd.setAdUnitId("ca-app-pub-3940256099942544/1033173712");

        mInterstitialAd.loadAd(new AdRequest.Builder().build());

        mInterstitialAd.setAdListener(new AdListener() {
        @Override
        public void onAdLoaded() {

                if (mInterstitialAd.isLoaded()) {
                    mInterstitialAd.show();
                     Log.d("TAG", "The interstitial was shown FROM KOTLIN");
                }

        }
          @Override
        public void onAdOpened() {}
        @Override
        public void onAdFailedToLoad(int errorCode){}
        });   
  }

}