// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "CppPlugin.h"
#import <video_render_plugin/VideoRenderFactory.h>


@implementation AppDelegate {
  FlutterEventSink _eventSink;
}

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [self registerViewFactory];
  [FLTCppPlugin registerWithRegistrar:[self registrarForPlugin:@"io.flutter.cppplugin.CppPlugin"]];
  FlutterViewController* controller =
      (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
      methodChannelWithName:@"samples.flutter.io/battery"
            binaryMessenger:controller];
  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                         FlutterResult result) {
    if ([@"getBatteryLevel" isEqualToString:call.method]) {
      int batteryLevel = [self getBatteryLevel];
      if (batteryLevel == -1) {
        result([FlutterError errorWithCode:@"UNAVAILABLE"
                                   message:@"Battery info unavailable"
                                   details:nil]);
      } else {
        result(@(batteryLevel));
      }
    }
    else if ([@"getDeviceId" isEqualToString:call.method]) {
        result(@"1111");
    }
    else if ([@"setShortcutBadger" isEqualToString:call.method]) {
        NSDictionary* dic = call.arguments;
        NSInteger count = [dic[@"badgeCount"] integerValue];
        result(@0);
    }
    else if ([@"doUpdate" isEqualToString:call.method]) {
        result(@0);
    }
    else {
      result(FlutterMethodNotImplemented);
    }
  }];

  FlutterEventChannel* chargingChannel = [FlutterEventChannel
      eventChannelWithName:@"samples.flutter.io/charging"
           binaryMessenger:controller];
  [chargingChannel setStreamHandler:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return ((int)(device.batteryLevel * 100));
  }
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
  [self sendBatteryStateEvent];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
      selector:@selector(onBatteryStateDidChange:)
          name:UIDeviceBatteryStateDidChangeNotification
        object:nil];
  return nil;
}

- (void)onBatteryStateDidChange:(NSNotification*)notification {
  [self sendBatteryStateEvent];
}

- (void)sendBatteryStateEvent {
  if (!_eventSink) return;
  UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
  switch (state) {
    case UIDeviceBatteryStateFull:
    case UIDeviceBatteryStateCharging:
      _eventSink(@"charging");
      break;
    case UIDeviceBatteryStateUnplugged:
      _eventSink(@"discharging");
      break;
    default:
      _eventSink([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"Charging status unavailable"
                                     details:nil]);
      break;
  }
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

- (void)registerViewFactory {
    // 生成注册类
    NSObject<FlutterPluginRegistrar> *registrar = [self registrarForPlugin:@"io.flutter.video_render_plugin.VideoRenderPlugin/suface_view"];
    VideoRenderViewFactory *viewFactory = [[VideoRenderViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:viewFactory withId:@"io.flutter.video_render_plugin.VideoRenderPlugin/suface_view"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"QQ" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}


@end
