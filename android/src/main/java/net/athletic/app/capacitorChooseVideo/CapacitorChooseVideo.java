package net.athletic.app.capacitorChooseVideo;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.CursorLoader;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.PluginRequestCodes;

import java.io.File;
import java.io.InputStream;

// Dev note: If the com.getcapacitor files ever say things like "cannot resolve symbol",
// 1. Close Android Studtio
// 2. go to android/ folder and run rm -R gradle .gradle
// 3. reopen android studio.
// See Bryan Herbst note at bottom of this page here: https://groups.google.com/forum/#!topic/adt-dev/kOccJ1Pfnhk

@NativePlugin(
  requestCodes={CapacitorChooseVideo.REQUEST_VIDEO_PICK}
)
public class CapacitorChooseVideo extends Plugin {
  static final int REQUEST_VIDEO_PICK = 1000;

  @PluginMethod()
  public void echo(PluginCall call) {
    String value = call.getString("value");

    JSObject ret = new JSObject();
    ret.put("value", value);
    call.success(ret);
  }

  @PluginMethod()
  public void getVideo(PluginCall call) {
    saveCall(call);

    showVideos(call);
  }

  @PluginMethod()
  public void requestFilesystemAccess(PluginCall call) {
    saveCall(call);
    if (checkPhotosPermissions(call)) {
      JSObject ret = new JSObject();
      ret.put("hasPermission", true);

      call.resolve(ret);
    };
  }

  private void showVideos(final PluginCall call) {
    openVideos(call);
  }

  public void openVideos(final PluginCall call) {
    if (checkPhotosPermissions(call)) {
      Intent intent = new Intent(Intent.ACTION_PICK);
      intent.setType("video/*");
      startActivityForResult(call, intent, REQUEST_VIDEO_PICK);
    }
  }

  @Override
  protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
    super.handleOnActivityResult(requestCode, resultCode, data);

    PluginCall savedCall = getSavedCall();

    if (savedCall == null) {
      return;
    }

    processPickedVideo(savedCall, data);
  }

  public void processPickedVideo(PluginCall call, Intent data) {
    if (data == null) {
      call.error("No video picked");
      return;
    }

    Uri u = data.getData();

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

  private boolean checkPhotosPermissions(PluginCall call) {
    if(!hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
      pluginRequestPermission(Manifest.permission.READ_EXTERNAL_STORAGE, REQUEST_VIDEO_PICK);
      return false;
    }
    return true;
  }
}
