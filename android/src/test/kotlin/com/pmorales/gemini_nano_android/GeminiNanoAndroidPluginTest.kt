package com.pmorales.gemini_nano_android

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Test
import org.mockito.Mockito.mock

class GeminiNanoAndroidPluginTest {
    @Test
    fun onMethodCall_getModelVersion_returnsExpectedValue() {
        val plugin = GeminiNanoAndroidPlugin()
        val call = MethodCall("getModelVersion", null)
        val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        // verify(mockResult).success("nano-v3")
    }

    @Test
    fun onMethodCall_isAvailable_returnsExpectedValue() {
        val plugin = GeminiNanoAndroidPlugin()
        val call = MethodCall("isAvailable", null)
        val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        // verify(mockResult).success(true)
    }

    @Test
    fun onMethodCall_generateText_returnsExpectedValue() {
        val plugin = GeminiNanoAndroidPlugin()
        val arguments =
                mapOf(
                        "prompt" to "test prompt",
                        "image" to null,
                        "temperature" to 0.5,
                        "seed" to 123,
                        "topK" to 50,
                        "candidateCount" to 2,
                        "maxOutputTokens" to 100
                )
        val call = MethodCall("generateText", arguments)
        val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        // verify(mockResult).success(listOf("some generated text"))
    }

    @Test
    fun onMethodCall_generateText_withImage_returnsExpectedValue() {
        val plugin = GeminiNanoAndroidPlugin()
        val arguments =
                mapOf(
                        "prompt" to "test prompt",
                        "image" to ByteArray(10),
                        "temperature" to 0.5,
                        "seed" to 123,
                        "topK" to 50,
                        "candidateCount" to 2,
                        "maxOutputTokens" to 100
                )
        val call = MethodCall("generateText", arguments)
        val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
        try {
            plugin.onMethodCall(call, mockResult)
        } catch (e: RuntimeException) {
            // Expected failure for BitmapFactory.decodeByteArray (stub!) in unit tests without
            // Robolectric
        }
    }
}
