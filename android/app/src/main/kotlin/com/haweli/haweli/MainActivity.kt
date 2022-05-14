package com.haweli.haweli

import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import com.facebook.FacebookSdk
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import android.provider.SyncStateContract.Helpers.update
import android.content.pm.PackageInfo

class MainActivity: FlutterActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    FacebookSdk.setApplicationId(getString(R.string.facebook_app_id))
    FacebookSdk.sdkInitialize(getApplicationContext())
//    try {
//      val info: PackageInfo = getPackageManager().getPackageInfo(
//              getPackageName(),
//              PackageManager.GET_SIGNATURES)
//      for (signature in info.signatures) {
//        val messageDigest: MessageDigest = MessageDigest.getInstance("SHA")
//        messageDigest.update(signature.toByteArray())
//        Log.d("KeyHash:", Base64.encodeToString(messageDigest.digest(), Base64.DEFAULT))
//      }
//    } catch (e: NameNotFoundException) {
//    } catch (e: NoSuchAlgorithmException) {
//    }
//    try {
//      val info = packageManager.getPackageInfo(
//              "com.haweli.haweli",
//              PackageManager.GET_SIGNATURES)
//      for (signature in info.signatures) {
//        val md: MessageDigest = MessageDigest.getInstance("SHA")
//        md.update(signature.toByteArray())
//        Log.d("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
//      }
//    } catch (e: PackageManager.NameNotFoundException) {
//    } catch (e: NoSuchAlgorithmException) {
//    }
    GeneratedPluginRegistrant.registerWith(this)
  }
}

