//作业详情

import 'package:flutter/material.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/full_play.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/constants/customMgr/screenMgr.dart';
import '../common/common_param.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:videochat_package/constants/photo_view_gallery.dart';
import 'comment_homework_page.dart';
import '../model/homeword_details_model.dart';
import '../provider/homework_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/customMgr/dlgMgr.dart';

class HomeworkDetailsPage extends StatefulWidget {
  final int homework_id;
  HomeworkDetailsPage(this.homework_id);
  @override
  _HomeworkDetailsPageState createState() => _HomeworkDetailsPageState();
}

class _HomeworkDetailsPageState extends State<HomeworkDetailsPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController = new ScrollController();
  TabController _tabController;
  bool _isExpanded = false;
  int nImgVideoCnt = 0;
  int nTabIndex = 0;
  HomeWorkDetailsProvider provider = new HomeWorkDetailsProvider();
  List<VideoImgParam> lsVideoImgParam = []; //图片视频列表
  Map<int, GlobalKey<CacheVideoPlayerWidgetState>> _mapKey = {}; //视频 key
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      await this.provider.getHomeWorkDetailsReq(widget.homework_id);
      nImgVideoCnt = this.provider.instance?.data?.files?.length ?? 0;
      initImgVideo();
    });
    _tabController = TabController(length: 2, vsync: this);
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.pixels > 0) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  initImgVideo() {
    int i = 0;
    if (this.provider.instance?.data?.files != null && this.provider.instance.data.files.isNotEmpty) {
      this.provider.instance.data.files.forEach((element) {
        if (matchImg(element.address)) {
          lsVideoImgParam.add(VideoImgParam(strAddress: "${element.address}", type: 0));
        } else {
          _mapKey[i] = GlobalKey<CacheVideoPlayerWidgetState>();
          lsVideoImgParam.add(
            VideoImgParam(
                videoCtrl: CacheVideoPlayerWidget(_mapKey[i], "${element.address}", () {
                  setState(() {});
                }),
                strAddress: "${element.address}",
                type: 1),
          );
        }
        i++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(appBarTheme: AppBarTheme(color: Color.fromARGB(255, 87, 158, 255))),
        child: Scaffold(
          body: ChangeNotifierProvider<BaseProvider<HomeWorkDetailsModel>>(
            create: (_) => provider,
            child: Consumer<BaseProvider<HomeWorkDetailsModel>>(
              builder: (_, provider, child) => this.provider.instance == null
                  ? LoadingDialog(
                      color: Colors.black54,
                    )
                  : Stack(
                      children: [
                        ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(
                                pinned: true,
                                elevation: 0,
                                expandedHeight: _isExpanded
                                    ? ScreenMgr.setAdapterSize(100.0 * 6.5) + func_ShowPicHeight(nImgVideoCnt)
                                    : ScreenMgr.setAdapterSize(100.0 * 6.5),
                                flexibleSpace: FlexibleSpaceBar(
                                    title: Text(
                                      '作业详情',
                                      style: TextStyle(fontSize: CusFontSize.size_15),
                                    ),
                                    centerTitle: true,
                                    background: Stack(
                                      children: [
                                        Container(color: CusColorGrey.grey200),
                                        Container(
                                          width: ScreenMgr.scrWidth,
                                          height: ScreenMgr.setAdapterSize(500.0),
                                          child: func_buildImageAsset(
                                            "fs_home_bk1.png",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        CusPadding(
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(30.0)),
                                            child: Container(
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                          ScreenMgr.setAdapterSize(30.0), 0.0),
                                                      alignment: Alignment.centerLeft,
                                                      child: CusText(
                                                        "${this.provider.instance?.data?.homeWorkRelease?.name ?? ""}",
                                                        fontWeight: FontWeight.bold,
                                                        size: CusFontSize.size_17,
                                                      )),
                                                  Container(
                                                      padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                          ScreenMgr.setAdapterSize(30.0), 0.0),
                                                      alignment: Alignment.centerLeft,
                                                      child: showHtmlView(this
                                                              .provider
                                                              .instance
                                                              ?.data
                                                              ?.homeWorkRelease
                                                              ?.details ??
                                                          "") /*CusText(
                                                "把第六课第一课时知识点抄━遍",
                                                size: CusFontSize.size_16,
                                              ),*/
                                                      ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                        ScreenMgr.setAdapterSize(30.0), 0.0),
                                                    child: Row(
                                                      children: [
                                                        func_buildImageAsset("fs_end_time.png", dScale: 2.5),
                                                        HSpacer(ScreenMgr.setAdapterSize(10.0)),
                                                        CusText(
                                                          "截止时间${this.provider.instance?.data?.homeWorkRelease?.endTime ?? ""}",
                                                          size: CusFontSize.size_14,
                                                          color: CusColorGrey.grey400,
                                                        ),
                                                        Spacer()
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: _buildHomeworkImgVideo(),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                                        ScreenMgr.setAdapterSize(50.0), 0.0),
                                                    child: Row(
                                                      children: [
                                                        _isExpanded
                                                            ? CusText(
                                                                "${this.provider.instance?.data?.homeWorkRelease?.username}老师 ${this.provider.instance?.data?.homeWorkRelease?.gradeClass} ${this.provider.instance?.data?.homeWorkRelease?.dtime?.substring(5, 19)}",
                                                                color: CusColorGrey.grey400,
                                                              )
                                                            : Container(
                                                                height: 0.0,
                                                              ),
                                                        Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _isExpanded = !_isExpanded;
                                                            });
                                                          },
                                                          child: func_buildImageAsset(
                                                              !_isExpanded ? "fs_Expanded.png" : "fs_Non_Expanded.png"),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  _isExpanded
                                                      ? VSpacer(
                                                          ScreenMgr.setAdapterSize(50.0),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          l: ScreenMgr.setAdapterSize(30.0),
                                          r: ScreenMgr.setAdapterSize(30.0),
                                          t: ScreenMgr.setAdapterSize(240.0),
                                          b: ScreenMgr.setAdapterSize(30.0),
                                        ),
                                        CusPadding(
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: CusText(
                                              "作业详情",
                                              size: CusFontSize.size_18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          t: ScreenMgr.setAdapterSize(120.0),
                                        ),
                                      ],
                                    )),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: StickyTabBarDelegate(
                                  child: Container(
                                    height: ScreenMgr.setAdapterSize(100.0),
                                    color: CusColorGrey.grey200,
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                ScreenMgr.setAdapterSize(30.0),
                                              ),
                                              topRight: Radius.circular(
                                                ScreenMgr.setAdapterSize(30.0),
                                              ))),
                                      child: TabBar(
                                        onTap: (index) {
                                          setState(() {
                                            nTabIndex = (nTabIndex + 1) % 2;
                                          });
                                        },
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.grey,
                                        controller: this._tabController,
                                        indicatorWeight: 5.0,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicatorPadding: EdgeInsets.fromLTRB(
                                            ScreenMgr.setAdapterSize(220.0), 0.0, ScreenMgr.setAdapterSize(220.0), 0.0),
                                        tabs: <Widget>[
                                          Tab(
                                            text: '已交(${this.provider.instance?.data?.already?.length ?? 0})',
                                          ),
                                          Tab(text: '未交(${this.provider.instance?.data?.none?.length ?? 0})'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _buildIsSendHomework()
                            ],
                          ),
                        ),
                        Visibility(
                          visible: nTabIndex == 1,
                          child: _buildNotice(),
                        )
                      ],
                    ),
            ),
          ),
        ));
  }

  //作业
  _buildIsSendHomework() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 0.95,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            color: CusColorGrey.grey200,
            padding: EdgeInsets.only(
                left: index % 3 == 0 ? ScreenMgr.setAdapterSize(30.0) : 0,
                right: index % 3 == 2 ? ScreenMgr.setAdapterSize(30.0) : 0),
            child: InkWell(
              onTap: () {
                if (nTabIndex == 0) {
                  RouteMgr().push(
                      context,
                      CommentHomeworkPage(this.provider.instance?.data?.already[index].homeWorkStudentId,
                          this.provider.instance?.data?.already[index].username));
                }
              },
              child: 
                  Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              width: ScreenMgr.setAdapterSize(200.0),
                              height: ScreenMgr.setAdapterSize(200.0),
                              child: ClipOval(
                                child: Image.network(
                                    "${nTabIndex == 0 ? this.provider.instance?.data?.already[index].head ?? "" : this.provider.instance?.data?.none[index].head ?? ""}"),
                              )),
                          CusText(
                            "${nTabIndex == 0 ? this.provider.instance?.data?.already[index].username ?? "" : this.provider.instance?.data?.none[index].username ?? ""}",
                            size: CusFontSize.size_16,
                          ),
                          nTabIndex == 0
                              ? CusText(
                                  "${this.provider.instance?.data?.already[index].scoreName == "" ? "未评" : this.provider.instance?.data?.already[index].scoreName}",
                                  size: CusFontSize.size_16,
                                  color: this.provider.instance?.data?.already[index].scoreName == ""
                                      ? Colors.blue
                                      : CusColorGrey.grey400,
                                )
                              : Container()
                        ],
                      )),

            ),
          );
        },
        childCount: nTabIndex == 0
            ? this.provider.instance?.data?.already?.length ?? 0
            : this.provider.instance?.data?.none?.length ?? 0,
      ),
    );
  }

  _buildHomeworkImgVideo() {
    if (!_isExpanded)
      return Container(
        height: 0.0,
      );
    return nImgVideoCnt == 1
        ? Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    await preView(0);
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: func_ShowPicHeight(nImgVideoCnt),
                      child: buildImgVideo(0)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          )
        : Container(
            margin: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60.0), 0.0, ScreenMgr.setAdapterSize(60.0), 0.0),
            height: func_ShowPicHeight(nImgVideoCnt)*1.1,
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      await preView(index);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(child: buildImgVideo(index)),
                    ),
                  );
                },
                itemCount: nImgVideoCnt),
          );
  }

  //每个视频 图片
  buildImgVideo(int index) {
    return lsVideoImgParam[index].type == 0
        ? CachedNetworkImage(
            imageUrl: "${lsVideoImgParam[index].strAddress}",
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
          )
        : Stack(
            children: [
              Center(
                child: lsVideoImgParam[index].videoCtrl,
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
            ],
          );
  }

  //预览
  preView(int index) async {
    List<String> images = [];
    List<bool> localType = [];
    int count = 0;
    for (int i = 0; i < lsVideoImgParam.length; i++) {
      var item = lsVideoImgParam[i];
      if (item != null && item.type == 0) {
        if (i < index) count++;
        images.add(item.strAddress);
        localType.add(false);
      }
    }
    if (lsVideoImgParam[index].type == 0) {
      await Navigator.of(context).push(new FadeRoute(
          page: PhotoViewGalleryScreen(
        images: images, //传入图片list
        index: count, //传入当前点击的图片的index
        heroTag: "$count",
        localType: localType,
      )));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VideoFullPage(lsVideoImgParam[index].strAddress);
      }));
    }
  }

  //未交作业 一键提醒学生
  _buildNotice() {
    return CusPadding(
      Container(
          height: ScreenMgr.setHeight(130.0),
          padding: EdgeInsets.fromLTRB(ScreenMgr.scrWidth * 0.15, 0.0, ScreenMgr.scrWidth * 0.15, 0.0),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () async {},
            child: Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Color.fromARGB(255, 58, 158, 255)),
              child: Text(
                "一键提醒",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
      t: ScreenMgr.scrHeight * 0.85,
    );
  }
} //end_class

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => ScreenMgr.setAdapterSize(100.0); //this.child.preferredSize.height;

  @override
  double get minExtent => ScreenMgr.setAdapterSize(100.0); //this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
