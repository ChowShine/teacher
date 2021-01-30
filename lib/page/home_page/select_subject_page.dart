//选择学科

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common/common_param.dart';
import '../common/common_func.dart';
import 'package:videochat_package/constants/customMgr/widgetMgr.dart';
import 'package:videochat_package/constants/customMgr/screenMgr.dart';
import 'package:oktoast/oktoast.dart';

class SelectSubjectPage extends StatefulWidget {
  final List<String> lsSubjects;
  final String strSelSub; //已选择学科
  SelectSubjectPage(this.lsSubjects, this.strSelSub);
  @override
  _SelectSubjectPageState createState() => _SelectSubjectPageState();
}

class _SelectSubjectPageState extends State<SelectSubjectPage> {
  Map<String, bool> mp_SubjectSelect = {};

  @override
  void initState() {
    // TODO: implement initState
    widget.lsSubjects.forEach((element) {
      if (element == widget.strSelSub)
        mp_SubjectSelect[element] = true;
      else
        mp_SubjectSelect[element] = false;
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
    return WillPopScope(
      onWillPop: () async {
        //点击系统返回，直接返回""
        Navigator.pop(context, "");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CusText(
            "选择学科",
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
                  if (_getSelectCnt() == 0) {
                    showToast("请选择学科");
                  } else {
                    Navigator.pop(context, _getSelectSubject());
                  }
                },
                label: CusText(
                  "确定(${_getSelectCnt()})",
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 88, 158, 255)),
            HSpacer(
              ScreenMgr.setAdapterSize(30.0),
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: ListView.builder(
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  mp_SubjectSelect[widget.lsSubjects[index]] = !mp_SubjectSelect[widget.lsSubjects[index]];
                  if (mp_SubjectSelect[widget.lsSubjects[index]]) {
                    for (int i = 0; i < mp_SubjectSelect.length; i++) {
                      if (i != index) mp_SubjectSelect[widget.lsSubjects[i]] = false;
                    }
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: CusColorGrey.grey200, width: 0.5))),
                height: ScreenMgr.setAdapterSize(150.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    func_buildImageAsset(
                        mp_SubjectSelect[widget.lsSubjects[index]] ? "fs_select.png" : "fs_un_select.png",
                        dScale: 2.4),
                    HSpacer(
                      ScreenMgr.setAdapterSize(50.0),
                    ),
                    CusText(
                      "${widget.lsSubjects[index]}",
                      size: CusFontSize.size_16,
                    ),
                    Spacer()
                  ],
                ),
              ),
            );
          },
          itemCount: widget.lsSubjects.length,
        ),
      ),
    );
  }

  _getSelectCnt() {
    int nCnt = 0;
    mp_SubjectSelect.forEach((key, value) {
      if (value) nCnt++;
    });
    return nCnt;
  }

  _getSelectSubject() {
    String strSubject = "";
    mp_SubjectSelect.forEach((key, value) {
      if (value) {
        strSubject = key;
        return;
      }
    });
    return strSubject;
  }
} //end_class
