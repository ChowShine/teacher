//点评作业

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:teacher/page/common/audio_record.dart';
import 'package:videochat_package/constants/customMgr/dlgMgr.dart';
import 'package:videochat_package/constants/customMgr/widgetMgr.dart';
import '../common/common_param.dart';
import '../common/common_func.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import '../model/student_homework_model.dart';
import '../provider/student_homework_provider.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../common/ImgVideoHelper.dart';
import '../common/audio_player.dart';
import 'dart:io';
import '../provider/green_details_provider.dart';
import 'package:oktoast/oktoast.dart';

class CommentHomeworkPage extends StatefulWidget {
  final int student_homework_id; //学生提交作业Id
  final String studentName;
  CommentHomeworkPage(this.student_homework_id, this.studentName);
  @override
  _CommentHomeworkPageState createState() => _CommentHomeworkPageState();
}

class _CommentHomeworkPageState extends State<CommentHomeworkPage> {
  int nImgVideoCnt = 0; //作业附件个数
  bool isRecordVoice = false; //是否正在录音
  bool isCanSend = true; //语音是否可以发送
  double y_Start = 0.0; //按下位置
  double offset = 0.0; //手指移动位置
  Timer _timer;
  int nRecordTime = 0; //录制时间
  int nPlayTime = 0; //播放时间 整数格式 用于上传
  String filePath = "";
  bool isHaveVoice = false; //是否有语音
  StudentHomeWorkProvider provider = new StudentHomeWorkProvider();
  List<String> ls_strScore = []; //分数等级列表
  int nScoreId = 0; //老师评价的等级
  List<String> lsStrAddr = []; //学生附件地址
  ImageVideoHelper _imgVideoHelper; //显示图片和视频
  String strComment = ""; //如果评论时的评语
  bool isPlayVoice = false; //是否播放语音
  AudioPalyerMgr playAudio;
  AudioRecordMgr _recordMgr;
  TextEditingController _textEditingController = TextEditingController(); //评语

  bool isOriginalVoice=false;//删除的是否原始数据

  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      await this.provider.getStudentHomeWorkReq(widget.student_homework_id);
      nImgVideoCnt = this.provider.instance?.data?.files?.length ?? 0;

      if (this.provider.instance?.data?.score != null && this.provider.instance.data.score.isNotEmpty)
        for (int i = 0; i < this.provider.instance.data.score.length; i++) {
          ls_strScore.add(this.provider.instance.data.score[i].scoreName);
        }
      nScoreId = this.provider.instance?.data?.information?.scoreId ?? 0;

      strComment = this.provider.instance?.data?.information?.remark ?? "";
      if (this.provider.instance?.data?.files != null && this.provider.instance.data.files.isNotEmpty) {
        for (int i = 0; i < this.provider.instance.data.files.length; i++) {
          lsStrAddr.add(this.provider.instance.data.files[i].address);
        }
        _imgVideoHelper = new ImageVideoHelper(lsStrAddr, context);
      }

      isHaveVoice = (this.provider.instance?.data?.remarkFiles?.address ?? "").isNotEmpty ? true : false;
      isOriginalVoice=isHaveVoice;
      nPlayTime = int.parse(this.provider.instance?.data?.remarkFiles?.voiceTime ?? "0");
      if (isHaveVoice) {
        playAudio =
            AudioPalyerMgr(en_AudioType.AUDIO_TYPE_URL, this.provider?.instance?.data?.remarkFiles?.address ?? "");

        playAudio.onPlayerStateChangedListen((value) {
          Constants.log.v("$value");
          if (isPlayVoice) {
            //在播放
            if (value == AudioPlayerState.COMPLETED) {
              setState(() {
                isPlayVoice = false;
              });
            }
          }
        });
      }
      _recordMgr = new AudioRecordMgr();
      await _recordMgr.init(); //初始化
      /// 开始录制或结束录制的监听
      _recordMgr.responseListen((data) {
        if (data.msg == "onStop") {
          ///结束录制时会返回录制文件的地址方便上传服务器
          Constants.log.v("结束束录制");
          Constants.log.v("音频文件位置" + data.path);
          Constants.log.v("音频录制时长" + data.audioTimeLength.toString());

          if (isCanSend) {
            Constants.log.v("可以发送");
            //12.0转12
            filePath = data.path;
            nPlayTime =
                int.parse(data.audioTimeLength.toString().substring(0, data.audioTimeLength.toString().length - 2));
            if (mounted)
              setState(() {
                isHaveVoice = true; //显示有语音
              });

            //新的语音 重新定义playAudio
            playAudio = AudioPalyerMgr(en_AudioType.AUDIO_TYPE_LOCAL, data.path);
            //新的语音 重新监听状态
            playAudio.onPlayerStateChangedListen((value) {
              Constants.log.v("$value");
              if (isPlayVoice) {
                //在播放
                if (value == AudioPlayerState.COMPLETED) {
                  setState(() {
                    isPlayVoice = false;
                  });
                }
              }
            });
          } else {
            Constants.log.v("不可以发送");
          }
        } else if (data.msg == "onStart") {
          timeStart();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController?.dispose();
    playAudio?.dispose();
    timeCancel();
    _recordMgr?.dispose();
    super.dispose();
  }

  void timeStart() {
    Constants.log.v("开始录制");
    int second = 0;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      second++;
      Constants.log.v("录制时长：$second");
      if (mounted)
        mySetState(() {
          nRecordTime = second;
        });
    });
  }

  void timeCancel() {
    if (_timer?.isActive != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CusText(
          "${widget.studentName}",
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
    );
  }

  buildBody() {
    return ChangeNotifierProvider<BaseProvider<StudentHomeWorkDetailsModel>>(
        create: (_) => provider,
        child: Consumer<BaseProvider<StudentHomeWorkDetailsModel>>(
          builder: (_, provider, child) => this.provider.instance == null
              ? LoadingDialog(
                  color: Colors.black54,
                )
              : Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          height: nImgVideoCnt > 3 ? ScreenMgr.scrHeight * 1.5 : ScreenMgr.scrHeight * 1.2,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                height: ScreenMgr.setAdapterSize(150.0),
                                child: Row(
                                  children: [
                                    CusText(
                                      "${this.provider.instance?.data?.information?.username ?? ""} ${this.provider.instance?.data?.information?.gradeClass ?? ""}",
                                      color: CusColorGrey.grey400,
                                    ),
                                    Spacer(),
                                    CusText(
                                      "${this.provider.instance?.data?.information?.dtime?.substring(5, 19)}",
                                      color: CusColorGrey.grey400,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                  child: Text(
                                    "${this.provider.instance?.data?.information?.content ?? ""}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: CusFontSize.size_17,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 16, child: _buildCommentWidget()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildCommentBtn()
                  ],
                ),
        ));
  }

  StateSetter mySetState;
  //未点评
  _buildCommentWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildImgVideo(),
        VSpacer(
          ScreenMgr.setAdapterSize(50.0),
          color: Colors.white,
        ),
        VSpacer(
          ScreenMgr.setAdapterSize(50.0),
          color: CusColorGrey.grey100,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
          height: ScreenMgr.setAdapterSize(150.0),
          child: Row(
            children: [
              CusText(
                "老师点评",
                size: CusFontSize.size_16,
              ),
              Spacer(),
            ],
          ),
        ),
        StatefulBuilder(builder: (_, my_setState) {
          return Container(
            padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
            height: ScreenMgr.setAdapterSize(300.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    ls_strScore.length,
                    (index) => InkWell(
                          onTap: () {
                            my_setState(() {
                              nScoreId = index + 1;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              func_buildImageAsset(
                                  nScoreId == index + 1
                                      ? "fs_score${index + 1}_select.png"
                                      : "fs_score${index + 1}_unselect.png",
                                  dScale: 3.0),
                              CusText("${ls_strScore[index]}",
                                  color: nScoreId == index + 1 ? Colors.black : CusColorGrey.grey400)
                            ],
                          ),
                        ))),
          );
        }),
        VSpacer(
          ScreenMgr.setAdapterSize(50.0),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
          height: ScreenMgr.setAdapterSize(300.0),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              ScreenMgr.setAdapterSize(30.0),
              0.0,
              ScreenMgr.setAdapterSize(30.0),
              ScreenMgr.setAdapterSize(20.0),
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: CusColorGrey.grey100),
            child: TextField(
              maxLines: 3,
              maxLength: 100,
              controller: _textEditingController,
              decoration: InputDecoration(
                  hintText: strComment.isEmpty ? "请输入评语，（非必填）" : strComment,
                  hintStyle: TextStyle(color: CusColorGrey.grey500),
                  border: InputBorder.none),
            ),
          ),
        ),
        VSpacer(
          ScreenMgr.setAdapterSize(50.0),
        ),
        isHaveVoice
            ? Container(
                //有语音
                height: ScreenMgr.setAdapterSize(150.0),
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), ScreenMgr.setAdapterSize(15.0),
                          ScreenMgr.setAdapterSize(30.0), 0.0),
                      width: ScreenMgr.scrWidth * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0), color: Color.fromARGB(255, 69, 126, 216)),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!isPlayVoice) {
                          //没有播放就播放
                          Constants.log.v("播放");
                          setState(() {
                            isPlayVoice = true;
                          });
                          await playAudio.play();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), ScreenMgr.setAdapterSize(15.0),
                            ScreenMgr.setAdapterSize(30.0), 0.0),
                        width: ScreenMgr.scrWidth * 0.4,
                        child: Center(
                          child: Row(
                            children: [
                              HSpacer(ScreenMgr.setAdapterSize(20.0)),
                              CusText(
                                "${showVideoTime(nPlayTime)}",
                                color: Colors.white,
                              ),
                              Spacer(),
                              func_buildImageAsset(isPlayVoice ? "fs_play_voice.gif" : "fs_non_play_voice.png"),
                              HSpacer(ScreenMgr.setAdapterSize(20.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: InkWell(
                          child: func_buildImageAsset("fs_close.png", dScale: 2.6),
                          onTap: ()async{
                            if (!isPlayVoice&&isOriginalVoice) {//有语音
                              //只有没有播放时才可以删除
                              //这里使用绿评时删除文件的方法
                              await GreenDetailsProvider()
                                  .delImageOrVideoReq(this.provider.instance?.data?.remarkFiles?.remarkFilesId ?? 0)
                                  .then((value) {
                                if (value == "ok") {
                                  Constants.log.v("删除语音");
                                  isOriginalVoice=false;//原始音频数据没了
                                  setState(() {
                                    isHaveVoice = false;
                                  });
                                  playAudio?.dispose();
                                  playAudio = null;
                                  nPlayTime=0;
                                  filePath="";
                                }
                              });
                            }else if(!isPlayVoice&&!isOriginalVoice){//自己录制语音
                              setState(() {
                                isHaveVoice = false;
                              });
                            }
                          },
                        ),
                      top: 0.0,
                      left: ScreenMgr.scrWidth * 0.4,
                      bottom: ScreenMgr.setAdapterSize(150.0)/2,
                    )
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                height: ScreenMgr.setAdapterSize(150.0),
                color: Colors.white,
                child: Container(
                    padding:
                        EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: CusColorGrey.grey100),
                    child: Row(
                      children: [
                        CusText(
                          "语音点评（非必填）",
                          color: CusColorGrey.grey500,
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(
                              Icons.keyboard_voice_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              DlgMgr.buildDlg(context, dHeight: ScreenMgr.scrHeight * 0.5,
                                      widget: StatefulBuilder(builder: (_, state) {
                                mySetState = state;
                                return Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Spacer(),
                                        isRecordVoice
                                            ? Stack(
                                                children: [
                                                  Center(
                                                    child: func_buildImageAsset("fs_recording.gif"),
                                                  ),
                                                  Center(child: CusText("${showVideoTime(nRecordTime)}"))
                                                ],
                                              )
                                            : SizedBox(),
                                        GestureDetector(
                                          onLongPressStart: (details) {
                                            y_Start = details.globalPosition.dy;
                                            mySetState(() {
                                              isRecordVoice = true;
                                            });
                                            _recordMgr.start();
                                          },
                                          onLongPressEnd: (details) {
                                            mySetState(() {
                                              isRecordVoice = false;
                                              _recordMgr.stop();
                                              nRecordTime = 0;
                                              timeCancel();
                                            });
                                            Navigator.pop(_);
                                          },
                                          onLongPressMoveUpdate: (details) {
                                            offset = details.globalPosition.dy;
                                            mySetState(() {
                                              bool isUp = y_Start - offset > 20 ? true : false;
                                              if (isUp) {
                                                //取消发送
                                                isCanSend = false;
                                              } else {
                                                //发送
                                                isCanSend = true;
                                              }
                                            });
                                          },
                                          child: func_buildImageAsset(
                                              isRecordVoice ? "fs_voice_press.png" : "fs_voice_unpress.png",
                                              dScale: 3.0),
                                        ),
                                        VSpacer(
                                          ScreenMgr.setAdapterSize(30.0),
                                        ),
                                        CusText(
                                          isRecordVoice ? "上滑取消,松开确定" : "按住说话",
                                          color: CusColorGrey.grey500,
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                );
                              }), nType: DlgType.en_DlgBottomSheet)
                                  .showDlg();
                            })
                      ],
                    )),
              )
      ],
    );
  }

  //点评
  _buildCommentBtn() {
    return CusPadding(
      Container(
          height: ScreenMgr.setHeight(130.0),
          padding: EdgeInsets.fromLTRB(ScreenMgr.scrWidth * 0.1, 0.0, ScreenMgr.scrWidth * 0.1, 0.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    RouteMgr().pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: CusColorGrey.grey400),
                    child: Text(
                      "取 消",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              HSpacer(
                ScreenMgr.setAdapterSize(100.0),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    List<File> lsFile=[];
                    if(filePath!=""){
                      lsFile.add(File(filePath));
                    }
                    await this.provider.getCommentReq(widget.student_homework_id, nScoreId,
                        strContent: _textEditingController.text, nTime: nPlayTime, lsfile: lsFile).then((value) {
                          showToast("$value");
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0), color: Color.fromARGB(255, 58, 158, 255)),
                    child: Text(
                      "点 评",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )),
      t: ScreenMgr.scrHeight * 0.75,
    );
  }

  _buildImgVideo() {
    return Container(
        padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
        alignment: Alignment.topCenter,
        height: func_ShowPicHeight(nImgVideoCnt) + ScreenMgr.setAdapterSize(30.0),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () async {
                  _imgVideoHelper.preView(index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(child: _imgVideoHelper.buildImgVideo(index)),
                ),
              );
            },
            itemCount: nImgVideoCnt));
  }
} //end_class
