package com.bbtfr.merusuto;

import android.app.Application;

import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.AVAnalytics;

public class MainApplication extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    AVOSCloud.initialize(this,
        "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
        "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg");
    AVAnalytics.enableCrashReport(this, true);
  }

}
