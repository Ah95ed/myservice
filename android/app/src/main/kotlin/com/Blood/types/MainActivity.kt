package com.Blood.types

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.blood.share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                if (call.method == "shareText") {
                    val text = call.argument<String>("text")
                    val subject = call.argument<String>("subject")

                    if (text.isNullOrBlank()) {
                        result.error("NO_TEXT", "Missing share text", null)
                        return@setMethodCallHandler
                    }

                    shareText(text, subject)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun shareText(text: String, subject: String?) {
        val sendIntent = Intent(Intent.ACTION_SEND).apply {
            putExtra(Intent.EXTRA_TEXT, text)
            if (!subject.isNullOrBlank()) {
                putExtra(Intent.EXTRA_SUBJECT, subject)
            }
            type = "text/plain"
        }

        startActivity(sendIntent)
    }
}
