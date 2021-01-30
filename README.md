# Example of calling platform services from Flutter

This project demonstrates how to connect a Flutter app to platform specific services.

You can read more about
[accessing platform and third-party services in Flutter](https://flutter.io/platform-channels/).

## iOS
You can use the commands `flutter build` and `flutter run` from the app's root
directory to build/run the app or you can open `ios/Runner.xcworkspace` in Xcode
and build/run the project as usual.

## Android

You can use the commands `flutter build` and `flutter run` from the app's root
directory to build/run the app or to build with Android Studio, open the
`android` folder in Android Studio and build the project as usual.


flutter build apk --flavor=blinddate

ios
flutter build ios
cd ios
pod install --repo-update
pod repo update
flutter build ios




======================

前期准备(安装过可以省略)：1.查看ruby 2.更新 gem 3.安装cocoapods。
给个链接：http://www.jianshu.com/p/82a6d6c7b000
然后就是以下步骤：
1.pod repo remove master
2.pod repo add master https://gitcafe.com/akuandev/Specs.git
//会出现[!] To setup the master specs repo, please run `pod setup`.不管它，继续。
3.git clone https://git.coding.net/CocoaPods/Specs.git ~/.cocoapods/repos/master
//3步需要等三两分钟才开始下载，然后就是坐等十来分钟下载时间。
4.pod repo update
//到这结束前后大概20来分钟，试一下：pod search masonry
//再次感谢教程。



https://blog.csdn.net/iotjin/article/details/81604034

其实真正慢的原因并不在pod命令，而是在于github上的代码库访问速度慢，那么就知道真正的解决方案就是要加快git命令的速度。 
我使用Shadowsocks代理，默认代理端口为1080，配置好代理之后去终端输入git配置命令，命令如下

git config --global http.proxy socks5://127.0.0.1:1080
上面的命令是给git设置全局代理，但是我们并不希望国内git库也走代理，而是只需要github上的代码库走代理，命令如下

git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
如此就从根本上解决了问题，下面附上设置代理前后git命令的速度 
代理前 
代理前
代理后 
这里写图片描述

体验xiu的一下吧！

（ps：如果要恢复/移除上面设置的git代理，使用如下命令

git config --global --unset http.proxy
git config --global --unset http.https://github.com.proxy


G:\dev flutter\fluttersdk\.pub-cache\hosted\pub.flutter-io.cn\flutter image- 2.0.0\lib\network.dart
中73行函数 ImageStreamCompleter load(NetworkImageWithRetry key,DecoderCallback decode)增加参数DecoderCallback decode

G:\dev_ flutter\fluttersdk\.pub-cache\hosted\pub.flutter-io.cn\cached network_ image- 1.1.3\lib\src\cached_ network_ image_ provider.dart
中42行函数 ImageStreamCompleter load(CachedNetworkImageProvider key,DecoderCallback decode) 增加参数DecoderCallback decode