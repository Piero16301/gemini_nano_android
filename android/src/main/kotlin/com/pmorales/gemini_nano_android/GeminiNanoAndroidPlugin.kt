package com.pmorales.gemini_nano_android

// Using simple imports or fully qualified if needed to avoid conflicts
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.google.mlkit.genai.prompt.Generation
import com.google.mlkit.genai.prompt.GenerationConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executors
import kotlinx.coroutines.runBlocking

/** GeminiNanoAndroidPlugin */
class GeminiNanoAndroidPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val executor = Executors.newSingleThreadExecutor()

    override fun onAttachedToEngine(
            @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gemini_nano_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "generateText") {
            val prompt = call.argument<String>("prompt") ?: ""
            generateText(prompt, result)
        } else if (call.method == "isAvailable") {
            executor.execute {
                try {
                    val config = GenerationConfig.builder().build()
                    val model = Generation.getClient(config)
                    Handler(Looper.getMainLooper()).post { result.success(true) }
                } catch (e: Exception) {
                    Handler(Looper.getMainLooper()).post { result.success(false) }
                }
            }
        } else {
            result.notImplemented()
        }
    }

    private fun generateText(prompt: String, result: Result) {
        executor.execute {
            try {
                val config = GenerationConfig.builder().build()
                val model = Generation.getClient(config)

                runBlocking {
                    val response = model.generateContent(prompt)

                    var text = ""
                    val candidates = response.candidates
                    if (!candidates.isEmpty()) {
                        text = candidates[0].text ?: ""
                    }

                    val finalText = text
                    Handler(Looper.getMainLooper()).post { result.success(finalText) }
                }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post {
                    result.error("GENERATION_ERROR", e.message, null)
                }
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
