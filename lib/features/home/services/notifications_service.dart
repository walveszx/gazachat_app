import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    // Initialize timezone properly
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Algiers')); // Set your timezone

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
          '@drawable/ic_notification', // Use your app icon
        ); // Use your app icon

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Add your navigation logic here
    // For example: Get.toNamed('/notification-details', arguments: response.payload);
  }

  // Request permissions
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    final bool? grantedAndroid = await androidImplementation
        ?.requestNotificationsPermission();

    return grantedAndroid ?? false;
  }

  // Show notification with custom sound
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? customSound, // Add custom sound parameter
  }) async {
    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'general_channel',
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: Importance.high,
        priority: Priority.high,
        // Custom sound for Android
        sound: customSound != null
            ? RawResourceAndroidNotificationSound(customSound)
            : null,
        // Alternative: Use system sound
        // sound: const RawResourceAndroidNotificationSound('notification_sound'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // Custom sound for iOS
        sound: customSound != null ? '$customSound.aiff' : null,
        // Alternative: Use default sound
        // sound: 'default',
      ),
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<bool> showUrgentNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      print('🚨 Showing urgent notification: $title');

      const NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'urgent_channel',
          'Urgent Notifications',
          channelDescription: 'Critical urgent notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',

          // Critical settings for lock screen
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,

          // Full screen intent (shows over lock screen)
          fullScreenIntent: true,

          // Wake up settings
          showWhen: true,

          // Sound and vibration
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('notification'),
          enableVibration: true,

          // LED and visual
          enableLights: true,
          ledOnMs: 1000,
          ledOffMs: 500,

          // Persistent until dismissed
          ongoing: false,
          autoCancel: false,

          // Additional urgent flags
          channelShowBadge: true,
          colorized: true,
        ),
      );

      await _notifications.show(id, title, body, details, payload: payload);
      print('✅ Urgent notification sent: $title');
      return true;
    } catch (e) {
      print('❌ Error showing urgent notification: $e');
      return false;
    }
  }

  // Show notification with different sound types
  Future<void> showNotificationWithSoundType({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationSoundType soundType = NotificationSoundType.defaultSound,
  }) async {
    late NotificationDetails details;

    switch (soundType) {
      case NotificationSoundType.defaultSound:
        details = const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            // Uses system default sound
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            // Uses system default sound
          ),
        );
        break;

      case NotificationSoundType.customSound:
        details = const NotificationDetails(
          android: AndroidNotificationDetails(
            'custom_channel',
            'Custom Sound Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            // Custom sound file (must be in android/app/src/main/res/raw/)
            sound: RawResourceAndroidNotificationSound('custom_notification'),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            // Custom sound file (must be in ios/Runner/ bundle)
            sound: 'custom_notification.aiff',
          ),
        );
        break;

      case NotificationSoundType.noSound:
        details = const NotificationDetails(
          android: AndroidNotificationDetails(
            'silent_channel',
            'Silent Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            playSound: false, // Disable sound
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false, // Disable sound
          ),
        );
        break;

      case NotificationSoundType.urgentSound:
        details = const NotificationDetails(
          android: AndroidNotificationDetails(
            'urgent_channel',
            'Urgent Notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@drawable/ic_notification',
            sound: RawResourceAndroidNotificationSound('urgent_alarm'),
            // Additional urgent settings
            category: AndroidNotificationCategory.alarm,
            fullScreenIntent: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'urgent_alarm.aiff',
            // iOS critical alert (requires special entitlement)
          ),
        );
        break;
    }

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Schedule notification with custom sound
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? customSound,
  }) async {
    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Scheduled app notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        sound: customSound != null
            ? RawResourceAndroidNotificationSound(customSound)
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: customSound != null ? '$customSound.aiff' : null,
      ),
    );

    await _notifications.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
    );
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Schedule notification with minutes from now and custom sound
  Future<void> scheduleNotificationAfterMinutes({
    required int id,
    required String title,
    required String body,
    required int minutes,
    String? payload,
    String? customSound,
  }) async {
    try {
      // Ensure timezone is initialized
      if (tz.local.name.isEmpty) {
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Africa/Algiers'));
      }

      final NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          channelDescription: 'Scheduled app notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound: customSound != null
              ? RawResourceAndroidNotificationSound(customSound)
              : null,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: customSound != null ? '$customSound.aiff' : null,
        ),
      );

      final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
        tz.local,
      ).add(Duration(minutes: minutes));

      await _notifications.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
      );

      print('Notification scheduled for: $scheduledDate');
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  // Daily notification with custom sound
  Future<void> scheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    String? customSound,
  }) async {
    try {
      // Ensure timezone is initialized
      if (tz.local.name.isEmpty) {
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Africa/Algiers'));
      }

      final NotificationDetails details = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'Daily recurring notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound: customSound != null
              ? RawResourceAndroidNotificationSound(customSound)
              : null,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: customSound != null ? '$customSound.aiff' : null,
        ),
      );

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the scheduled time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Daily notification scheduled for: $scheduledDate');
    } catch (e) {
      print('Error scheduling daily notification: $e');
      rethrow;
    }
  }
}

// Enum for different sound types
enum NotificationSoundType { defaultSound, customSound, noSound, urgentSound }
