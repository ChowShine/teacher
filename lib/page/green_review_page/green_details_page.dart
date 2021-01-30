//录入详情
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher/page/common/opration_file.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import '../common/common_param.dart';
import '../common/common_func.dart';
import 'package:oktoast/oktoast.dart';
import '../provider/green_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/green_details.model.dart';
import 'green_pick.dart';
import 'package:videochat_package/constants/customMgr/dlgMgr.dart';
import '../provider/file_provider.dart';
import '../common/full_play.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:videochat_package/constants/photo_view_gallery.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'dart:io';

//
class InputDetailsPage extends StatefulWidget {
  final int type; //0扫码，1点击按钮进入
  final int strStudentId; //学生Id
  InputDetailsPage(this.type, this.strStudentId);
  @override
  _InputDetailsPageState createState() => _InputDetailsPageState();
}

class _InputDetailsPageState extends State<InputDetailsPage> {
  void Function(void Function()) my_setState;
  GreenDetailsProvider provider = new GreenDetailsProvider();
  List<bool> lsSelectStar = List.filled(3, false); //评分选择星星
  final String strImgUrl = "${gnNetType == 0 ? URL.API_ADD_UPLOAD : URLIntranet.API_ADD_UPLOAD}"; //用于拼接已有的视频或图片的网络地址
  int nMsgId = 0;
  String username;
  String gradeClass;
  List<VideoImgParam> mListAddress = [];
  bool isPressSave = true;
  bool bScore = false;
  Map<int, GlobalKey<CacheVideoPlayerWidgetState>> _mapKey = {}; //每个后台视频videoctrl中的Key值

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      await this.provider.getDetailsReq(gProjectInfo.nProjectId, widget.strStudentId);
      int len = this.provider.instance?.data?.content?.score ?? 0;
      if (len > 0) bScore = true;

      if (len == 0) {
        for (int i = 0; i < 3; i++) {
          lsSelectStar[i] = true;
        }
      } else {
        for (int i = 0; i < len; i++) {
          lsSelectStar[i] = true;
        }
      }

      if (widget.type == 0) {
        //扫码进入要获取名字等信息
        if (this.provider.instance.code == "1") {
          showToast("${this.provider.instance.msg}");
          Navigator.pop(context, {'sid': 0, 'score': false});
        }
      }

      username = this.provider.instance.data?.message?.username;
      nMsgId = this.provider.instance?.data?.content?.id ?? 0;
      gradeClass = this.provider.instance.data?.message?.gradeClass;

      initFun();
    });

    Constants.eventBus.on("refreshImageVideo", (arg) {
      if (mounted) setState(() {});
    });

    Constants.eventBus.on("addImageVideo", (arg) {
      List<VideoImgParam> list = arg;
      list.forEach((item) {
        if (item != null) {
          item.nProjectId = gProjectInfo.nProjectId;
          item.nMsgId = nMsgId;
          item.bLocal = true;
          mListAddress.add(item);

          if (mounted) setState(() {});
        }
      });
      setState(() {
        isPressSave = true;
      });
    });

    super.initState();
  }

  void initFun() {
    mListAddress.clear();
    int nImageOrVideo = this.provider.instance?.data?.address?.length ?? 0;
    Constants.log.v("-----图片和视频个数:$nImageOrVideo");
    if (nImageOrVideo > 0) {
      for (int i = 0; i < nImageOrVideo; i++) {
        String strAddress = strImgUrl + this.provider.instance.data.address[i].address;
        Constants.log.v("-----地址是-----：$strAddress");
        if (matchImg(strAddress)) {
          VideoImgParam param = new VideoImgParam(
              strName: this.username,
              id: widget.strStudentId,
              done: 1,
              percent: 100.0,
              status: glsUploadStatus[enUploadStatus.UPLOAD_STATUS_SUCCESS.index],
              type: 0,
              uuid: "",
              file: File(""),
              nProjectId: gProjectInfo.nProjectId,
              nMsgId: nMsgId,
              strAddress: strAddress,
              bLocal: false);
          mListAddress.add(param); //api获取的设置上传成功
        } else if (matchVideo(strAddress)) {
          _mapKey[i] = GlobalKey<CacheVideoPlayerWidgetState>();
          VideoImgParam param = new VideoImgParam(
              strName: this.username,
              id: widget.strStudentId,
              done: 1,
              percent: 100.0,
              status: glsUploadStatus[enUploadStatus.UPLOAD_STATUS_SUCCESS.index],
              videoCtrl: CacheVideoPlayerWidget(_mapKey[i], strAddress, () {
                setState(() {});
              }),
              type: 1,
              uuid: "",
              file: File(""),
              nProjectId: gProjectInfo.nProjectId,
              nMsgId: nMsgId,
              strAddress: strAddress,
              bLocal: false);

          mListAddress.add(param); //api获取的设置上传成功
        }
      }
    }

    if (mp_VideoImgParam[widget.strStudentId] != null && mp_VideoImgParam[widget.strStudentId].length > 0) {
      for (int i = 0; i < mp_VideoImgParam[widget.strStudentId].length; i++) {
        var item = mp_VideoImgParam[widget.strStudentId][i];
        if (item != null) {
          item.nProjectId = gProjectInfo.nProjectId;
          item.nMsgId = nMsgId;
          item.bLocal = true;
          mListAddress.add(item);
        }
      }
    }

    if (mounted) setState(() {});
  }

  void onDeleteAddress(int index) async {
    //调用接口
    if (mListAddress[index].bLocal) {
      //上传过程无删除功能，暂时屏蔽
    } else {
      //调用接口
      int fileId = this.provider.instance.data.address[index].id;
      await this.provider.delImageOrVideoReq(fileId).then((value) {
        if (value == "ok") {
          assert(index < this.provider.instance.data.address.length);

          this.provider.instance.data.address.removeAt(index);
          mListAddress.removeAt(index);
          _mapKey.remove(index);

          if (mounted) setState(() {});
        } else {
          showToast("$value");
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Constants.eventBus.off("refreshImageVideo");
    Constants.eventBus.off("addImageVideo");
    //g_videotime.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, {'sid': widget.strStudentId, 'score': bScore});
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CusText(
            "录入详情",
            color: Colors.black,
            size: CusFontSize.size_18,
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return ChangeNotifierProvider<BaseProvider<GreenDetailsModel>>(
      create: (_) => provider,
      child: Consumer<BaseProvider<GreenDetailsModel>>(
          builder: (_, provider, child) => this.provider.instance == null
              ? LoadingDialog(
                  color: Colors.black54,
                  text: "数据加载中...",
                )
              : buildBodyList()),
    );
  }

  Widget buildBodyList() {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: mListAddress.length <= 5 ? ScreenMgr.scrHeight : ScreenMgr.scrHeight + addHeight(),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                    height: ScreenMgr.setAdapterSize(300.0),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        RichText(
                          text: TextSpan(text: "", style: TextStyle(), children: <InlineSpan>[
                            TextSpan(
                                text: "${this.username ?? ""}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: CusFontSize.size_18,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text: "/$gradeClass",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ]),
                        ),
                        CusText("${gProjectInfo.semesterName}", color: CusColorGrey.grey500, size: CusFontSize.size_16),
                        RichText(
                          text: TextSpan(text: "", style: TextStyle(), children: <InlineSpan>[
                            TextSpan(
                                text: "${gProjectInfo.projectsName}",
                                style: TextStyle(
                                  color: CusColorGrey.grey500,
                                  fontSize: CusFontSize.size_16,
                                )),
                            TextSpan(
                                text: "/${gProjectInfo.stationName}",
                                style: TextStyle(color: CusColorGrey.grey500, fontSize: CusFontSize.size_16)),
                            TextSpan(
                                text: "/${gProjectInfo.learnCardName}",
                                style: TextStyle(
                                  color: CusColorGrey.grey500,
                                  fontSize: CusFontSize.size_16,
                                )),
                          ]),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                    height: ScreenMgr.setAdapterSize(30.0),
                    color: CusColorGrey.grey100,
                  ),
                  Container(
                    padding:
                        EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                    height: ScreenMgr.setAdapterSize(300.0),
                    child: RepaintBoundary(
                      child: StatefulBuilder(builder: (_, state) {
                        my_setState = state;
                        return Row(
                          children: [
                            CusText(
                              "评分",
                              color: Colors.black,
                              size: CusFontSize.size_16,
                            ),
                            HSpacer(
                              ScreenMgr.setAdapterSize(200.0),
                            ),
                            TouchCallBack(
                              child: func_buildImageAsset(
                                  lsSelectStar[0] ? "fs_green_star.png" : "fs_green_star_normal.png",
                                  dScale: 3.0),
                              onPressed: () {
                                my_setState(() {
                                  lsSelectStar[0] = true;
                                  lsSelectStar[1] = false;
                                  lsSelectStar[2] = false;
                                });
                              },
                            ),
                            HSpacer(
                              ScreenMgr.setAdapterSize(100.0),
                            ),
                            TouchCallBack(
                              child: func_buildImageAsset(
                                  lsSelectStar[1] ? "fs_green_star.png" : "fs_green_star_normal.png",
                                  dScale: 3.0),
                              onPressed: () {
                                my_setState(() {
                                  lsSelectStar[0] = true;
                                  lsSelectStar[1] = true;
                                  lsSelectStar[2] = false;
                                });
                              },
                            ),
                            HSpacer(
                              ScreenMgr.setAdapterSize(100.0),
                            ),
                            TouchCallBack(
                              child: func_buildImageAsset(
                                  lsSelectStar[2] ? "fs_green_star.png" : "fs_green_star_normal.png",
                                  dScale: 3.0),
                              onPressed: () {
                                my_setState(() {
                                  lsSelectStar[0] = true;
                                  lsSelectStar[1] = true;
                                  lsSelectStar[2] = true;
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                    height: ScreenMgr.setAdapterSize(3.0),
                    color: CusColorGrey.grey100,
                  ),
                  mListAddress.isEmpty
                      ? Container(
                          margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), ScreenMgr.setAdapterSize(80.0),
                              ScreenMgr.setAdapterSize(60.0), 0.0),
                          height: func_PublishHeight(0), //ScreenMgr.setAdapterSize(330.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ScreenMgr.setAdapterSize(30.0),
                              ),
                              color: CusColorGrey.grey100),
                          child: addImgAndVideo,
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), ScreenMgr.setAdapterSize(80.0),
                              ScreenMgr.setAdapterSize(60.0), 0.0),
                          height: func_PublishHeight(mListAddress.length),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  preView(index);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: index < mListAddress.length
                                      ? Stack(
                                          children: [
                                            Positioned.fill(
                                              child: buildImgVideo(index),
                                            ),
                                            Visibility(
                                              //后台有图才能删除
                                              visible: index <
                                                  this.provider.instance?.data?.address?.length, //mListAddress.length,
                                              child: AnimatedPositioned(
                                                duration: kThemeAnimationDuration,
                                                top: 6.0,
                                                right: 6.0,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    onDeleteAddress(index);
                                                  },
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black38,
                                                    ),
                                                    child: Container(
                                                      width: ScreenMgr.setAdapterSize(80.0),
                                                      height: ScreenMgr.setAdapterSize(80.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : addImgAndVideo,
                                ),
                              );
                            },
                            itemCount:
                                (mListAddress.length >= MAX_IAMGE_VIDEO) ? MAX_IAMGE_VIDEO : mListAddress.length + 1,
                          ),
                        ),
                  Spacer(),
                  VSpacer(
                    ScreenMgr.setAdapterSize(100.0),
                  )
                ],
              ),
            ),
          ),
          CusPadding(
            Container(
                height: ScreenMgr.setHeight(130.0),
                padding: EdgeInsets.fromLTRB(ScreenMgr.scrWidth * 0.1, 0.0, ScreenMgr.scrWidth * 0.1, 0.0),
                alignment: Alignment.center,
                child: TouchCallBack(
                  onPressed: () async {
                    int nScore = 0;
                    lsSelectStar.forEach((element) {
                      if (element) {
                        nScore++;
                      }
                    });
                    await FileProvider.postSaveReq(widget.strStudentId, nScore, nMsgId, gProjectInfo.nProjectId,
                            gProjectInfo.nSubjectId, gProjectInfo.nStationId, gProjectInfo.nLearnCardId)
                        .then((value) {
                      if (value) {
                        bScore = true;
                        Constants.eventBus.emit("refresh_isFinish", {'sid': widget.strStudentId, 'score': bScore});
                        _buildInputSuccessDlg();
                      } else {
                        showToast("保存失败");
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0), color: Color.fromARGB(255, 58, 158, 255)),
                    child: Text(
                      "提 交",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
            t: ScreenMgr.scrHeight * 0.75,
          )
        ],
      ),
    );
  }

  preView(int index) async {
    List<String> images = [];
    List<bool> localType = [];
    int count = 0;
    for (int i = 0; i < mListAddress.length; i++) {
      var item = mListAddress[i];
      if (item != null && item.type == 0) {
        if (i < index) count++;
        if (item.bLocal) {
          images.add(item.strAddress);
          localType.add(true);
        } else {
          images.add(item.strAddress);
          localType.add(false);
        }
      }
    }
    if (mListAddress[index].type == 0) {
      await Navigator.of(context).push(new FadeRoute(
          page: PhotoViewGalleryScreen(
        images: images, //传入图片list
        index: count, //传入当前点击的图片的index
        heroTag: "$count",
        localType: localType,
      )));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VideoFullPage(mListAddress[index].strAddress);
      }));
    }
  }

  Widget get addImgAndVideo => TouchCallBack(
        onPressed: () {
          isPressSave = false;
          DlgMgr.buildDlg(context,
              dHeight: ScreenMgr.setAdapterSize(730.0),
              nType: DlgType.en_DlgBottomSheet,
              widget: MultiAssetsPage(
                strName: username,
                id: widget.strStudentId,
                nMsgId: nMsgId,
                nExistNum: mListAddress.length,
              )).showDlg();
        },
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: CusColorGrey.grey500,
                ),
                CusText(
                  "添加照片/视频",
                  color: CusColorGrey.grey500,
                  size: CusFontSize.size_14,
                )
              ],
            ),
          ),
        ),
      );

  addHeight() {
    if (mListAddress.length >= 6 && mListAddress.length <= 8) {
      return ScreenMgr.setAdapterSize(330.0);
    } else if (mListAddress.length >= 9 && mListAddress.length <= 12) {
      return ScreenMgr.setAdapterSize(330.0) * 2;
    } else
      return 0.0;
  }

  //从数据库读取的数据
  Widget buildFromDB(int index) {
    return Stack(
      children: [
        Container(
            width: double.infinity,
            child: Image.memory(
              mListAddress[index].thumbnail,
              fit: BoxFit.fitWidth,
            )),
        Visibility(
          visible: mListAddress[index].done == 0,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
        Visibility(//视频显示时间
            visible: mListAddress[index].type == 1,
            child: AnimatedPositioned(
              duration: kThemeAnimationDuration,
              bottom: 6.0,
              right: 6.0,
              child: CusText(
                showVideoTime(mListAddress[index].time),
                color: Colors.white,
              ),
            )),
      ],
    );
  }

  Widget buildNetwork(int index) {
    if (mListAddress[index].type == 1) {
      return Stack(
        children: [
          Center(
            child: mListAddress[index].videoCtrl,
          ),
          ColoredBox(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                Icons.video_library,
                color: Colors.grey,
                size: 24.0,
              ),
            ),
          ),
          AnimatedPositioned(
              duration: kThemeAnimationDuration,
              bottom: 6.0,
              right: 6.0,
              child: CusText(
                showVideoTime(g_videotime.containsKey(mListAddress[index].strAddress)
                    ? g_videotime[mListAddress[index].strAddress]
                    : 0 /*mListAddress[index].videoCtrl.value?.duration?.inSeconds*/),
                color: Colors.white,
              ))
        ],
      );
    } else if (mListAddress[index].type == 0) {
      return CachedNetworkImage(
        imageUrl: mListAddress[index].strAddress,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
          ),
        ),
        placeholder: (context, url) => Center(
          child: CupertinoActivityIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
    return Center();
  }

  buildImgVideo(index) {
    if (index < mListAddress.length) {
      if (mListAddress[index] != null) {
        if (!mListAddress[index].bLocal) {
          return buildNetwork(index);
        } else {
          return buildFromDB(index);
        }
      }
    }
    return SizedBox();
  }

  //录入成功对话框
  Future<void> _buildInputSuccessDlg() async {
    await showDialog(
        context: this.context,
        builder: (dlgContext) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              width: ScreenMgr.scrWidth * 0.9,
              height: ScreenMgr.setAdapterSize(800),
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: CusText(
                              "录入成功！",
                              size: CusFontSize.size_18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              height: ScreenMgr.setHeight(100.0),
                              margin: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
                              alignment: Alignment.center,
                              child: TouchCallBack(
                                onPressed: () {
                                  RouteMgr().pop(dlgContext);
                                  Navigator.pop(context, {'sid': widget.strStudentId, 'score': bScore});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Color.fromARGB(255, 58, 158, 255)),
                                  child: Text(
                                    "知道了",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenMgr.scrWidth * 0.9,
                    height: ScreenMgr.setAdapterSize(400.0),
                    child: func_buildImageAsset("fs_success_tip.png", fit: BoxFit.fill),
                  )
                ],
              ),
            ),
          );
        });
  }
} //end class
