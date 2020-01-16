package lee.hansol.todo_app

import android.content.ContentResolver
import android.content.Context
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, "crossingthestreams.io/resourceResolver").setMethodCallHandler { call, result ->
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
}
