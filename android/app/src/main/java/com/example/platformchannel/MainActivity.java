// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.example.platformchannel;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.view.WindowManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.cppplugin.CppPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.video_render_plugin.VideoRenderFactory;
import me.leolin.shortcutbadger.ShortcutBadger;

public class MainActivity extends FlutterActivity implements UpdateCallback  {
  private static final String BATTERY_CHANNEL = "samples.flutter.io/battery";
  private static final String CHARGING_CHANNEL = "samples.flutter.io/charging";


  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    //getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    //getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    final String key = MainActivity.class.getCanonicalName();
    if (this.hasPlugin(key)) return;
    PluginRegistry.Registrar regis =  this.registrarFor(key);
    regis.platformViewRegistry().registerViewFactory("io.flutter.video_render_plugin.VideoRenderPlugin/suface_view", new VideoRenderFactory(regis.messenger()));

    //CppPlugin.registerWith(this.registrarFor("io.flutter.cppplugin.CppPlugin"));

    GeneratedPluginRegistrant.registerWith(this);

    new EventChannel(getFlutterView(), CHARGING_CHANNEL).setStreamHandler(
        new StreamHandler() {
          private BroadcastReceiver chargingStateChangeReceiver;
          private BroadcastReceiver DeviceIdReceiver;
          @Override
          public void onListen(Object arguments, EventSink events) {
            FApp myApp = (FApp) getApplication();

            chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
            registerReceiver(chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

            DeviceIdReceiver  = createDeviceIdReceiver(events);
            registerReceiver(DeviceIdReceiver, new IntentFilter(myApp.DEVICE_ID_BROADCAST));

          }

          @Override
          public void onCancel(Object arguments) {
            unregisterReceiver(chargingStateChangeReceiver);
            chargingStateChangeReceiver = null;

            unregisterReceiver(DeviceIdReceiver);
            DeviceIdReceiver = null;
          }
        }
    );

    new MethodChannel(getFlutterView(), BATTERY_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Result result) {
            if (call.method.equals("getBatteryLevel")) {
              int batteryLevel = getBatteryLevel();

              if (batteryLevel != -1) {
                result.success(batteryLevel);
              } else {
                result.error("UNAVAILABLE", "Battery level not available.", null);
              }
            }
            else if (call.method.equals("getDeviceId")) {
              FApp myApp = (FApp) getApplication();
              if(myApp != null){
                result.success(myApp._deviceId);
              }
            }
            else if (call.method.equals("setShortcutBadger")) {
              int badgeCount = call.argument("badgeCount");
              FApp myApp = (FApp) getApplication();
              ShortcutBadger.applyCount(myApp, badgeCount); //for 1.1.4+
              result.success(0);
            }
            else if (call.method.equals("doUpdate")) {
              String name = call.argument("name");
              String url = call.argument("url");
              UpdateManager manager = new UpdateManager(MainActivity.this);
              manager.setCallback(MainActivity.this);
              manager.update(name,url);
              result.success(0);
            }
            else {
              result.notImplemented();
            }
          }
        }
    );
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
  }

  private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
          events.error("UNAVAILABLE", "Charging status unavailable", null);
        } else {
          boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                               status == BatteryManager.BATTERY_STATUS_FULL;
          String chargemsg = isCharging ? "charging" : "discharging";

          JSONObject jsonObject = new JSONObject();
          try {
            jsonObject.put("method","Charging");
            jsonObject.put("Charging",chargemsg);
          } catch (JSONException e) {
            e.printStackTrace();
          }
          events.success(jsonObject.toString());
        }
      }
    };
  }

  private BroadcastReceiver createDeviceIdReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        String deviceid = intent.getStringExtra("deviceid");
        JSONObject jsonObject = new JSONObject();
        try {
          jsonObject.put("method","deviceid");
          jsonObject.put("deviceid",deviceid);
        } catch (JSONException e) {
          e.printStackTrace();
        }
        events.success(jsonObject.toString());
      }
    };
  }

  private int getBatteryLevel() {
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
  }

  @Override
  public void updateLater(){

  }

  @Override
  public void installNewApp(String path, String name){
    File apkfile = new File(path, name);
    if (!apkfile.exists())  return;

    // 通过Intent安装APK文件
    Intent i = new Intent(Intent.ACTION_VIEW);
    //   i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    i.setDataAndType(Uri.parse("file://" + apkfile.toString()), "application/vnd.android.package-archive");

    int requestCode = 1000;
    startActivityForResult(i, requestCode);
  }

  @Override
  public void quitApp(){
    Intent intent = new Intent(Intent.ACTION_MAIN);
    intent.addCategory(Intent.CATEGORY_HOME);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    this.startActivity(intent);
    android.os.Process.killProcess(android.os.Process.myPid());
    System.exit(0);
  }

}
