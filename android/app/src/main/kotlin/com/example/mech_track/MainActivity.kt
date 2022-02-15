package com.example.mech_track

import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import io.flutter.plugin.common.PluginRegistry
import java.io.File

private const val LOG_TAG = "FileDialog"

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"

//    @ExperimentalStdlibApi
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            if(call.method == "saveFile") {
                var sourcePath: String? = call.argument("source")
                var destinationPath: String? = call.argument("destination")
                var dbType: String? = call.argument("dbType")
                var saveResult: String = saveFile(sourcePath, destinationPath, dbType)
                result.success(saveResult)
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun saveFile(
        source: String?,
        destination: String?,
        dbType: String?,
    ): String {
        Log.d(LOG_TAG, "Saving file '${source}' to '${destination}'")
        File(source).let { sourceFile ->
            sourceFile.copyTo(File(destination + "/'${dbType}'_DB_Data.csv"))
        }
        Log.d(LOG_TAG, "Saved file to '${destination}'")
        return destination!!
    }
}
