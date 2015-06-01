package com.bbtfr.merusuto;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;

import org.apache.commons.io.FileUtils;
import org.apache.http.Header;

import java.io.File;
import java.io.InputStream;

public class DataManager {

  final static long EXPIRATION = 3600000L;
//  final static long EXPIRATION = 0L;
  final static String BASEURL = "http://bbtfr.github.io/MerusutoChristina/data/";
  final static String BASEURL_RETRY = "http://merusuto.gitcafe.io/data/";
  private static Bitmap mDefaultThumbnail;

  interface DataHandler {
    void onSuccess(byte[] data);
  }

  interface JSONHandler {
    void onSuccess(Object json);
  }

  interface BitmapHandler {
    void onSuccess(Bitmap bitmap);
  }

  static Bitmap getDefaultThumbnail(Context context, BitmapFactory.Options options) {
    try {
      if (mDefaultThumbnail != null) return mDefaultThumbnail;

      InputStream stream = context.getAssets().open("thumbnail.png");
      mDefaultThumbnail = BitmapFactory.decodeStream(stream, null, options);
      stream.close();
      return mDefaultThumbnail;
    } catch (Exception e) {
      return null;
    }
  }

  static void loadBitmap(final Context context, String origin, final BitmapFactory.Options options, final BitmapHandler handler) {
    final String key = origin + ".png";

    byte[] data = loadLocalData(context, key);
    if (data != null) {
      Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length, options);
      handler.onSuccess(bitmap);
      return;
    }

    loadRemoteData(context, key, new DataHandler() {
      @Override
      public void onSuccess(byte[] data) {
        if (data != null) {
          Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length, options);
          handler.onSuccess(bitmap);
          saveLocalData(context, key, data);
        } else {
          handler.onSuccess(null);
        }
      }
    });
  }

  static Object loadLocalJSON(Context context, String origin) {
    final String key = origin + ".json";

    byte[] data = loadLocalData(context, key);
    return data != null ? JSON.parse(data) : null;
  }

  static void loadRemoteJSON(final Context context, String origin, final boolean force, final JSONHandler handler) {
    final String key = origin + ".json";

    checkVersion(context, key, force, new DataHandler() {
      @Override
      public void onSuccess(final byte[] version) {
        if (version != null) {
          Toast.makeText(context, "检测到数据更新，正在下载，请稍候...",
              Toast.LENGTH_SHORT).show();
          loadRemoteData(context, key, new DataHandler() {
            @Override
            public void onSuccess(byte[] data) {
              if (data != null) {
                Toast.makeText(context, "数据已更新，重新加载界面...",
                    Toast.LENGTH_SHORT).show();
                try {
                  handler.onSuccess(JSON.parse(data));
                  saveLocalData(context, key, data);
                  saveLocalData(context, key + ".version", version);
                } catch (Exception e) {}
              } else {
                Toast.makeText(context, "网络错误，请稍候重试...",
                    Toast.LENGTH_SHORT).show();
              }
            }
          });
        } else if (force) {
          Toast.makeText(context, "已经是最新版本!", Toast.LENGTH_SHORT).show();
        }
      }
    });
  }

  static File getLocalFile(String key) {
    return new File(Environment.getExternalStorageDirectory(), "merusuto/" + key);
  }

  static void ensureParentDirectoryExists(File file) {
    File parent = file.getParentFile();
    if (!parent.exists()) parent.mkdirs();
  }

  static void checkVersion(final Context context, String origin, final boolean force, final DataHandler handler) {
    String key = origin + ".version";
    final File local = getLocalFile(key);

    if (!force && local.exists()) {
      ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
      NetworkInfo wifiInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);

      if (!wifiInfo.isConnected()) {
        handler.onSuccess(null);
        return;
      }

      if (checkExpiration(context, local)) {
        handler.onSuccess(null);
        return;
      }
    }

    loadRemoteData(context, key, new DataHandler() {
      @Override
      public void onSuccess(byte[] version) {
        if (version != null) {
          String localVersion = "";
          byte[] data = loadLocalData(context, local);
          if (data != null) {
            localVersion = new String(data).trim();
          }
          String remoteVersion = new String(version).trim();
          System.out.println("Local version: " + localVersion + ", remove version: " + remoteVersion + ".");

          if (remoteVersion.equals(localVersion)) {
//            System.out.println("Same version.");
            saveLocalData(context, local, data);
            version = null;
          } else {
//            System.out.println("Different version.");
          }
        }
        handler.onSuccess(version);
      }
    });
  }

  static boolean checkExpiration(Context context, File file) {
    long expiration = System.currentTimeMillis() - file.lastModified();
//    System.out.println("Expiration: " + expiration);
    return expiration < EXPIRATION;
  }

  static void updateExpiration(Context context, File file) {
    try {
      FileUtils.touch(file);
    } catch (Exception e) { e.printStackTrace(); }
  }

  static byte[] loadLocalData(Context context, String key) {
    return loadLocalData(context, getLocalFile(key));
  }

  static byte[] loadLocalData(Context context, File local) {
    try {
//      System.out.println("Read file from Local System: " + local.toString());
      return local.exists() ? FileUtils.readFileToByteArray(local) : null;
    } catch (Exception e) {
      return null;
    }
  }

  static void saveLocalData(Context context, final String key, byte[] data) {
    saveLocalData(context, getLocalFile(key), data);
  }

  static void saveLocalData(Context context, final File local, byte[] data) {
    try {
//      System.out.println("Write file from Local System: " + local.toString());
      ensureParentDirectoryExists(local);
      FileUtils.writeByteArrayToFile(local, data);
    } catch (Exception e) {}
  }

  static void loadRemoteData(Context context, final String key, final DataHandler handler) {
    String url = BASEURL + key;
    System.out.println("Read file from Remote: " + url);

    final AsyncHttpClient client = new AsyncHttpClient();
    client.get(url, new AsyncHttpResponseHandler() {
      @Override
      public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
        if (statusCode == 200) {
          handler.onSuccess(responseBody);
        } else {
          retry();
        }
      }

      @Override
      public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
        error.printStackTrace();
        retry();
      }

      public void retry() {
        String url = BASEURL_RETRY + key;
        System.out.println("Retry read file from Remote: " + url);

        client.get(url, new AsyncHttpResponseHandler() {
          @Override
          public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
            handler.onSuccess(statusCode == 200 ? responseBody : null);
          }

          @Override
          public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
            error.printStackTrace();
            handler.onSuccess(null);
          }
        });
      }
    });
  }

  static JSONArray likes;
  static public void ensureLikes(Context context) {
    if (likes == null) {
      byte[] data = loadLocalData(context, "likes.json");
      if (data == null) {
        likes = new JSONArray();
      } else {
        likes = (JSONArray) JSON.parse(data);
      }
    }
  }

  static public boolean checkLike(Context context, String key) {
    ensureLikes(context);
    return likes.contains(key);
  }

  static public void storeLike(Context context, String key, boolean like) {
    ensureLikes(context);
    if (like) {
      likes.add(key);
    } else {
      likes.remove(key);
    }
    saveLocalData(context, "likes.json", likes.toJSONString().getBytes());
  }
}
