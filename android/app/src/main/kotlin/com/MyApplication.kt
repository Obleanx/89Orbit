package com.example.fiander

import android.app.Application
import androidx.work.Configuration
import androidx.work.WorkManager

class MyApplication : Application(), Configuration.Provider {
    override fun onCreate() {
        super.onCreate()
        // Initialize WorkManager
        WorkManager.initialize(this, workManagerConfiguration)
    }

    override fun getWorkManagerConfiguration(): Configuration {
        return Configuration.Builder()
            .setMinimumLoggingLevel(android.util.Log.INFO)
            .build()
    }
}