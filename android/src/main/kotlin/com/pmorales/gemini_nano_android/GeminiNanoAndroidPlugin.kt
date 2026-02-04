package com.pmorales.gemini_nano_android

// Using simple imports or fully qualified if needed to avoid conflicts
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.google.mlkit.genai.common.FeatureStatus
import com.google.mlkit.genai.prompt.*
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
        if (call.method == "getModelVersion") {
            getModelVersion(result)
        } else if (call.method == "generateText") {
            val prompt = call.argument<String>("prompt") ?: ""
            generateText(prompt, result)
        } else if (call.method == "isAvailable") {
            isAvailable(result)
        } else {
            result.notImplemented()
        }
    }

    private fun getModelVersion(result: Result) {
        executor.execute {
            try {
                // TODO: Implement logic to detect actual model version if API becomes available
                // Currently defaulting to "nano-v3" for supported devices
                val version = "nano-v3"
                Handler(Looper.getMainLooper()).post { result.success(version) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post {
                    result.error("VERSION_ERROR", e.message, null)
                }
            }
        }
    }

    private fun isAvailable(result: Result) {
        executor.execute {
            try {
                val config = GenerationConfig.builder().build()
                val model = Generation.getClient(config)
                runBlocking {
                    val status = model.checkStatus()
                    val isAvailable =
                            status == FeatureStatus.AVAILABLE ||
                                    status == FeatureStatus.DOWNLOADABLE
                    Handler(Looper.getMainLooper()).post { result.success(isAvailable) }
                }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post { result.success(false) }
            }
        }
    }

    private fun generateText(prompt: String, result: Result) {
        executor.execute {
            try {
                val config = GenerationConfig.builder().build()
                val model = Generation.getClient(config)

                runBlocking {
                    val response =
                            model.generateContent(
                                    generateContentRequest(TextPart(prompt)) { candidateCount = 1 },
                            )

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
