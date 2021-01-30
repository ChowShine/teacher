//首页

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teacher/page/provider/home_provider.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_func.dart';
import '../common/common_param.dart';
import 'homework_mgr_page.dart';
import 'assignment_page.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeProvider provider = HomeProvider();
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      await provider.getHomeReq();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BaseProvider<HomeModel>>(
        create: (_) => provider,
        child: Consumer<BaseProvider<HomeModel>>(
          builder: (_, provider, child) => Stack(
            children: [
              Container(
                color: CusColorGrey.grey200,
                child: CusPadding(
                  Container(
                    width: ScreenMgr.scrWidth,
                    child: func_buildImageAsset("fs_home_bk.png", fit: BoxFit.fill),
                  ),
                  l: 0,
                  r: 0,
                  t: 0,
                  b: ScreenMgr.scrHeight - ScreenMgr.setAdapterSize(840.0),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(20.0), 0, ScreenMgr.setAdapterSize(20.0), 0),
                child: Column(
                  children: [
                    Container(
                      height: ScreenMgr.setAdapterSize(400.0),
                      child: Column(
                        children: [
                          VSpacer(
                            ScreenMgr.setAdapterSize(70.0),
                          ),
                          Row(
                            children: [
                              CusText(
                                "${this.provider.schoolName}",
                                color: Colors.white,
                                size: CusFontSize.size_17,
                              ),
                              Spacer()
                            ],
                          ),
                          VSpacer(
                            ScreenMgr.setAdapterSize(70.0),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: CusText(
                                "您好!$g_strTeacherName老师",
                                color: Colors.white,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: CusText(
                                "上次登陆时间：${this.provider.lastLoginTime}",
                                color: Colors.white,
                                size: CusFontSize.size_12,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenMgr.setAdapterSize(300.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ScreenMgr.setAdapterSize(20.0),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  RouteMgr().push(context, HomeworkMgrPage());
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: func_buildImageAsset("fs_homework_mgr.png"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: CusText(
                                          "作业管理",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: func_buildImageAsset("fs_notify_mgr.png"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: CusText(
                                          "通知管理",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: func_buildImageAsset("fs_achievement_mgr.png"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: CusText(
                                        "成绩管理",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: func_buildImageAsset("fs_clock_mgr.png"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: CusText(
                                        "打卡",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    VSpacer(
                      ScreenMgr.setAdapterSize(20.0),
                    ),
                    Container(
                      height: ScreenMgr.setAdapterSize(220.0),
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            ScreenMgr.setAdapterSize(20.0),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: ScreenMgr.setAdapterSize(220.0),
                                child: func_buildImageAsset("fs_homework_bk.png", fit: BoxFit.fill),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenMgr.setAdapterSize(50.0),
                                  right: ScreenMgr.setAdapterSize(50.0),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: CusText(
                                          "请假申请",
                                          size: CusFontSize.size_13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            CusText(
                                              "今日有2条请假申请",
                                              size: CusFontSize.size_19,
                                              color: Colors.white,
                                            ),
                                            Spacer(),
                                            CusText(
                                              "立即查看>",
                                              size: CusFontSize.size_13,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                    VSpacer(
                      ScreenMgr.setAdapterSize(20.0),
                    ),
                    Container(
                      height: ScreenMgr.setAdapterSize(200.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              RouteMgr().push(context, AssignmentPage());
                            },
                            child: Container(
                              width: ScreenMgr.scrWidth * 0.47,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ScreenMgr.setAdapterSize(20.0),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      HSpacer(
                                        ScreenMgr.setAdapterSize(30.0),
                                      ),
                                      Text(
                                        "布置作业",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: CusFontSize.size_19,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Spacer(),
                                      func_buildImageAsset("fs_assignment.png", dScale: 3.0),
                                      HSpacer(
                                        ScreenMgr.setAdapterSize(30.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: ScreenMgr.scrWidth * 0.47,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ScreenMgr.setAdapterSize(20.0),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    HSpacer(
                                      ScreenMgr.setAdapterSize(30.0),
                                    ),
                                    Text(
                                      "课程表",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: CusFontSize.size_19,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Spacer(),
                                    func_buildImageAsset("fs_timetable.png", dScale: 3.0),
                                    HSpacer(
                                      ScreenMgr.setAdapterSize(30.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    VSpacer(
                      ScreenMgr.setAdapterSize(20.0),
                    ),
                    Expanded(
                      child: ClipRRect(
                        //形状
                        //修改圆角
                        borderRadius: BorderRadius.circular(
                          ScreenMgr.setAdapterSize(20.0),
                        ),

                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenMgr.setAdapterSize(50.0), 0.0, ScreenMgr.setAdapterSize(50.0), 0.0),
                                  height: ScreenMgr.setAdapterSize(100.0),
                                  child: Row(
                                    children: [
                                      CusText(
                                        "${DateTime.now().year}年${DateTime.now().month}月",
                                        size: CusFontSize.size_16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: () async {},
                                          child: CusText(
                                            "更多计划",
                                            color: CusColorGrey.grey400,
                                            size: CusFontSize.size_14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenMgr.setAdapterSize(50.0), 0.0, ScreenMgr.setAdapterSize(50.0), 0.0),
                                  height: ScreenMgr.setAdapterSize(120.0),
                                  child: buildWeek()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  final weekDay = ["一", "二", "三", "四", "五", "六", "日"];
  buildWeek() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            7,
            (index) => CusText("${weekDay[index]}",
                size: CusFontSize.size_14, color: CusColorGrey.grey400, fontWeight: FontWeight.bold)));
  }
} //end_class
