# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }
-keep class androidx.work.** { *; }
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.InputMerger
-keep class androidx.work.impl.WorkManagerInitializer { *; }

# Notification channels and other notification related classes
-keep class android.app.NotificationChannel { *; }
-keep class android.app.NotificationManager { *; }
-keep class android.app.Notification** { *; }
