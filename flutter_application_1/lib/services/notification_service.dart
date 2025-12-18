class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    // Placeholder for initializing platform notifications
    return;
  }

  Future<void> show(String title, String body) async {
    // Stub: in production, hook into flutter_local_notifications or Firebase
    return;
  }
}
