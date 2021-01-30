//作业管理

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/common_param.dart';
import 'package:teacher/page/home_page/assignment_page.dart';
import 'package:videochat_package/constants/constants.dart';
import 'homework_details_page.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/homework_model.dart';
import 'package:provider/provider.dart';
import '../provider/homework_provider.dart';
import 'package:videochat_package/constants/customMgr/dlgMgr.dart';

class HomeworkMgrPage extends StatefulWidget {
  @override
  _HomeworkMgrPageState createState() => _HomeworkMgrPageState();
}

class _HomeworkMgrPageState extends State<HomeworkMgrPage> {
  ScrollController _controller = new ScrollController();
  bool isExpanded = false;
  HomeWorkProvider provider = HomeWorkProvider();
  int grade_id = 0;
  int class_id = 0;
  @override
  void initState() {
    // TODO: implement initState
    this.provider.init();
    Future.delayed(Duration.zero, () async {
      await this.provider.getHomeWorkReq();
    });
    _controller.addListener(callback_listen);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(callback_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  //回调函数
  callback_listen() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      this.provider.setStateType(LoadType.en_Loading);
      await this.provider.getHomeWorkReq(grade_id: grade_id, class_id: class_id);
    }
  }

  _buildBody() {
    return ChangeNotifierProvider<BaseListProvider<DataInfo>>(
        create: (_) => provider,
        child: Consumer<BaseListProvider<DataInfo>>(
          builder: (_, provider, child) => this.provider.list.length == 0
              ? LoadingDialog(
                  color: Colors.black54,
                  text: "数据加载中...",
                )
              : Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: CustomScrollView(
                        controller: _controller,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1.0, color: CusColorGrey.grey100)),
                                color: Colors.white,
                              ),
                              height: ScreenMgr.setAdapterSize(300.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        RouteMgr().pop(context);
                                      },
                                      icon: Icon(
                                        Icons.chevron_left,
                                        size: 30.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Center(
                                        child: Row(
                                      children: [
                                        Spacer(),
                                        CusText(
                                          "${this.provider.strGradeClass}",
                                          size: CusFontSize.size_18,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isExpanded = !isExpanded;
                                            });
                                          },
                                          child: func_buildImageAsset(
                                              !isExpanded ? "fs_Expanded.png" : "fs_Non_Expanded.png"),
                                        ),
                                        Spacer()
                                      ],
                                    )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: (){
                                        RouteMgr().push(context, AssignmentPage());
                                      },
                                      child: Center(
                                        child: func_buildImageAsset("fs_do_assignment.png", dScale: 2.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              color: CusColorGrey.grey100,
                              height: ScreenMgr.setAdapterSize(50.0),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((_, index) {
                              return index < this.provider.list.length
                                  ? Container(
                                      color: CusColorGrey.grey100,
                                      padding: EdgeInsets.fromLTRB(
                                          ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              RouteMgr().push(context, HomeworkDetailsPage(this.provider.list[index].id));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(ScreenMgr.setAdapterSize(30.0))),
                                              child: Container(
                                                height: ScreenMgr.setAdapterSize(430.0),
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0),
                                                            0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                                        alignment: Alignment.centerLeft,
                                                        child: CusText(
                                                          "${this.provider.list[index].name}",
                                                          fontWeight: FontWeight.bold,
                                                          size: CusFontSize.size_17,
                                                        )),
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0),
                                                            0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          children: [
                                                            showHtmlView("${this.provider.list[index].details}"),
                                                            /* CusText(
                                                                  "把第六课第一课时知识点抄━遍",
                                                                  //fontWeight: FontWeight.bold,
                                                                  size: CusFontSize.size_15,
                                                                ),*/
                                                            Spacer(),
                                                            Container(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    text: "",
                                                                    style: TextStyle(),
                                                                    children: <InlineSpan>[
                                                                      TextSpan(
                                                                          text: "${this.provider.list[index].count}",
                                                                          style: TextStyle(
                                                                              color: Color.fromARGB(255, 86, 158, 254),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: CusFontSize.size_20)),
                                                                      TextSpan(
                                                                          text:
                                                                              "/${this.provider.list[index].allCount} ",
                                                                          style: TextStyle(
                                                                              color: Color.fromARGB(255, 137, 137, 137),
                                                                              fontSize: CusFontSize.size_15)),
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                          ScreenMgr.setAdapterSize(30.0), 0.0),
                                                      child: CusText(
                                                        "10-20 14:25:00",
                                                        color: CusColorGrey.grey500,
                                                        size: 14.0,
                                                      ),
                                                      alignment: Alignment.centerLeft,
                                                    ),
                                                    DottedLine(
                                                      color: CusColorGrey.grey200,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                          ScreenMgr.setAdapterSize(30.0), 0.0),
                                                      child: Row(
                                                        children: [
                                                          func_buildImageAsset("fs_end_time.png", dScale: 2.5),
                                                          HSpacer(ScreenMgr.setAdapterSize(10.0)),
                                                          CusText(
                                                            "截止时间${this.provider.list[index].endTime}",
                                                            size: CusFontSize.size_14,
                                                            color: CusColorGrey.grey400,
                                                          ),
                                                          Spacer()
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          VSpacer(
                                            ScreenMgr.setAdapterSize(30.0),
                                          )
                                        ],
                                      ),
                                    )
                                  : LoadMoreWidget(this.provider.stateType);
                            }, childCount: this.provider.list.length + 1),
                          )
                        ],
                      ),
                    ),
                    CusPadding(
                      //选择班级弹出的列表下部 透明黑色
                      Visibility(
                        visible: isExpanded,
                        child: InkWell(
                          //退出展开
                          onTap: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
                          child: Container(
                            height: ScreenMgr.scrHeight - ScreenMgr.setAdapterSize(300.0),
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      t: ScreenMgr.setAdapterSize(300.0),
                    ),
                    CusPadding(
                      //选择班级弹出的列表
                      Visibility(
                        visible: isExpanded,
                        child: Container(
                            height: ScreenMgr.setAdapterSize(500.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                  ScreenMgr.setAdapterSize(30.0),
                                ),
                                bottomRight: Radius.circular(
                                  ScreenMgr.setAdapterSize(30.0),
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: CupertinoScrollbar(
                                child: ListView.builder(
                                  itemBuilder: (_, index) => InkWell(
                                    onTap: () async {
                                      List<int> lsGrade = praseGrade(this.provider.lsClass[index]);
                                      if (lsGrade != null && lsGrade.length == 2) {
                                        this.provider.initData();
                                        await this.provider.getHomeWorkReq(grade_id: lsGrade[0], class_id: lsGrade[1]);
                                        setState(() {
                                          isExpanded = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenMgr.setAdapterSize(100.0), 0.0, ScreenMgr.setAdapterSize(100.0), 0.0),
                                        height: ScreenMgr.setAdapterSize(150.0),
                                        child: CusText(
                                          "${this.provider.lsClass[index]}",
                                          size: CusFontSize.size_17,
                                          color: this.provider.lsClass[index] == this.provider.strGradeClass
                                              ? Colors.black
                                              : CusColorGrey.grey400,
                                        )),
                                  ),
                                  itemCount: this.provider.lsClass.length,
                                ),
                              ),
                            )),
                      ),
                      t: ScreenMgr.setAdapterSize(300.0),
                    )
                  ],
                ),
        ));
  }



  //解析年级 班级 一年级1班 得到 1和1
  final grade = ["一", "二", "三", "四", "五", "六"];
  final gradeNum = ["1", "2", "3", "4", "5", "6"];
  praseGrade(String str) {
    List<int> lsGradeClass = [];
    String strTemp = str.substring(0, 1);
    for (int i = 0; i < grade.length; i++) {
      if (grade[i] == strTemp) {
        lsGradeClass.add(int.parse(gradeNum[i]));
        break;
      }
    }
    strTemp = str.substring(3, 4);
    lsGradeClass.add(int.parse(strTemp));
    grade_id = lsGradeClass[0];
    class_id = lsGradeClass[1];
    return lsGradeClass;
  }
} //end_class
