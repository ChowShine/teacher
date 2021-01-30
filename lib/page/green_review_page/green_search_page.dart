//搜索页面

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_func.dart';
import '../common/common_param.dart';
import 'green_details_page.dart';
import '../provider/green_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/green_input_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  GreenSearchProvider provider = new GreenSearchProvider();
  @override
  void initState() {
    // TODO: implement initState

    this.provider.init();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          _textEditController.text.isNotEmpty) {
        this.provider.setStateType(LoadType.en_Loading);
        await this.provider.getSearchReq(_textEditController.text);
      }
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: ScreenMgr.setHeight(130.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(100.0)), color: CusColorGrey.grey100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(bottom: ScreenMgr.setAdapterSize(8.0)),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _textEditController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      hintText: "请输入学生姓名",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: CusFontSize.size_16),
                    ),
                    onSubmitted: (value) async {
                      if (_textEditController.text.isEmpty) {
                        showToast("搜索关键字不能为空");
                      } else {
                        this.provider.init();
                        await this.provider.getSearchReq(_textEditController.text);
                        _textEditController.text = "";
                      }
                    },
                  ),
                ))
              ],
            )),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: CusText("搜索"),
            onPressed: () async {
              if (_textEditController.text.isEmpty) {
                showToast("搜索关键字不能为空");
              } else {
                this.provider.init();
                await this.provider.getSearchReq(_textEditController.text);
                _textEditController.text = "";
              }
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ChangeNotifierProvider<BaseListProvider<InputData>>(
        create: (_) => provider,
        child: Consumer<BaseListProvider<InputData>>(
          builder: (_, provider, child) => this.provider.list.isEmpty
              ? func_buildNonData()
              : Container(
                  padding:
                      EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
                  color: Colors.white,
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (_, index) => index < this.provider.list.length
                            ? InkWell(
                                onTap: () {
                                  //RouteMgr().push(context, InputDetailsPage(1, this.provider.list[index].studentId));
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
                                  height: ScreenMgr.setAdapterSize(200.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CusText(
                                            "${this.provider.list[index]?.username ?? ""}",
                                            size: CusFontSize.size_17,
                                          ),
                                          CusText(
                                            "${this.provider.list[index]?.gradeClass ?? ""}",
                                            size: CusFontSize.size_15,
                                            color: CusColorGrey.grey400,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: ScreenMgr.setAdapterSize(90.0),
                                        padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: this.provider.list[index]?.isFinish == "已录入"
                                              ? Color.fromARGB(255, 55, 158, 255)
                                              : Color.fromARGB(255, 200, 208, 220),
                                        ),
                                        child: Text(
                                          "${this.provider.list[index]?.isFinish ?? ""}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : LoadMoreWidget(this.provider.stateType),
                        separatorBuilder: (_, index) => VSpacer(
                              ScreenMgr.setAdapterSize(3.0),
                              color: CusColorGrey.grey100,
                            ),
                        itemCount: this.provider.list.length + 1),
                  ),
                ),
        ));
  }
} //end_class
