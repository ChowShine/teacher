//布置作业 选择的学生

import 'package:flutter/material.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/common_param.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/constants/customMgr/widgetMgr.dart';
import 'package:oktoast/oktoast.dart';

class SelectStudentPage extends StatefulWidget {
  final Map<String, List<String>> mpGradeClassStu; //key：班级  value：学生列表
  final Map<String, List<String>> mpGradeClassHead; //key：班级  value：学生头像列表
  final List<String> lsGradeClass; //班级列表，可能1个元素
  final List<String> lsIsHaveGrade;//已经选择的班级，这是页面此班级为选择状态
  SelectStudentPage(this.mpGradeClassStu,this.mpGradeClassHead, this.lsGradeClass,this.lsIsHaveGrade);
  @override
  _SelectStudentState createState() => _SelectStudentState();
}

class _SelectStudentState extends State<SelectStudentPage> {
  Map<String, bool> mp_isExpanded = {}; //key 年级班级 value 是否展开
  Map<String, bool> mp_isGradeChoose = {}; //key 年级班级 value 是否选择
  Map<String, List<bool>> mp_isStuChoose = {}; //key 年级班级 value 每个学生是否被选择
  Map<String, List<String>> mpGradeClassStudent = {}; //key班级  value：学生列表
  Map<String, List<String>> mpGradeClassHead = {}; //key班级  value：学生列表
  @override
  void initState() {
    // TODO: implement initState

    if (widget.lsGradeClass != null && widget.lsGradeClass.isNotEmpty) {
      widget.lsGradeClass.forEach((element) {
        if (widget.mpGradeClassStu.containsKey(element)) {
          mpGradeClassStudent[element] = widget.mpGradeClassStu[element];
          mpGradeClassHead[element]=widget.mpGradeClassHead[element];
        }
      });
    }

    mpGradeClassStudent.forEach((key, value) {
      mp_isExpanded[key] = false;
      mp_isGradeChoose[key] = false;
      mp_isStuChoose[key] = [];
      value.forEach((element) {
        mp_isStuChoose[key].add(false);
      });
    });

    if(widget.lsIsHaveGrade.isNotEmpty){
      widget.lsIsHaveGrade.forEach((element) {
        if(mp_isGradeChoose.containsKey(element)){
          mp_isGradeChoose[element]=true;
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,<String>[]);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CusText(
            "选择班级/学生",
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
                List<String> lsSel=[];
                mp_isGradeChoose.forEach((key, value) {
                  if(value)
                    lsSel.add(key);
                });
                Navigator.pop(context,lsSel);
              },
              backgroundColor: Color.fromARGB(255, 58, 158, 255),
              label: Text(
                "确定",
                style: TextStyle(color: Colors.white),
              ),
            ),
            HSpacer(
              ScreenMgr.setAdapterSize(60.0),
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    List<Widget> lsTemp = new List();
    mpGradeClassStudent.forEach((key, value) {
      lsTemp.add(
        SliverPersistentHeader(
          pinned: false,
          floating: false,
          delegate: CusSliverAppBarDelegate(
            minHeight: ScreenMgr.setAdapterSize(150.0),
            maxHeight: ScreenMgr.setAdapterSize(150),
            child: InkWell(
              onTap: () {},
              child: Container(
                //头部
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: CusColorGrey.grey300, width: 0.2)),
                  color: Colors.white,
                ),
                height: ScreenMgr.setAdapterSize(150.0),
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          mp_isGradeChoose[key] = !mp_isGradeChoose[key];

                          if (mp_isGradeChoose[key]) {
                            for (int i = 0; i < mp_isStuChoose[key].length; i++) {
                              mp_isStuChoose[key][i] = true;
                            }
                          } else {
                            for (int i = 0; i < mp_isStuChoose[key].length; i++) {
                              mp_isStuChoose[key][i] = false;
                            }
                          }
                        });
                      },
                      child: func_buildImageAsset(mp_isGradeChoose[key] ? "fs_select.png" : "fs_un_select.png",
                          dScale: 2.4),
                    ),
                    HSpacer(
                      ScreenMgr.setAdapterSize(20.0),
                    ),
                    CusText(
                      key,
                      size: CusFontSize.size_18,
                    ),
                    Spacer(),
                    CusText(
                      "${_getSelectStu(key)}/${value.length}",
                      color: CusColorGrey.grey400,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          mp_isExpanded[key] = !mp_isExpanded[key];
                        });
                      },
                      child: Icon(!mp_isExpanded[key] ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      if (mp_isExpanded[key] && value.length > 0) {
        lsTemp.add(SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(80.0), ScreenMgr.setAdapterSize(20.0),
                    ScreenMgr.setAdapterSize(80.0), ScreenMgr.setAdapterSize(20.0)),
                height: ScreenMgr.setAdapterSize(150.0),
                child: InkWell(
                  onTap: () {//暂时不选择学生
                /*    if(mp_isGradeChoose[key])
                    setState(() {
                      mp_isStuChoose[key][index] = !mp_isStuChoose[key][index];
                    });
                    else showToast("请选择年级班级");*/
                  },
                  child: Row(
                    children: [
                      HSpacer(
                        ScreenMgr.setAdapterSize(50.0),
                      ),
                    /*  func_buildImageAsset(mp_isStuChoose[key][index] ? "fs_select.png" : "fs_un_select.png",
                          dScale: 2.4),*/
                      HSpacer(
                        ScreenMgr.setAdapterSize(20.0),
                      ),
                      ClipOval(
                        child: Image.network(mpGradeClassHead[key][index]),
                      ),
                      HSpacer(
                        ScreenMgr.setAdapterSize(10.0),
                      ),
                      CusText(
                        value[index],
                        size: CusFontSize.size_16,
                      )
                    ],
                  ),
                ));
          }, childCount: value.length),
        ));
      }
    });

    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: CustomScrollView(
        slivers: lsTemp,
      ),
    );
  }

  _getSelectStu(String key) {
    int nCnt = 0;
    mp_isStuChoose[key].forEach((element) {
      if (element) nCnt++;
    });
    return nCnt;
  }
} //end_class
