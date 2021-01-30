// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';
import 'package:teacher/page/login_page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:videochat_package/constants/customMgr/dbMgr.dart';
import 'dart:convert';
import 'package:videochat_package/library/flustars.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './page/common/common_param.dart';
import './page/provider/upload_provider.dart';
import 'package:videochat_package/constants/Singleton/log.dart';

void main() {
  Constants.gAppType = enAppType.en_teacher;
  LogSingleton.setDebug(true);
  Constants.log=LogSingleton.getInstance();
  g_strVer="0.0.1";//每次版本升级需要手动修改
  MainRun.run();
}

class VideoChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpLoadProvider>(
        create: (_) => gUploadProvider,
        child: Consumer<UpLoadProvider>(
            builder: (_, provider, child) => OKToast(
                  child: MaterialApp(
                    title: 'teacher',
                    debugShowCheckedModeBanner: false, //去除debug调试标志
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                      splashColor: Colors.transparent, //去除水波纹 和highlightColor同时使用
                      highlightColor: Colors.transparent, //去除水波纹 和splashColor同时使用
                    ),
                    home: SplashPage(),
                    //国际化
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: [
                      const Locale('zh', 'CH'),
                      const Locale('en', 'US'),
                    ],
                  ),
                )));
  }
}

class MainRun {
  static run() {
    setDesignWHD(1080, 1920);
    WidgetsFlutterBinding.ensureInitialized();

    Constants.chargingEventChannel.receiveBroadcastStream().listen((Object event) {
      Map<String, dynamic> map = json.decode(event) as Map;
      if (map['method'] == "Charging") {
        String chargemsg = map['Charging'];
      } else if (map['method'] == "deviceid") {
        String deviceid = map['deviceid'];
        if (deviceid.length > 0) {
          Constants.deviceId = deviceid;
        }
      }
    }, onError: (Object error) {
      PlatformException exception = error;
      String _chargingStatus = exception?.message ?? 'Battery status: unknown.';
    });

    //使用flutter异常上报
    FlutterBugly.postCatchedException(() {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
        runApp(
          VideoChatApp(),
        );
      });

      if (Platform.isAndroid) {
        // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    });

    FlutterBugly.init(
      androidAppId: "e63de7f209",
      iOSAppId: "364dc44f53",
      autoDownloadOnWifi: true,
      enableNotification: true,
    );
  }
}
