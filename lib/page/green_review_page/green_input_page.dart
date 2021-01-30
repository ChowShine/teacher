//绿评录入
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:teacher/page/common/scan_camera_dialog.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import '../common/common_param.dart';
import '../common/common_func.dart';
import 'green_details_page.dart';
import 'green_search_page.dart';
import 'package:videochat_package/constants/customWidet/scanWidget.dart';
import '../provider/green_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/green_input_model.dart';
import 'package:videochat_package/constants/customMgr/dlgMgr.dart';
import 'green_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final ScrollController _scrollController = new ScrollController();
  GreenInputProvider provider = new GreenInputProvider();
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      this.provider.init();
      await this.provider.getInputReq().then((value) {
      });

      if (g_strToken == null) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        g_strToken = sp.getString("SP_TOKEN");
        print("-----token值：$g_strToken");
      }
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        this.provider.setStateType(LoadType.en_Loading);
        await this.provider.getInputReq();
      }
    });

    Constants.eventBus.on("refresh_isFinish", (value) {
      if(value != null){
        if(value['score'] == true){
          if(mounted) setState(() {
            for(int i=0;i<this.provider.list.length;i++){
              if(this.provider.list[i].studentId == value['sid']){
                this.provider.list[i].isFinish = "已录入";
              }
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Constants.eventBus.off("refresh_isFinish");
    super.dispose();
  }

  /*
  @function：判断当前项目是否还有图片或视频等待上传
  @param1：空
  @return：true有，false无
  */

  bool isUploading(){
    if(mp_VideoImgParam!=null&&mp_VideoImgParam.length>0){
      bool bHave=false;
      mp_VideoImgParam.forEach((key, value) {
        for(int i=0;i<value.length;i++){
          if(value[i].status==glsUploadStatus[enUploadStatus.UPLOAD_STATUS_WAIT.index]){
            bHave=true;
            return;
          }
          if(bHave)
            break;
        }
      });
      return bHave;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async{
        if(isUploading()){
          showToast("当前项目正在上传,无法退出！！！");
          return Future.value(false);
        }

        else
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CusText(
            "绿评录入",
            color: Colors.black,
            size: CusFontSize.size_18,
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: func_buildImageAsset("fs_upload_list.png", dScale: 2.6),
              onPressed: () async {
                RouteMgr().push(
                    context,
                    UpLoadListPage(
                      projectsName: gProjectInfo.projectsName ?? "",
                      stationName: gProjectInfo.stationName ?? "",
                      learnCardName: gProjectInfo.learnCardName ?? "",
                      semesterName: gProjectInfo.semesterName ?? "",
                    ));
              },
            ),
            HSpacer(ScreenMgr.setAdapterSize(40.0)) //占位
          ],
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return ChangeNotifierProvider<BaseListProvider<InputData>>(
        create: (_) => provider,
        child: Consumer<BaseListProvider<InputData>>(
            builder: (_, provider, child) => this.provider.list.length == 0
                ? LoadingDialog(
                    color: Colors.black54,
                    text: "数据加载中...",
                  )
                : RefreshIndicator(
                    onRefresh: () async {},
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                              height: ScreenMgr.setAdapterSize(280.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TouchCallBack(
                                    child: Container(
                                        height: ScreenMgr.setAdapterSize(180.0),
                                        width: ScreenMgr.scrWidth * 0.41,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: func_buildImageAsset("fs_green_search.png", fit: BoxFit.cover),
                                        )),
                                    onPressed: () {
                                      RouteMgr().push(context, SearchPage());
                                    },
                                  ),
                                  TouchCallBack(
                                    child: Container(
                                      height: ScreenMgr.setAdapterSize(180.0),
                                      width: ScreenMgr.scrWidth * 0.41,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: func_buildImageAsset("fs_green_scan.png", fit: BoxFit.cover)),
                                    ),
                                    onPressed: () async {
                                      final barcode = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RScanCameraDialog()));
                                      if (barcode == null) {
                                        print('nothing return.');
                                      } else {
                                        String str = barcode.message;
                                        try{
                                          int ret = int.parse(str);
                                          if(ret > 0){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InputDetailsPage(0,int.parse(str))))
                                                .then((value) async {
                                              if(value != null){
                                                if(value['score'] == true){
                                                  if(mounted) setState(() {
                                                    for(int i=0;i<this.provider.list.length;i++){
                                                      if(this.provider.list[i].studentId == value['sid']){
                                                        this.provider.list[i].isFinish = "已录入";
                                                      }
                                                    }
                                                  });
                                                }
                                              }
                                            });
                                          }
                                          else{
                                            showToast("二维码错误");
                                          }
                                        }catch(e){
                                          showToast("二维码错误");
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                              color: Colors.white,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              height: ScreenMgr.setAdapterSize(30.0),
                              color: CusColorGrey.grey100,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
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
                                          text: "${gProjectInfo.projectsName ?? ""}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: CusFontSize.size_18,
                                              decoration: TextDecoration.underline)),
                                      TextSpan(
                                          text: "/${gProjectInfo.stationName ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                      TextSpan(
                                          text: "/${gProjectInfo.learnCardName ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ]),
                                  ),
                                  CusText("${gProjectInfo.semesterName ?? ""}",
                                      color: CusColorGrey.grey500, size: CusFontSize.size_16),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((_, index) {
                              return index < this.provider.list.length
                                  ? Column(
                                      children: [
                                        TouchCallBack(
                                          onPressed: () async {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InputDetailsPage(1,this.provider.list[index].studentId)))
                                                .then((value) async {
                                                      if(value != null){
                                                        if(value['score'] == true){
                                                          if(mounted) setState(() {
                                                            if(value['sid'] == this.provider.list[index]?.studentId){
                                                              this.provider.list[index]?.isFinish="已录入";
                                                            }
                                                          });
                                                        }
                                                      }
                                            });
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            height: ScreenMgr.setAdapterSize(180.0),
                                            padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0,
                                                ScreenMgr.setAdapterSize(60.0), 0.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CusText(
                                                      "${this.provider.list[index].username ?? ""}",
                                                      size: CusFontSize.size_17,
                                                    ),
                                                    CusText(
                                                      "${this.provider.list[index].gradeClass ?? ""}",
                                                      size: CusFontSize.size_15,
                                                      color: CusColorGrey.grey400,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                TouchCallBack(
                                                  onPressed: () {},
                                                  child: Container(
                                                    height: ScreenMgr.setAdapterSize(90.0),
                                                    padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      color: this.provider.list[index].isFinish == "已录入"
                                                          ? Color.fromARGB(255, 55, 158, 255)
                                                          : Color.fromARGB(255, 200, 208, 220),
                                                    ),
                                                    child: Text(
                                                      "${this.provider.list[index].isFinish ?? ""}",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        CusPadding(
                                          VSpacer(
                                            1.0,
                                            color: CusColorGrey.grey200,
                                          ),
                                          l: ScreenMgr.setAdapterSize(60.0),
                                          r: ScreenMgr.setAdapterSize(60.0),
                                        )
                                      ],
                                    )
                                  : LoadMoreWidget(this.provider.stateType);
                            }, childCount: this.provider.list.length + 1),
                          ),
                        ],
                      ),
                    ),
                  )));
  }
} //end class
