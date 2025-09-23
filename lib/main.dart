import 'package:ai_psychologist/features/main/main_screen.dart';
import 'package:ai_psychologist/features/onboarding/screens/onboarding_screen.dart';
import 'package:ai_psychologist/app/app_state.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Uncomment if you use Firebase
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const MainScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Psychologist',
      theme: ThemeData(
        primaryColor: Colors.blue.shade300,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
