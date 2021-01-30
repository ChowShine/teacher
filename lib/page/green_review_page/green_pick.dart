import 'dart:convert';
import 'dart:typed_data';

///从手机中选择图片 视频 音频
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 20:21
///
import 'package:flutter/material.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../common/common_param.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/opration_file.dart';

class MultiAssetsPage extends StatefulWidget {
  final String strName; //学生名，用于区分上传队列
  final int id;
  final int nMsgId;
  final int nExistNum;
  MultiAssetsPage({this.strName, this.id, this.nMsgId,this.nExistNum});
  @override
  _MultiAssetsPageState createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<MultiAssetsPage> {
  int maxAssetsCount = 0;
  List<AssetEntity> assets = <AssetEntity>[];

  @override
  void initState() {
    // TODO: implement initState
    if (!mp_VideoImgParam.containsKey(widget.id))
      maxAssetsCount = MAX_IAMGE_VIDEO;
    else
      maxAssetsCount = MAX_IAMGE_VIDEO - widget.nExistNum;//mp_VideoImgParam[widget.id]?.length ?? 0;
    super.initState();
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          icon: '🖼️',
          name: '相册',
          description: '',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
            );
          },
        ),
        PickMethodModel(
          icon: '🎞',
          name: '视频',
          description: '',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.video,
            );
          },
        ),
        PickMethodModel(
          icon: '📷',
          name: '拍摄',
          description: '',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            final AssetEntity result = await CameraPicker.pickFromCamera(context,
                isAllowRecording: true,
                resolutionPreset: ResolutionPreset.high,
                maximumRecordingDuration: const Duration(seconds: 10));
            List<AssetEntity> ls = [];
            if (result != null) {
              ls.add(result);
            }
            return ls;
          },
        ),
      ];

  Widget methodItemBuilder(BuildContext _, int index) {
    final PickMethodModel model = pickMethods[index];
    return InkWell(
      onTap: () async {
        final List<AssetEntity> result = await model.method(context, assets);
        if (result != null && result.isNotEmpty && result != assets) {
          assets = List<AssetEntity>.from(result);

          Navigator.pop(context);

          //打开数据库
          await OpDataBase.openTable("tb_${widget.id}");

          //获得缩略图
          List<VideoImgParam> list = [];
          for (int i = 0; i < assets.length; i++) {
            VideoImgParam param = await getVideoImgFromAssetEntity(widget.strName, widget.id, assets[i], widget.nMsgId);
            g_lsSave.add(param);
            list.add(param);
          }
          Constants.eventBus.emit("addImageVideo", list);
        } else {
          Navigator.pop(context);
          Constants.eventBus.emit("addImageVideo", []);//为了让保存按钮更新为true。有时速度太快保存出问题
        }
      },
      child: Container(
        height: ScreenMgr.setAdapterSize(200.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: Center(
                  child: Text(
                    model.icon,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            Text(
              model.name,
              style: const TextStyle(
                fontSize: 18.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget get methodListView => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: pickMethods.length,
            itemBuilder: methodItemBuilder,
            separatorBuilder: (_, index) => Divider(
              height: 1.0,
              color: CusColorGrey.grey400,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          methodListView,
        ],
      ),
    );
  }
}


/////////////////////////////////////////////////
class PickMethodModel {
  const PickMethodModel({
    this.icon,
    this.name,
    this.description,
    this.method,
  });

  final String icon;
  final String name;
  final String description;
  final Future<List<AssetEntity>> Function(BuildContext, List<AssetEntity>) method;
}
