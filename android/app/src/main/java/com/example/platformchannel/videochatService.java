package com.example.platformchannel;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;


//import org.anyrtc.core.AnyRTMP;
import java.util.UUID;
import io.flutter.cppplugin.CppPlugin;



public class videochatService extends Service {
	static {
		System.loadLibrary("avmoudle");
		//System.loadLibrary("yt_av_wrapper");
		System.loadLibrary("videochat_cpp");
		System.loadLibrary("oboe");
	}

	private static final String TAG = "MyService";
	public static String CHANNEL_ONE_ID = "YOUR_CHANNEL_ID001";

	public videochatService() {
	}

	@Override
	public void onCreate() {
		super.onCreate();

		//AnyRTMP.Inst().Init(this.getApplicationContext());


		Log.d(TAG, "MyService---->onCreate被调用，启动前台service");
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		this.stopForeground(true);
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		setNotification(BuildConfig.APP_NAME);
		//return onStartCommand(intent,flags,startId);
		return START_STICKY;
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}


	/**
	 * 添加一个id,实现可以显示多条通知
	 * @return
	 */
	private static int getRandom (){
		UUID uuid = UUID.randomUUID();
		int id = uuid.hashCode();
		return id;
	}

	private void setNotification(String text) {
		NotificationManager notificationManager = (NotificationManager) getSystemService(Service.NOTIFICATION_SERVICE);
		Intent intent = new Intent(this, MainActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT);
		PendingIntent pi = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
		Notification notification = null;

		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {

			NotificationChannel mChannel = new NotificationChannel(CHANNEL_ONE_ID, "driver", NotificationManager.IMPORTANCE_HIGH);
			mChannel.setDescription("description");
			mChannel.setSound(Settings.System.DEFAULT_NOTIFICATION_URI, Notification.AUDIO_ATTRIBUTES_DEFAULT);
			// 设置通知出现时的闪灯（如果 android 设备支持的话）
			mChannel.enableLights(true);
			mChannel.setLightColor(Color.RED);
			// 设置通知出现时的震动（如果 android 设备支持的话）
			mChannel.enableVibration(true);
			mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});

			notificationManager.createNotificationChannel(mChannel);

			notification = new Notification.Builder(this, CHANNEL_ONE_ID)
					.setChannelId(CHANNEL_ONE_ID)
					.setSmallIcon(R.drawable.ic_launcher)
					.setContentTitle(BuildConfig.APP_NAME)
					.setContentText(text)
					.setContentIntent(pi)
					.setOngoing(true)
					.build();
		} else {
			// 提升应用权限
			notification = new Notification.Builder(this)
					.setSmallIcon(R.drawable.ic_launcher)
					.setContentTitle(BuildConfig.APP_NAME)
					.setContentText(text)
					.setContentIntent(pi)
					.setOngoing(true)
					.build();
		}
		notification.flags = Notification.FLAG_ONGOING_EVENT;
		notification.flags |= Notification.FLAG_NO_CLEAR;
		notification.flags |= Notification.FLAG_FOREGROUND_SERVICE;
		startForeground(getRandom(), notification);
	}
}


//
//public class MyService extends Service {
//
//	static {
//		System.loadLibrary("avmoudle");
//		System.loadLibrary("yt_av_wrapper");
//		System.loadLibrary("videochat_cpp");
//	}
//
//	FApp application;
//	NotificationManager mNotificationManager;
//	Notification mNotification;
//	Context mContext = this;
//	public static String CHANNEL_ONE_ID = "YOUR_CHANNEL_ID001";
//
//	@Override
//	public void onCreate() {
//		super.onCreate();
//		System.out.println("MyService ==> onCreate ");
//		application = (FApp) this.getApplication();
//
//		AnyRTMP.Inst().Init(this.getApplicationContext());
//
//		HermesEventBus.getDefault().register(this);
//
//		//showNotification();
//		//showNotify();
//		setNotification(application.getString(R.string.app_name));
//	}
//
//	@Override
//	public void onDestroy() {
//		super.onDestroy();
//		System.out.println("MyService onDestroy");
//		//将service从前台移除，并允许随时被系统回收
//		this.stopForeground(true);
//
//		HermesEventBus.getDefault().unregister(this);
//	}
//
//	@Override
//	public int onStartCommand(Intent intent, int flags, int startId) {
//		return START_STICKY;
//	}
//
//	private void showNotification()
//	{
//		FApp app = application;
//
//		Intent intent = new Intent(Intent.ACTION_MAIN);
//		intent.addCategory(Intent.CATEGORY_LAUNCHER);
//		intent.setClass(this, MainActivity.class);
//		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|
////				Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED
//						Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
//		);
//
//		// ############################ 【2013-11-24前的老方法】：点此进入的将永远是PortalActivi
//		// ############################ ty实例（而不是回到栈顶，从而在语音、视频等地方带来一系列问题）
//		// The PendingIntent to launch our activity if the user selects this
//		// notification
////		PendingIntent contentIntent = PendingIntent.getActivity(this, 0,
////				new Intent(this, PortalActivity.class), 0);
//
//		// ############################ 【2013-11-24后的新方法】：点此进入的将一直是栈顶的Activity
//		// ############################ （从而就避免了因Home键后在语音、视频等地方带来一系列问题）
//		// ############################ 【补充说明】：本方法的关键是要把intent设置的跟Manifast里
//		// ############################ 的Main intent一样（注意它不是singleTask也行？！）
//		PendingIntent contentIntent = PendingIntent.getActivity(this, 0, intent, 0);
//
//		// 创建一个Notification
////		Notification notification = new Notification();
//		// Set the icon, scrolling text and timestamp
////        Notification notification = new Notification(R.drawable.icon,
////                app.getString(R.string.app_notification_ticker), System.currentTimeMillis());
//		Notification notification = NotificationHelper.NotificationCreator.createNotification(
//				app
//				, contentIntent
//				, MessageFormat.format(app.getString(R.string.app_name)
//						, (""))
//				, app.getString(R.string.app_name)
//				// 设置显示在手机最上边的状态栏的图标
//				, R.drawable.app_icon
//		);
//
//		//##### 20180623: 以下代码在android 6.0上已经被废弃
////		// Set the info for the views that show in the notification panel.
////		notification.setLatestEventInfo(this
////			,MessageFormat.format(app.getString(R.string.app_notification_content_title), (ree != null?" ["+ree.getNickname()+"] ":""))
////			, app.getString(R.string.app_notification_content_text), contentIntent);
//
//
////		// Send the notification.
////		// We use a layout id because it is a unique number. We use it later to
////		// cancel.
////		mNM.notify(R.string.ident_genius_services_started, notification);
//		//让service在前台执行
//		this.startForeground(R.string.app_name, notification);
//	}
//
//	public void showNotify(){
//		Intent intent = new Intent(mContext, MainActivity.class);
//		PendingIntent pendingIntent = PendingIntent.getActivity(mContext, 0, intent,
//				PendingIntent.FLAG_UPDATE_CURRENT);//这里第二个参数可以用于后边根据不同的消息设置不同的点击事件
//
//		NotificationCompat.Builder mBuilder = null;
//		NotificationManager notificationManager = (NotificationManager) mContext.getSystemService(Service.NOTIFICATION_SERVICE);
//		if (Build.VERSION.SDK_INT >= 26) {
//			createNotificationChannel(notificationManager);
//			mBuilder = new NotificationCompat.Builder(mContext,"YOUR_CHANNEL_ID001");
//
//		} else {
//			mBuilder = new NotificationCompat.Builder(mContext);
//		}
//		mBuilder.setContentTitle("有未读消息")//设置通知栏标题  
//				.setContentText("有未读消息")//设置通知栏显示内容
////                            .setContent(contentViews)
////                            .setNumber(20)//设置通知集合的数量  
//				.setTicker("通知来啦")//通知首次出现在通知栏，带上升动画效果的  
//				.setWhen(System.currentTimeMillis())//通知产生的时间，会在通知信息里显示，一般是系统获取到的时间  
//				.setPriority(Notification.PRIORITY_DEFAULT)//设置该通知优先级  
//				.setAutoCancel(true)//设置这个标志当用户单击面板就可以让通知将自动取消    
//				.setOngoing(false)//true，设置他为一个正在进行的通知  
//				.setDefaults(Notification.DEFAULT_ALL)//向通知添加声音、闪灯和振动效果的最简单
//		;//设置通知小ICON  
//		try {
//			mBuilder .setSmallIcon(R.drawable.app_icon);
//		}catch (Exception e){
//			e.printStackTrace();
//		}
//
//		mBuilder.setContentIntent(pendingIntent);
//
//		//notificationManager.notify(getRandom(),mBuilder.build());
//
//		//让service在前台执行
//		this.startForeground(getRandom(), mBuilder.build());
//	}
//
//	/**
//	 * 解决android8.0不能弹出notification的问题
//	 * @param notificationManager
//	 */
//	@RequiresApi(api = Build.VERSION_CODES.O)
//	public void createNotificationChannel(NotificationManager notificationManager) {
//		NotificationChannel channel = new NotificationChannel("YOUR_CHANNEL_ID001","YOUR_CHANNEL_NAME",NotificationManager.IMPORTANCE_HIGH);
//		notificationManager.createNotificationChannel(channel);
//	}
//
//	/**
//	 * 添加一个id,实现可以显示多条通知
//	 * @return
//	 */
//	private int getRandom (){
//		UUID uuid = UUID.randomUUID();
//		int id = uuid.hashCode();
//		return id;
//	}
//
//	private void setNotification(String text) {
//		NotificationManager notificationManager = (NotificationManager) mContext.getSystemService(Service.NOTIFICATION_SERVICE);
//		Intent intent = new Intent(this, MainActivity.class);
//		intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT);
//		PendingIntent pi = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
//		Notification notification = null;
//
//		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//
//			NotificationChannel mChannel = new NotificationChannel(CHANNEL_ONE_ID, "driver", NotificationManager.IMPORTANCE_HIGH);
//			mChannel.setDescription("description");
//			mChannel.setSound(Settings.System.DEFAULT_NOTIFICATION_URI, Notification.AUDIO_ATTRIBUTES_DEFAULT);
//			// 设置通知出现时的闪灯（如果 android 设备支持的话）
//			mChannel.enableLights(true);
//			mChannel.setLightColor(Color.RED);
//			// 设置通知出现时的震动（如果 android 设备支持的话）
//			mChannel.enableVibration(true);
//			mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
//
//			notificationManager.createNotificationChannel(mChannel);
//
//			notification = new Notification.Builder(this, CHANNEL_ONE_ID)
//					.setChannelId(CHANNEL_ONE_ID)
//					.setSmallIcon(R.mipmap.ic_launcher)
//					.setContentTitle(getString(R.string.app_name))
//					.setContentText(text)
//					.setContentIntent(pi)
//					.build();
//		} else {
//			// 提升应用权限
//			notification = new Notification.Builder(this)
//					.setSmallIcon(R.mipmap.ic_launcher)
//					.setContentTitle(getString(R.string.app_name))
//					.setContentText(text)
//					.setContentIntent(pi)
//					.build();
//		}
//		notification.flags = Notification.FLAG_ONGOING_EVENT;
//		notification.flags |= Notification.FLAG_NO_CLEAR;
//		notification.flags |= Notification.FLAG_FOREGROUND_SERVICE;
//		startForeground(getRandom(), notification);
//	}
//
//	@Override
//	public IBinder onBind(Intent intent) {
//		return null;
//	}
//
//
//	@Subscribe(threadMode = ThreadMode.MAIN)
//	public void onUiToServiceEvent(UiToServiceEvent event) {
//		CppPlugin.onUiToServiceEvent(event);
//		//event = null;
//	}
//}