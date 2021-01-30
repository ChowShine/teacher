//布置作业

import 'package:flutter/material.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/common_param.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/constants/customMgr/screenMgr.dart';
import 'package:videochat_package/constants/customMgr/widgetMgr.dart';

import 'homework_content_page.dart';

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            color: CusColorGrey.grey100,
            width: ScreenMgr.scrWidth,
            height: ScreenMgr.scrHeight,
          ),
          Container(
            width: ScreenMgr.scrWidth,
            height: ScreenMgr.scrHeight * 0.3,
            child: func_buildImageAsset(
              "fs_home_bk1.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(50.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: ScreenMgr.setAdapterSize(300.0),
                  padding:
                      EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(50.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                                onPressed: () {
                                RouteMgr().pop(context);
                                }),
                          )),
                      Center(
                        child: CusText(
                          "布置作业",
                          color: Colors.white,
                          size: CusFontSize.size_19,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()  async {
                    await RouteMgr().push(context, HomeWorkContentPage()).then((value) {
                      if(value=="back_to_first")
                        Navigator.pop(context);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(ScreenMgr.setAdapterSize(50.0)),
                    height: ScreenMgr.setAdapterSize(400.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CusText(
                              "线下作业",
                              size: CusFontSize.size_19,
                              fontWeight: FontWeight.bold,
                            ),
                            CusText(
                              "自定义作业",
                              size: CusFontSize.size_15,
                            ),
                            CusText(
                              "自由布置作业，支持拍照和视频",
                              color: CusColorGrey.grey400,
                              size: CusFontSize.size_14,
                            )
                          ],
                        ),
                        Spacer(),
                        func_buildImageAsset("fs_homework_offline.png", dScale: 3.0),
                        HSpacer(
                          ScreenMgr.setAdapterSize(30.0),
                        ),
                        func_buildImageAsset("fs_right_arrow.png"),
                      ],
                    ),
                  ),
                ),
                VSpacer(
                  ScreenMgr.setAdapterSize(100.0),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(ScreenMgr.setAdapterSize(50.0)),
                    height: ScreenMgr.setAdapterSize(400.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CusText(
                              "线上作业",
                              size: CusFontSize.size_19,
                              fontWeight: FontWeight.bold,
                            ),
                            CusText(
                              "日常作业",
                              size: CusFontSize.size_15,
                            ),
                            CusText(
                              "根据预设题库选择发布",
                              color: CusColorGrey.grey400,
                              size: CusFontSize.size_14,
                            )
                          ],
                        ),
                        Spacer(),
                        func_buildImageAsset("fs_homework_online.png", dScale: 3.0),
                        HSpacer(
                          ScreenMgr.setAdapterSize(30.0),
                        ),
                        func_buildImageAsset("fs_right_arrow.png"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
} //end_class
