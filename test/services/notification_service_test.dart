import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  late MockFlutterLocalNotificationsPlugin mockNotificationsPlugin;
  late NotificationService notificationService;

  setUp(() {
    mockNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    // Use a custom NotificationService that allows injecting the mock plugin
    notificationService = NotificationService.test(mockNotificationsPlugin);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  });

  group('NotificationService', () {
    test('init should initialize notifications', () async {
      // Arrange
      when(mockNotificationsPlugin.initialize(any, onDidReceiveNotificationResponse: anyNamed('onDidReceiveNotificationResponse')))
          .thenAnswer((_) async => true);
      when(mockNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(MockAndroidFlutterLocalNotificationsPlugin());

      // Act
      await notificationService.init();

      // Assert
      verify(mockNotificationsPlugin.initialize(any, onDidReceiveNotificationResponse: anyNamed('onDidReceiveNotificationResponse'))).called(1);
      verify(mockNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission()).called(1);
    });

    test('schedulePrayerNotification should schedule a notification', () async {
      // Arrange
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
      final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      // Act
      await notificationService.schedulePrayerNotification(
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
        scheduledTime: scheduledTime,
      );

      // Assert
      verify(mockNotificationsPlugin.zonedSchedule(
        1,
        'Test Title',
        'Test Body',
        tzScheduledTime,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
      )).called(1);
    });

    test('schedulePrayerNotification should not schedule a notification for a past time', () async {
      // Arrange
      final scheduledTime = DateTime.now().subtract(const Duration(seconds: 10));

      // Act
      await notificationService.schedulePrayerNotification(
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
        scheduledTime: scheduledTime,
      );

      // Assert
      verifyNever(mockNotificationsPlugin.zonedSchedule(any, any, any, any, any, androidScheduleMode: anyNamed('androidScheduleMode')));
    });

    test('cancelAllNotifications should cancel all notifications', () async {
      // Act
      await notificationService.cancelAllNotifications();

      // Assert
      verify(mockNotificationsPlugin.cancelAll()).called(1);
    });
  });
}

// A mock implementation of AndroidFlutterLocalNotificationsPlugin is needed for the test
class MockAndroidFlutterLocalNotificationsPlugin extends Mock implements AndroidFlutterLocalNotificationsPlugin {
  @override
  Future<bool?> requestNotificationsPermission({
    bool sound = false,
    bool alert = false,
    bool badge = false,
    bool provisional = false,
    bool critical = false,
  }) async {
    return true;
  }
}
