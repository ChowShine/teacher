import 'common_param.dart';
import 'common_func.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'full_play.dart';
import 'package:videochat_package/constants/photo_view_gallery.dart';

class ImageVideoHelper {
  final List<String> lsAddress;
  final BuildContext context;
  ImageVideoHelper(this.lsAddress, this.context) {
    initImgVideo();
  }

  Map<int, GlobalKey<CacheVideoPlayerWidgetState>> _mapKey = {}; //视频 key
  List<VideoImgParam> lsVideoImgParam = [];

  initImgVideo() {
    int i = 0;
    if (this.lsAddress != null && this.lsAddress.isNotEmpty) {
      this.lsAddress.forEach((element) {
        if (matchImg(element)) {
          lsVideoImgParam.add(VideoImgParam(strAddress: "$element", type: 0));
        } else {
          _mapKey[i] = GlobalKey<CacheVideoPlayerWidgetState>();
          lsVideoImgParam.add(
            VideoImgParam(
                videoCtrl: CacheVideoPlayerWidget(_mapKey[i], "$element", () {}), strAddress: "$element", type: 1),
          );
        }
        i++;
      });
    }
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
}
