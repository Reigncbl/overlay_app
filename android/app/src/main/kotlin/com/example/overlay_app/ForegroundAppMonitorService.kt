package com.example.overlay_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.os.Handler
import android.os.Looper

class ForegroundAppMonitorService : Service() {

    private val CHANNEL_ID = "overlay_channel_id"
    private val TELEGRAM_PACKAGE = "org.telegram.messenger"
    private lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(1, createNotification())

        initFlutterEngine()
        startMonitoring()
    }

    private fun initFlutterEngine() {
        Log.d("ForegroundService", "Initializing Flutter Engine")
        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        FlutterEngineCache.getInstance().put("overlay_engine", flutterEngine)
    }

    private fun startMonitoring() {
        val handler = Handler(Looper.getMainLooper())
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        handler.post(object : Runnable {
            override fun run() {
                val endTime = System.currentTimeMillis()
                val startTime = endTime - 10000
                val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
                val event = UsageEvents.Event()

                while (usageEvents.hasNextEvent()) {
                    usageEvents.getNextEvent(event)
                    if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND &&
                        event.packageName == TELEGRAM_PACKAGE
                    ) {
                        Log.d("ForegroundService", "Telegram moved to foreground, showing overlay")
                        showOverlay()
                        break
                    }
                }
                handler.postDelayed(this, 3000)
            }
        })
    }

    private fun showOverlay() {
        Log.d("ForegroundService", "Invoking Flutter method channel: showOverlay")
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "overlay_channel"
        ).invokeMethod("showOverlay", null)
    }

    private fun createNotification(): Notification {
        val notificationBuilder = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Monitoring Telegram")
            .setContentText("Waiting for Telegram to open...")
            .setSmallIcon(R.mipmap.ic_launcher) // Make sure this icon exists!
            .setOngoing(true)

        return notificationBuilder.build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Overlay Monitor",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        Log.d("ForegroundService", "Destroying Flutter Engine")
        flutterEngine.destroy()
        super.onDestroy()
    }
}
