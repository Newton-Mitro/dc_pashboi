package com.dhakacredit.cccul

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "security/device"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "isUsbDebuggingEnabled" -> {
                    try {
                        val enabled = Settings.Global.getInt(
                            contentResolver,
                            Settings.Global.ADB_ENABLED,
                            0
                        ) == 1

                        result.success(enabled)

                    } catch (e: Exception) {
                        result.success(false)
                    }
                }

                "openDeveloperOptions" -> {
                    try {
                        val intent = Intent(
                            Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS
                        )

                        startActivity(intent)

                        result.success(true)

                    } catch (e: Exception) {

                        try {
                            startActivity(
                                Intent(Settings.ACTION_SETTINGS)
                            )

                            result.success(true)

                        } catch (ex: Exception) {
                            result.error(
                                "SETTINGS_ERROR",
                                ex.message,
                                null
                            )
                        }
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}