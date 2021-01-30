package com.example.platformchannel;

import android.app.ActivityManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;

//import androidx.multidex.MultiDex;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.GcmRegister;
import com.alibaba.sdk.android.push.register.HuaWeiRegister;
import com.alibaba.sdk.android.push.register.MiPushRegister;
import com.alibaba.sdk.android.push.register.OppoRegister;

import java.util.List;
import java.util.concurrent.TimeUnit;

public class FApp extends io.flutter.app.FlutterApplication {

    private static final String TAG = "FApp";
    public  String _deviceId = "";
    private static Context context;
    public static String DEVICE_ID_BROADCAST = "DEVICE_ID_CHANGED";

    public static Context getAppContext() {
        return FApp.context;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        //获取进程Id
        int pid = android.os.Process.myPid();
        Log.e("m_tag", "MyApplication onCreate pid is " + pid); //根据进程id获取进程名称
        String pName = getProcessName(this,pid);
        if(BuildConfig.APP_ID.equals(pName)){
            FApp.context = getApplicationContext();
            startService();
        }

        initCloudChannel(this);
        // 注册方法会自动判断是否支持小米系统推送，如不支持会跳过注册。
        MiPushRegister.register(this, BuildConfig.xiao_id, BuildConfig.xiao_key);
        // 注册方法会自动判断是否支持华为系统推送，如不支持会跳过注册。
        HuaWeiRegister.register(this);
        //GCM/FCM辅助通道注册
        //GcmRegister.register(this, sendId, applicationId); //sendId/applicationId为步骤获得的参数
        // OPPO通道注册
        OppoRegister.register(this, BuildConfig.oppo_appkey, BuildConfig.oppo_appSecret); // appKey/appSecret在OPPO通道开发者平台获取
        // 魅族通道注册
        //MeizuRegister.register(this, BuildConfig.meizu_appId, BuildConfig.meizu_appkey); // appId/appkey在魅族开发者平台获取
        // VIVO通道注册
        //VivoRegister.register(this);


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            // 通知渠道的id
            String id = "1";
            // 用户可以看到的通知渠道的名字.
            CharSequence name = "notification channel";
            // 用户可以看到的通知渠道的描述
            String description = "notification description";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(id, name, importance);
            // 配置通知渠道的属性
            mChannel.setDescription(description);
            // 设置通知出现时的闪灯（如果 android 设备支持的话）
            mChannel.enableLights(true);
            mChannel.setLightColor(Color.RED);
            // 设置通知出现时的震动（如果 android 设备支持的话）
            mChannel.enableVibration(true);
            mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
            //最后在notificationmanager中创建该通知渠道
            mNotificationManager.createNotificationChannel(mChannel);
        }
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        stopService();
    }

    public void startService(){

        Intent serviceIntent = new Intent(FApp.this, videochatService.class);
        serviceIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(serviceIntent);
        }else {
            startService(serviceIntent);
        }


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

            JobInfo.Builder builder = new JobInfo.Builder(1, new ComponentName(context, videochatJobService.class));
            builder.setMinimumLatency(0)
                    .setBackoffCriteria(JobInfo.DEFAULT_INITIAL_BACKOFF_MILLIS, JobInfo.BACKOFF_POLICY_LINEAR);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                builder.setPeriodic(JobInfo.getMinPeriodMillis(), JobInfo.getMinFlexMillis());
            } else {
                builder.setPeriodic(TimeUnit.MINUTES.toMillis(5));
            }

            JobScheduler jobScheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
            if (jobScheduler != null) {
                jobScheduler.schedule(builder.build());
            }

        } else {
            //系统5.0以下的可继续使用Service
        }
    }

    public void stopService() {
        Intent serviceIntent = new Intent(this,videochatService.class);
        stopService(serviceIntent);
    }
    /**
     * 初始化云推送通道
     *
     * @param applicationContext
     */
    private void initCloudChannel(Context applicationContext) {
        PushServiceFactory.init(applicationContext);
        CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.register(applicationContext, new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                _deviceId = pushService.getDeviceId();
                Log.d(TAG, "init cloudchannel success, getDeviceId:" + _deviceId);

//                Intent intent = new Intent(DEVICE_ID_BROADCAST);
//                intent.putExtra("deviceid", _deviceId);
//                sendBroadcast(intent);
            }

            @Override
            public void onFailed(String errorCode, String errorMessage) {
                Log.d(TAG, "init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
            }
        });
    }

    public String getProcessName(Context cxt, int pid) {
        ActivityManager am = (ActivityManager)cxt.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> runningApps = am.getRunningAppProcesses();
        if (runningApps == null) {
            return null;
        }
        for (ActivityManager.RunningAppProcessInfo procInfo : runningApps) {
            if (procInfo.pid == pid) {
                return procInfo.processName;
            }
        }
        return null;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        //MultiDex.install(this);
    }

}
