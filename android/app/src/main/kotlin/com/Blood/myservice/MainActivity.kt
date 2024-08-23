package com.Blood.myservice

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // private val CHANNEL = "com.blood.share"

    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)

    //     MethodChannel(flutterEngine?.dartExecutor?
    //     .binaryMessenger?, CHANNEL).setMethodCallHandler { call, result ->
    //         if (call.method == "shareText") {
    //             val text = call.argument<String>("https://play.google.com/store/apps/details?id=com.Blood.types")
    //             shareText(text)
    //             result.success(null)
    //         } else {
    //             result.notImplemented()
    //         }
    //     }
    // }

    // private fun shareText(text: String?) {
    //     if (text != null) {
    //         val sendIntent: Intent = Intent().apply {
    //             action = Intent.ACTION_SEND
    //             putExtra(Intent.EXTRA_TEXT, text)
    //             type = "text/plain"
    //         }
    //         val shareIntent = Intent.createChooser(sendIntent, null)
    //         startActivity(shareIntent)
    //     }
    // }
}
