package com.bbtfr.merusuto;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.widget.Toast;

import org.apache.commons.io.IOUtils;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

public class Utils {

  static private class DecompressTask extends AsyncTask<Integer, Integer, Void> {

    private ProgressDialog mProgressDialog = null;
    private String mFilename;
    private Context mContext;
    private int mProgress = 0;

    public DecompressTask(Context context, String filename) {
      mContext = context;
      mFilename = filename;
    }

    @Override
    protected void onPreExecute() {
      try {
        int size = new ZipFile(mFilename).size();
        System.out.println("Unzip file: " + mFilename);

        mProgressDialog = new ProgressDialog(mContext);
        mProgressDialog.setButton("取消", new DialogInterface.OnClickListener() {

          @Override
          public void onClick(DialogInterface dialog, int which) {
            mProgressDialog.dismiss();
            mProgressDialog = null;
          }
        });
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        mProgressDialog.setCanceledOnTouchOutside(false);
        mProgressDialog.setTitle("数据解压");
        mProgressDialog.setMessage("正在加载数据，请稍后...");
        mProgressDialog.setMax(size);
        mProgressDialog.show();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    @Override
    protected Void doInBackground(Integer... param) {
      try {
        File location = new File(Environment.getExternalStorageDirectory(),
            ".merusuto/");
        
        File nomediaFile = new File(location, ".nomedia");
		if (!nomediaFile.exists())
			nomediaFile.createNewFile();

        FileInputStream fin = new FileInputStream(mFilename);
        ZipInputStream zin = new ZipInputStream(fin);
        ZipEntry entry = null;
        while ((entry = zin.getNextEntry()) != null) {
          String name = entry.getName();
          File file = new File(location, name);

          if (entry.isDirectory()) {
            if (!file.isDirectory()) {
              file.mkdirs();
            }
          } else {
			  
            publishProgress(mProgress++);

            int size;
            byte[] buffer = new byte[2048];

            FileOutputStream fout = new FileOutputStream(file);
            BufferedOutputStream bout = new BufferedOutputStream(fout, buffer.length);

            while ((size = zin.read(buffer, 0, buffer.length)) != -1) {
              bout.write(buffer, 0, size);
            }

            bout.flush();
            bout.close();
            fout.close();
            zin.closeEntry();
          }
        }
        zin.close();
        fin.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return null;
    }

    @Override
    protected void onProgressUpdate(Integer... values) {
      if (mProgressDialog != null)
        mProgressDialog.setProgress(mProgress);
    }

    @Override
    protected void onPostExecute(Void result) {
      if (mProgressDialog != null)
        mProgressDialog.dismiss();
    }
  }

  static public void createDecompressTask(Context context, String filename) {
    new DecompressTask(context, filename).execute();
  }

  static public void checkUpdate(final Context context, boolean force) {
    int currentVersion = 0;

    try {
      SharedPreferences settings = context.getSharedPreferences("SETTINGS", Context.MODE_PRIVATE);
      int lastVersion = settings.getInt("version", 0);

      PackageInfo pinfo = context.getPackageManager().getPackageInfo(
          context.getPackageName(), 0);
      currentVersion = pinfo.versionCode;

      if (lastVersion != currentVersion) {
        // the app is being launched for first time, do something.
        InputStream stream = context.getAssets().open("changelog");
        String changelog = IOUtils.toString(stream, "UTF8");

        new AlertDialog.Builder(context)
            .setTitle("应用更新日志")
            .setMessage(changelog)
            .setPositiveButton(android.R.string.yes, null)
            .show();

        // record the fact that the app has been started at least once
        settings.edit().putInt("version", currentVersion).apply();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    final String key = "merusuto.apk";
    final int localVersion = currentVersion;
    DataManager.checkVersion(context, key, force, new DataManager.DataHandler() {
      @Override
      public void onSuccess(byte[] data) {
        try {
          int remoteVersion = 0;
          try {
            remoteVersion = Integer.parseInt(new String(data).trim());
          } catch (Exception e) {}
          System.out.println("Local apk version: " + localVersion + ", remote apk version: " + remoteVersion + ".");
          DataManager.saveLocalData(context, key + ".version", new byte[0]);

          if (remoteVersion > localVersion) {
            Toast.makeText(context, "检测到应用更新，正在下载，请稍候...",
              Toast.LENGTH_SHORT).show();

            DataManager.loadRemoteData(context, key, new DataManager.DataHandler() {
              @Override
              public void onSuccess(byte[] data) {
                if (data != null) {
                  DataManager.saveLocalData(context, key, data);
                  final File file = DataManager.getLocalFile(key);

                  new AlertDialog.Builder(context)
                      .setTitle("应用更新")
                      .setMessage("检测到新版本梅露可图鉴，是否更新？")
                      .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {

                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                          Intent intent = new Intent(Intent.ACTION_VIEW);
                          intent.setDataAndType(Uri.fromFile(file),
                              "application/vnd.android.package-archive");
                          intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                          context.startActivity(intent);
                        }
                      })
                      .setNegativeButton(android.R.string.no, null)
                      .show();

                }
              }
            });
          }
        } catch(Exception e) {
          e.printStackTrace();
        }
      }
    });
  }
}
