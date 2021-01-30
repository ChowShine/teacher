package com.example.platformchannel;


import android.app.job.JobParameters;
import android.app.job.JobService;
import android.os.Build;

import androidx.annotation.RequiresApi;


/**
 * created by z on 2018/11/19
 * 系统5.0以上使用的服务
 */
@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class videochatJobService extends JobService {

    @Override
    public boolean onStartJob(JobParameters jobParameters) {

        //此处进行自定义的任务
        return false;
    }

    @Override
    public boolean onStopJob(JobParameters jobParameters) {
        return false;
    }
}