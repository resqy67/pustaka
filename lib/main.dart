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

// Fungsi untuk menangani pesan yang diterima ketika aplikasi berjalan di background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  _showNotification(message);
}

// Fungsi untuk menangani pesan yang diterima ketika aplikasi berjalan di foreground
@pragma('vm:entry-point')
Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
  print('Handling a foreground message ${message.messageId}');
  _showNotification(message);
}

// Inisialisasi plugin notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Menampilkan notifikasi
Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'high_importance_channel', // ID unik untuk saluran notifikasi
    'High Importance Notifications', // Nama saluran notifikasi
    channelDescription:
        'This channel is used for important notifications.', // Deskripsi saluran notifikasi
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    message.messageId.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

void main() async {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestNotificationPermission();

  // Inisialisasi plugin notifikasi lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inisialisasi Firebase Messaging
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // menangani pesan yang diterima ketika aplikasi berjalan di foreground
  FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);

  // menangani pesan yang diterima ketika aplikasi berjalan di background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // menangani pesan yang diterima ketika aplikasi dibuka dari notifikasi
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });

  // Mendapatkan token FCM
  final tokenFcm = await _storage.read(key: 'tokenFcm');
  print('tokenFCM sudah ada di storage: $tokenFcm');
  if (tokenFcm == null) {
    final newTokenFcm = await FirebaseMessaging.instance.getToken();
    print('new Token FCM: $newTokenFcm');
    await _storage.write(key: 'tokenFcm', value: newTokenFcm);
  } else {
    print('old Token FCM: $tokenFcm');
  }
  runApp(MyApp());
}

// Meminta izin notifikasi
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
  print('User granted permission: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pustaka Skarla',
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: _authService.isAuthenticated(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data == true) {
                return const HomePage();
              } else {
                return LoginScreen();
              }
            }
          },
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginScreen(),
          // '/detail-book': (context) => BookPage(bookUuid: uuid,)
        });
  }
}
