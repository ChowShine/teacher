package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.brzhang.dalipush.DalipushPlugin;
import pl.ukaszapps.soundpool.SoundpoolPlugin;
import io.flutter.video_render_plugin.VideoRenderPlugin;
import io.flutter.plug.ynsoft.video_texture_plugin.VideoTexturePlugin;
import io.flutter.cppplugin.CppPlugin;
import com.example.flutterfileselector.FlutterfileselectorPlugin;
import xyz.luan.audioplayers.AudioplayersPlugin;
import com.lazyarts.vikram.cached_video_player.CachedVideoPlayerPlugin;
import io.flutter.plugins.camera.CameraPlugin;
import com.example.citypickers.CityPickersPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import com.mr.flutter.plugin.filepicker.FilePickerPlugin;
import com.crazecoder.flutterbugly.FlutterBuglyPlugin;
import com.example.flutterimagecompress.FlutterImageCompressPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import record.wilson.flutter.com.flutter_plugin_record.FlutterPluginRecordPlugin;
import com.flutter_webview_plugin.FlutterWebviewPlugin;
import com.example.imagegallerysaver.ImageGallerySaverPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin;
import com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin;
import com.crazecoder.openfile.OpenFilePlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import top.kikt.imagescanner.ImageScannerPlugin;
import com.rhyme.r_scan.RScanPlugin;
import flutter.plugins.screen.screen.ScreenPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
import com.example.video_compress.VideoCompressPlugin;
import io.flutter.plugins.videoplayer.VideoPlayerPlugin;
import xyz.justsoft.video_thumbnail.VideoThumbnailPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    DalipushPlugin.registerWith(registry.registrarFor("com.brzhang.dalipush.DalipushPlugin"));
    SoundpoolPlugin.registerWith(registry.registrarFor("pl.ukaszapps.soundpool.SoundpoolPlugin"));
    VideoRenderPlugin.registerWith(registry.registrarFor("io.flutter.video_render_plugin.VideoRenderPlugin"));
    VideoTexturePlugin.registerWith(registry.registrarFor("io.flutter.plug.ynsoft.video_texture_plugin.VideoTexturePlugin"));
    CppPlugin.registerWith(registry.registrarFor("io.flutter.cppplugin.CppPlugin"));
    FlutterfileselectorPlugin.registerWith(registry.registrarFor("com.example.flutterfileselector.FlutterfileselectorPlugin"));
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    CachedVideoPlayerPlugin.registerWith(registry.registrarFor("com.lazyarts.vikram.cached_video_player.CachedVideoPlayerPlugin"));
    CameraPlugin.registerWith(registry.registrarFor("io.flutter.plugins.camera.CameraPlugin"));
    CityPickersPlugin.registerWith(registry.registrarFor("com.example.citypickers.CityPickersPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    FilePickerPlugin.registerWith(registry.registrarFor("com.mr.flutter.plugin.filepicker.FilePickerPlugin"));
    FlutterBuglyPlugin.registerWith(registry.registrarFor("com.crazecoder.flutterbugly.FlutterBuglyPlugin"));
    FlutterImageCompressPlugin.registerWith(registry.registrarFor("com.example.flutterimagecompress.FlutterImageCompressPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    FlutterPluginRecordPlugin.registerWith(registry.registrarFor("record.wilson.flutter.com.flutter_plugin_record.FlutterPluginRecordPlugin"));
    FlutterWebviewPlugin.registerWith(registry.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"));
    ImageGallerySaverPlugin.registerWith(registry.registrarFor("com.example.imagegallerysaver.ImageGallerySaverPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    ImagePickerSaverPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin"));
    KeyboardVisibilityPlugin.registerWith(registry.registrarFor("com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin"));
    OpenFilePlugin.registerWith(registry.registrarFor("com.crazecoder.openfile.OpenFilePlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    ImageScannerPlugin.registerWith(registry.registrarFor("top.kikt.imagescanner.ImageScannerPlugin"));
    RScanPlugin.registerWith(registry.registrarFor("com.rhyme.r_scan.RScanPlugin"));
    ScreenPlugin.registerWith(registry.registrarFor("flutter.plugins.screen.screen.ScreenPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
    VideoCompressPlugin.registerWith(registry.registrarFor("com.example.video_compress.VideoCompressPlugin"));
    VideoPlayerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.videoplayer.VideoPlayerPlugin"));
    VideoThumbnailPlugin.registerWith(registry.registrarFor("xyz.justsoft.video_thumbnail.VideoThumbnailPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
