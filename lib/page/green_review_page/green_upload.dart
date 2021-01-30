//上传队列

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher/page/common/opration_file.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_func.dart';
import '../common/common_param.dart';
import 'dart:io';
import 'package:videochat_package/constants/customMgr/fileMgr.dart';
import 'package:videochat_package/constants/customMgr/dirMgr.dart';
import 'dart:typed_data';

class UpLoadListPage extends StatefulWidget {
  final String projectsName, stationName, learnCardName, semesterName;
  UpLoadListPage({this.projectsName, this.stationName, this.learnCardName, this.semesterName});
  @override
  _UpLoadListPageState createState() => _UpLoadListPageState();
}

class _UpLoadListPageState extends State<UpLoadListPage> {
  int listLen = 0;
  @override
  void initState() {
    // TODO: implement initState
    listLen = mp_VideoImgParam.length ?? 0;
    Constants.eventBus.on("UpdateUploadList", (arg) async {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Constants.eventBus.off("UpdateUploadList");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CusText(
          "上传队列",
          color: Colors.black,
          size: CusFontSize.size_18,
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          ActionChip(
            onPressed: () {
              mp_VideoImgParam.forEach((key, value) {
                value.forEach((element) {
                  if (element.status.compareTo(glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index]) == 0) {
                    //重新上传
                    Constants.log.v("重新上传", tag: "重传");
                    //uploadOne(element, (){});
                    element.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_WAIT.index];
                    g_lsSave.add(element);
                  }
                });
              });
              setState(() {
              });
            },
            backgroundColor: Color.fromARGB(255, 58, 158, 255),
            label: Text(
              "一键重试",
              style: TextStyle(color: Colors.white),
            ),
          ),
          HSpacer(
            ScreenMgr.setAdapterSize(60.0),
          )
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return listLen == 0 ? func_buildNonData() : _buildBodyList(this.context);
  }

  Widget _buildBodyList(BuildContext context) {
    List<Widget> lsTemp = new List();
    int i = 0;
    mp_VideoImgParam.forEach((key, value) {
      int fileDone = 0;
      for (int t = 0; t < value.length; t++) {
        fileDone += value[t].done;
      }
      if (i == 0) {
        //int i = 0; //创建第一个列表需要添加头部信息
        lsTemp.add(
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
              height: ScreenMgr.setAdapterSize(240.0),
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  RichText(
                    text: TextSpan(text: "", style: TextStyle(), children: <InlineSpan>[
                      TextSpan(
                          text: "${widget.projectsName ?? ""}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: CusFontSize.size_18,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                          text: "/${widget.stationName ?? ""}",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: "/${widget.learnCardName ?? ""}",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ]),
                  ),
                  CusText("${widget.semesterName ?? ""}", color: CusColorGrey.grey500, size: CusFontSize.size_16),
                  Spacer()
                ],
              ),
            ),
          ),
        );
        lsTemp.add(
          SliverToBoxAdapter(
            child: Container(
              height: ScreenMgr.setAdapterSize(30.0),
              color: CusColorGrey.grey100,
            ),
          ),
        );
      }
      if (fileDone == value.length) {
        //全部上传完，不用显示
        lsTemp.add(SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: CusSliverAppBarDelegate(
                minHeight: ScreenMgr.setAdapterSize(0.0),
                maxHeight: ScreenMgr.setAdapterSize(0.0),
                child: SizedBox())));
      } else
        lsTemp.add(SliverPersistentHeader(
          pinned: false,
          floating: false,
          delegate: CusSliverAppBarDelegate(
            minHeight: ScreenMgr.setAdapterSize(150.0),
            maxHeight: ScreenMgr.setAdapterSize(150),
            child: InkWell(
              onTap: () {
                setState(() {
                  value[0].isExpand = !value[0].isExpand;
                });
              },
              child: Container(
                //头部
                color: Colors.white,
                height: ScreenMgr.setAdapterSize(180.0),
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                child: Row(
                  children: [
                    CusText(
                      "${value[0].strName}",
                      size: CusFontSize.size_17,
                    ),
                    value.length == fileDone
                        ? func_buildImageAsset("fs_upload_success.png", dScale: 2.0)
                        : func_buildImageAsset("fs_upload_error.png", dScale: 2.0),
                    Spacer(),
                    Text(
                      "$fileDone/${value.length}",
                      style: TextStyle(color: CusColorGrey.grey400),
                    ),
                    IconButton(
                      icon: Icon(
                        value[0].isExpand ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                        size: 24.0,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          value[0].isExpand = !value[0].isExpand;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
      if (value.length > 0 && value[0].isExpand) {
        if (fileDone == value.length) {
          //全部上传完，不用显示
          lsTemp.add(SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return SizedBox(
                height: 0.0,
              );
            }, childCount: value.length //ele?.fileTotal,
                ),
          ));
        } else
          lsTemp.add(SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return (value[index].done == 1)
                  ? SizedBox(
                      height: 0.0,
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), ScreenMgr.setAdapterSize(20.0),
                          ScreenMgr.setAdapterSize(60.0), ScreenMgr.setAdapterSize(20.0)),
                      height: ScreenMgr.setAdapterSize(240.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: value[index].thumbnail == null
                                ? Container()
                                : SizedBox(
                                    child: value[index].type == 0
                                        ? Image.memory(
                                            value[index].thumbnail,
                                            fit: BoxFit.cover,
                                          )
                                        : Stack(
                                            children: [
                                              Positioned.fill(
                                                child: Image.memory(
                                                  value[index].thumbnail,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              AnimatedPositioned(
                                                child: CusText(
                                                  showVideoTime(value[index].time),
                                                  color: Colors.white,
                                                ),
                                                duration: kThemeAnimationDuration,
                                                bottom: 6.0,
                                                right: 6.0,
                                              )
                                            ],
                                          ),
                                    width: ScreenMgr.setAdapterSize(200),
                                    height: ScreenMgr.setAdapterSize(200),
                                  ),
                          ),
                          HSpacer(ScreenMgr.setAdapterSize(50.0)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    CusText(
                                      "${value[index].status}",
                                      color: value[index].status.compareTo(
                                                  glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index]) ==
                                              0
                                          ? Colors.redAccent
                                          : value[index].status.compareTo(
                                                      glsUploadStatus[enUploadStatus.UPLOAD_STATUS_DOING.index]) ==
                                                  0
                                              ? Colors.blue
                                              : CusColorGrey.grey500,
                                    ),
                                    HSpacer(ScreenMgr.scrWidth * 0.15),
                                    CusText(
                                      "${value[index].percent} %",
                                      color: CusColorGrey.grey500,
                                    ),
                                  ],
                                ),
                              ),
                              new SizedBox(
                                //限制进度条的高度
                                height: ScreenMgr.setAdapterSize(10.0),
                                //限制进度条的宽度
                                width: ScreenMgr.scrWidth * 0.5,
                                child: new LinearProgressIndicator(
                                    //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                                    value: value[index].percent / 100,
                                    //背景颜色
                                    backgroundColor: CusColorGrey.grey300,
                                    //进度颜色
                                    valueColor: new AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 58, 158, 255))),
                              ),
                              Text(
                                  "${Singleton.handleCache.renderSize(double.parse(value[index].size.toString()))}" //"${(ele.lsSize[index] / 1024).toStringAsFixed(1)} KB",
                                  ),
                              VSpacer(ScreenMgr.setAdapterSize(10.0)),
                            ],
                          ),
                          Spacer(),
                          value[index].status.compareTo(glsUploadStatus[enUploadStatus.UPLOAD_STATUS_SUCCESS.index]) ==
                                  0
                              ? func_buildImageAsset("fs_upload_done.png", dScale: 3.0)
                              : InkWell(
                                  child: value[index]
                                              .status
                                              .compareTo(glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index]) ==
                                          0
                                      ? func_buildImageAsset("fs_re_upload.png", dScale: 3.0)
                                      : func_buildImageAsset("fs_uploading.png", dScale: 3.0),
                                  onTap: () async {
                                    if (value[index].status.compareTo(glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index]) == 0) {
                                      //重新上传
                                      Constants.log.v("重新上传", tag: "重传");
                                      //uploadOne(value[index], (){});
                                      value[index].status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_WAIT.index];
                                      g_lsSave.add(value[index]);
                                      setState(() {

                                      });
                                    }
                                  },
                                )
                        ],
                      ),
                    );
            }, childCount: value.length),
          ));
      }
      lsTemp.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
            height: ScreenMgr.setAdapterSize(3.0),
            color: CusColorGrey.grey100,
          ),
        ),
      );
      i++;
    });

    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: CustomScrollView(
        slivers: lsTemp,
      ),
    );
  }
} //end_class
