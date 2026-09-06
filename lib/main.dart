import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pustaka/views/home.dart';
import 'package:pustaka/views/widgets/login/index.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ============================================================================
// KONFIGURASI NOTIFIKASI
// ============================================================================

// Inisialisasi plugin notifikasi lokal (Global)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Handler untuk pesan saat aplikasi di background / tertutup (Terminated)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Pastikan Firebase diinisialisasi juga di background isolate
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  print('Menerima pesan background: ${message.messageId}');
  await _showNotification(message);
}

// Handler untuk pesan saat aplikasi aktif di layar (Foreground)
void _firebaseMessagingForegroundHandler(RemoteMessage message) {
  print('Menerima pesan foreground: ${message.messageId}');
  _showNotification(message);
}

// Menampilkan notifikasi banner/pop-up di layar
Future<void> _showNotification(RemoteMessage message) async {
  final notification = message.notification;

  // Hanya tampilkan jika payload berupa notifikasi (bukan silent data message)
  if (notification != null) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'pustaka_high_importance_channel', // ID unik
      'High Importance Notifications', // Nama channel
      channelDescription:
          'Saluran khusus untuk notifikasi penting Pustaka Skarla.',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF388E3C), // Warna hijau khas Pustaka
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: notificationDetails,
    );
  }
}

// Meminta izin notifikasi dari pengguna (terutama Android 13+ & iOS)
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Status Izin Notifikasi: ${settings.authorizationStatus}');
}

// ============================================================================
// ENTRY POINT APLIKASI
// ============================================================================

void main() async {
  // Wajib dipanggil sebelum inisialisasi native/Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase (Dengan proteksi anti Duplicate App)
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase memang sudah jalan dari sananya: $e');
  }

  // 2. Minta izin notifikasi
  await requestNotificationPermission();

  // 3. Setup Local Notifications (Un-commented dan disempurnakan)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings, // <-- Ubah kata awalnya jadi 'settings'
  );

  // 4. Konfigurasi Firebase Messaging
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Listener saat Foreground
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  // Listener saat Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Listener saat notifikasi di-klik (membuka aplikasi)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notifikasi di-klik! Message ID: ${message.messageId}');
  });

  // 5. Setup Token FCM ke Secure Storage
  const storage = FlutterSecureStorage();
  final tokenFcm = await storage.read(key: 'tokenFcm');

  if (tokenFcm == null) {
    final newTokenFcm = await FirebaseMessaging.instance.getToken();
    if (newTokenFcm != null) {
      print('New Token FCM tersimpan: $newTokenFcm');
      await storage.write(key: 'tokenFcm', value: newTokenFcm);
    }
  } else {
    print('Old Token FCM ditemukan: $tokenFcm');
  }

  runApp(MyApp());
}

// ============================================================================
// ROOT APP WIDGET
// ============================================================================

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pustaka Skarla',
      theme: ThemeData(
        // Menyelaraskan dengan background abu-abu terang modern dari screen lainnya
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[700]!),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      // Cek status autentikasi di awal mula
      home: FutureBuilder<bool>(
        future: _authService.isAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          } else {
            // Langsung arahkan berdasarkan hasil auth
            if (snapshot.hasData && snapshot.data == true) {
              return HomePage();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
