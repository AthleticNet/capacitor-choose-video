package net.athletic.app.capacitorChooseVideo;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;

import androidx.activity.result.ActivityResult;

import com.getcapacitor.JSObject;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;
import com.getcapacitor.annotation.ActivityCallback;

// Dev note: If the com.getcapacitor files ever say things like "cannot resolve symbol",
// 1. Close Android Studtio
// 2. go to android/ folder and run rm -R gradle .gradle
// 3. reopen android studio.
// See Bryan Herbst note at bottom of this page here: https://groups.google.com/forum/#!topic/adt-dev/kOccJ1Pfnhk

@CapacitorPlugin(
        name = "CapacitorChooseVideo",
        permissions = {
                @Permission(
                        alias = "camera",
                        strings = {Manifest.permission.CAMERA}
                ),
                @Permission(
                        alias = "read_storage",
                        strings = {Manifest.permission.READ_EXTERNAL_STORAGE}
                )
        }
)
public class CapacitorChooseVideo extends Plugin {
  static final int REQUEST_VIDEO_PICK = 1000;

  @PluginMethod()
  public void echo(PluginCall call) {
    String value = call.getString("value");

    JSObject ret = new JSObject();
    ret.put("value", value);
    call.resolve(ret);
  }

  @PluginMethod()
  public void getVideo(PluginCall call) {
    if (getPermissionState("camera") != PermissionState.GRANTED) {
      requestPermissionForAlias("camera", call, "openVideosPermsCallback");
    } else {
      openVideos(call);
    }
  }

  @PluginMethod()
  public void requestFilesystemAccess(PluginCall call) {
    if (!(getPermissionState("camera") == PermissionState.GRANTED || getPermissionState("storage") == PermissionState.GRANTED)) {
      requestPermissionForAliases(new String[]{"camera", "storage"}, call, "requestFilesystemAccessPermsCallback");
    } else {
      returnFilesystemAccess(call);
    }
  }

  public void openVideos(final PluginCall call) {
    Intent intent = new Intent(Intent.ACTION_PICK);
    intent.setType("video/*");
    startActivityForResult(call, intent, "processPickedVideo");
  }

  public void returnFilesystemAccess(final PluginCall call) {
    JSObject ret = new JSObject();
    ret.put("hasPermission", true);

    Log.i("permissionReturn", ret.toString());

    call.resolve(ret);
  }

  @ActivityCallback
  public void processPickedVideo(PluginCall call, ActivityResult data) {
    if (data == null) {
      call.reject("No video picked");
      return;
    }

    Uri u = data.getData().getData();

    JSObject ret = new JSObject();
    ret.put("path", "file://" + this.getRealPathFromURI(getContext(), u));

    call.resolve(ret);
  }

  private String getRealPathFromURI(Context context, Uri contentUri) {
    Cursor cursor = null;
    try {
      String[] proj = { MediaStore.Images.Media.DATA };
      cursor = context.getContentResolver().query(contentUri,  proj, null, null, null);
      int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
      cursor.moveToFirst();
      return cursor.getString(column_index);
    } catch (Exception e) {
      Log.e("problem", "getRealPathFromURI Exception : " + e.toString());
      return "";
    } finally {
      if (cursor != null) {
        cursor.close();
      }
    }
  }

  @PermissionCallback
  private void openVideosPermsCallback(PluginCall call) {
    if (getPermissionState("camera") == PermissionState.GRANTED) {
      openVideos(call);
    } else {
      call.reject("Permission is required to take a video");
    }
  }

  @PermissionCallback
  private void requestFilesystemAccessPermsCallback(PluginCall call) {
    if (getPermissionState("storage") == PermissionState.GRANTED && getPermissionState("camera") == PermissionState.GRANTED) {
      returnFilesystemAccess(call);
    } else {
      call.reject("Filesystem and camera permissions are needed");
    }
  }
}
