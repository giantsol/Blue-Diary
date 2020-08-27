package lee.hansol.todo_app

import android.content.ContentResolver
import android.content.Context
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "crossingthestreams.io/resourceResolver").setMethodCallHandler { call, result ->
            if ("drawableToUri" == call.method) {
                val resourceId = resources.getIdentifier(call.arguments as String, "drawable", packageName)
                val uriString = resourceToUriString(applicationContext, resourceId)
                result.success(uriString)
            }
        }
    }

    private fun resourceToUriString(context: Context, resId: Int): String {
        val res = context.resources
        return "${ContentResolver.SCHEME_ANDROID_RESOURCE}://${res.getResourcePackageName(resId)}/${res.getResourceTypeName(resId)}/${res.getResourceEntryName(resId)}"
    }

    override fun onPause() {
        super.onPause()
        window?.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun onResume() {
        super.onResume()
        window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
