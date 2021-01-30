package com.example.platformchannel;

/**
 * Created by chenli on 2015/4/30.
 */
public interface UpdateCallback {

    public void updateLater();
    public void installNewApp(String path, String name);
    public void quitApp();

}
