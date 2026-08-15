import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DishaVerseApp());
}

class AppConfig {
  static const String appName = 'DishaVerse';

  // Android emulator -> use 10.0.2.2 instead of localhost
  // Real phone -> replace with your laptop IP like http://192.168.x.x:8000/api
  static const String baseUrl = 'https://dishaverse-backend.onrender.com/api';

  static const String friendCode = '22032004';
  static const String adminCode = 'disha22admin';
}

class AppColors {
  static const Color bg = Color(0xFFFFF7FB);
  static const Color softPink = Color(0xFFF6BDD1);
  static const Color buttonPink = Color(0xFFEFA6C8);
  static const Color heading = Color(0xFF5C3D4D);
  static const Color text = Color(0xFF7A5C68);
  static const Color pale = Color(0xFFFFF0F5);
  static const Color pale2 = Color(0xFFFDF6FF);
  static const Color pale3 = Color(0xFFFFF9F2);
}

class DishaVerseApp extends StatelessWidget {
  const DishaVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.buttonPink,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.pale,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class ApiService {
  static Future<void> warmUpServer() async {
    try {
      await http
          .get(
        Uri.parse('${AppConfig.baseUrl}/slam-responses/'),
        headers: {'Content-Type': 'application/json'},
      )
          .timeout(const Duration(seconds: 60));
    } catch (_) {}
  }
  static Future<Map<String, dynamic>> submitSlam({
    required String name,
    required Map<String, String> data,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/slam/');
    final response = await http
        .post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        ...data,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit slam book');
    }
  }

  static Future<Map<String, dynamic>> submitQuiz({
    required String name,
    required Map<String, String> data,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/quiz/');
    final response = await http
        .post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        ...data,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit quiz');
    }
  }

  static Future<Map<String, dynamic>> submitNote({
    required String name,
    required String message,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/note/');
    final response = await http
        .post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'message': message,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit note');
    }
  }

  static Future<List<dynamic>> getQuizResponses() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/quiz-responses/');
    final response = await http
        .get(
      uri,
      headers: {'Content-Type': 'application/json'},
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quiz responses');
    }
  }

  static Future<List<dynamic>> getNotes() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/notes/');
    final response = await http
        .get(
      uri,
      headers: {'Content-Type': 'application/json'},
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<List<dynamic>> getSlamResponses() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/slam-responses/');
    final response = await http
        .get(
      uri,
      headers: {'Content-Type': 'application/json'},
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load slam responses');
    }
  }

  static Future<Map<String, dynamic>> submitFavorites({
    required String name,
    required Map<String, String> data,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/favorites/');
    final response = await http
        .post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        ...data,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit favorites');
    }
  }

  static Future<List<dynamic>> getFavoritesResponses() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/favorites-responses/');
    final response = await http
        .get(
      uri,
      headers: {'Content-Type': 'application/json'},
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites responses');
    }
  }

}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softPink,
          foregroundColor: AppColors.heading,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 1.5,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration appInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.text),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.pale, AppColors.pale2, AppColors.pale3],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFF1A8C3), width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 85,
                    backgroundImage: AssetImage('assets/images/disha.jpeg'),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Hello everyone 💗',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome to my little world.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.6,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EntryScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Start',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  Future<void> handleContinue() async {
    final enteredName = nameController.text.trim();
    final enteredCode = codeController.text.trim();

    if (enteredName.isEmpty || enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both name and code')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', enteredName);

    if (enteredCode == AppConfig.friendCode) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: enteredName),
        ),
      );
    } else if (enteredCode == AppConfig.adminCode) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(userName: enteredName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Details'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const SectionHeading(
              title: 'Before we begin ✨',
              subtitle: 'Enter your name and the code to continue',
            ),
            const SizedBox(height: 28),
            TextField(
              controller: nameController,
              decoration: appInputDecoration('Enter your name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              decoration: appInputDecoration('Enter code'),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Code: Disha's dob datemonthyear",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AppButton(
              text: 'Continue',
              onTap: handleContinue,
              icon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    // Background warm-up (no waiting)
    ApiService.warmUpServer();
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.userName;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit DishaVerse?'),
            content: const Text('Do you want to exit DishaVerse?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hi, $userName 💗'),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.bg, AppColors.pale],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const SectionHeading(
                    title: 'Choose a section',
                    subtitle: 'A little bit of me, a little bit of us',
                  ),
                  const SizedBox(height: 30),

                  AppButton(
                    text: 'About Disha',
                    icon: Icons.favorite_border_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  AppButton(
                    text: 'Fill Slam Book',
                    icon: Icons.menu_book_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SlamBookScreen(userName: userName),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  AppButton(
                    text: 'Match with Disha',
                    icon: Icons.quiz_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(userName: userName),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  AppButton(
                    text: 'Favorites',
                    icon: Icons.star_border_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoritesScreen(userName: userName),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  AppButton(
                    text: 'Note for Disha',
                    icon: Icons.edit_note_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteScreen(userName: userName),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget infoCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.heading,
          height: 1.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Disha'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            const SectionHeading(
              title: 'A little about me 💕',
              subtitle: 'A crazy girl with delulu mind',
            ),
            const SizedBox(height: 22),
            infoCard('I love colors, joy, Spring Season, craziness.'),
            infoCard('Music and imagination are a huge part of my world.'),
            infoCard('Once we vibe, there is no going back.'),
            infoCard("I only listen to the people I love but only when I feel I am not able to decide."),

          ],
        ),
      ),
    );
  }
}

class SlamBookScreen extends StatefulWidget {
  final String userName;

  const SlamBookScreen({super.key, required this.userName});

  @override
  State<SlamBookScreen> createState() => _SlamBookScreenState();
}

class _SlamBookScreenState extends State<SlamBookScreen> {
  final nicknameController = TextEditingController();
  final howMetController = TextEditingController();
  final firstImpressionController = TextEditingController();
  final favoriteThingController = TextEditingController();
  final describeController = TextEditingController();
  final perceptionController = TextEditingController();
  final vibeController = TextEditingController();
  final cuteHabitController = TextEditingController();
  final changeHabitController = TextEditingController();
  final gratefulController = TextEditingController();
  final memoryController = TextEditingController();
  final commonThingController = TextEditingController();
  final songController = TextEditingController();
  final characterController = TextEditingController();
  final thingsToTryController = TextEditingController();
  final hobbiesController = TextEditingController();
  final showsController = TextEditingController();
  final suggestionsController = TextEditingController();
  final unsaidThingController = TextEditingController();

  bool isLoading = false;

  Widget buildField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: appInputDecoration(label),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Future<void> handleSubmit() async {
    if (nicknameController.text.trim().isEmpty ||
        howMetController.text.trim().isEmpty ||
        firstImpressionController.text.trim().isEmpty ||
        favoriteThingController.text.trim().isEmpty ||
        memoryController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all important fields 💛'),
        ),
      );
      return;
    }
    setState(() => isLoading = true);

    try {
      await ApiService.submitSlam(
        name: widget.userName,
        data: {
          'nickname': nicknameController.text.trim(),
          'how_met': howMetController.text.trim(),
          'first_impression': firstImpressionController.text.trim(),
          'favorite_thing': favoriteThingController.text.trim(),
          'describe_in_3_words': describeController.text.trim(),
          'perception_change': perceptionController.text.trim(),
          'vibe': vibeController.text.trim(),
          'cute_habit': cuteHabitController.text.trim(),
          'change_habit': changeHabitController.text.trim(),
          'grateful_for': gratefulController.text.trim(),
          'memory': memoryController.text.trim(),
          'common_thing': commonThingController.text.trim(),
          'dedicated_song': songController.text.trim(),
          'character_type': characterController.text.trim(),
          'things_to_try': thingsToTryController.text.trim(),
          'hobbies': hobbiesController.text.trim(),
          'favorite_shows': showsController.text.trim(),
          'suggestions': suggestionsController.text.trim(),
          'unsaid_thing': unsaidThingController.text.trim(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slam Book submitted successfully 💛')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: widget.userName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();
    howMetController.dispose();
    firstImpressionController.dispose();
    favoriteThingController.dispose();
    describeController.dispose();
    perceptionController.dispose();
    vibeController.dispose();
    cuteHabitController.dispose();
    changeHabitController.dispose();
    gratefulController.dispose();
    memoryController.dispose();
    commonThingController.dispose();
    songController.dispose();
    characterController.dispose();
    thingsToTryController.dispose();
    hobbiesController.dispose();
    showsController.dispose();
    suggestionsController.dispose();
    unsaidThingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Slam Book'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${widget.userName} 💛',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell me your heart out through this little slam book ✨',
                  style: TextStyle(fontSize: 14, color: AppColors.text),
                ),
                const SizedBox(height: 24),
                buildField('Your nickname', nicknameController),
                buildField('How you met Disha', howMetController, maxLines: 3),
                buildField(
                  'First impression of Disha',
                  firstImpressionController,
                  maxLines: 3,
                ),
                buildField(
                  'Your favorite thing about Disha',
                  favoriteThingController,
                  maxLines: 3,
                ),
                buildField('Describe Disha in 3 words', describeController),
                buildField(
                  'What changed in your perception over time',
                  perceptionController,
                  maxLines: 3,
                ),
                buildField('What vibe does Disha give', vibeController),
                buildField(
                  'One habit of Disha you find cute',
                  cuteHabitController,
                  maxLines: 3,
                ),
                buildField(
                  'One habit of Disha you would change',
                  changeHabitController,
                  maxLines: 3,
                ),
                buildField(
                  'One thing you are grateful to Disha for',
                  gratefulController,
                  maxLines: 3,
                ),
                buildField(
                  'A memory with Disha you’ll never forget',
                  memoryController,
                  maxLines: 3,
                ),
                buildField(
                  'One thing common between you and Disha',
                  commonThingController,
                  maxLines: 3,
                ),
                buildField('A song you would dedicate to Disha', songController),
                buildField(
                  'If Disha was a character, what would she be',
                  characterController,
                  maxLines: 3,
                ),
                buildField(
                  '3 things you want to try with Disha',
                  thingsToTryController,
                  maxLines: 3,
                ),
                buildField('Your hobbies', hobbiesController, maxLines: 3),
                buildField(
                  'Your favorite shows / series / movies',
                  showsController,
                  maxLines: 3,
                ),
                buildField(
                  'Suggestions you would give Disha',
                  suggestionsController,
                  maxLines: 3,
                ),
                buildField(
                  'One thing you’ve never told Disha',
                  unsaidThingController,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: isLoading ? 'Submitting...' : 'Submit Slam Book',
                  icon: Icons.send_rounded,
                  onTap: isLoading ? null : handleSubmit,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String key;
  final String question;
  final List<String> options;

  const QuizQuestion({
    required this.key,
    required this.question,
    required this.options,
  });
}

class QuizScreen extends StatefulWidget {
  final String userName;

  const QuizScreen({super.key, required this.userName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isLoading = false;

  final List<QuizQuestion> questions = const [
    QuizQuestion(
      key: 'q1_music',
      question: 'Disha’s music vibe is:',
      options: ['Romantic', 'Chill', 'Sad', 'Party'],
    ),
    QuizQuestion(
      key: 'q2_reaction',
      question: 'When a song matches Disha’s mood, she is most likely to:',
      options: [
        'Dance',
        'Listen quietly and imagine scenarios',
        'Ignore it',
        'Sing loudly',
      ],
    ),
    QuizQuestion(
      key: 'q3_food',
      question: 'What type of food does Disha like?',
      options: ['Spicy', 'Sweet', 'Fast food', 'Healthy'],
    ),
    QuizQuestion(
      key: 'q4_hangout',
      question: 'Ideal hangout for Disha:',
      options: ['Cafe', 'Trip', 'Home', 'Shopping'],
    ),
    QuizQuestion(
      key: 'q5_quality',
      question: 'What quality matters most to Disha?',
      options: ['Loyalty', 'Honesty', 'Humor', 'Intelligence'],
    ),
    QuizQuestion(
      key: 'q6_values',
      question: 'What matters more to Disha?',
      options: ['Effort', 'Words', 'Time', 'Actions'],
    ),
    QuizQuestion(
      key: 'q7_nature',
      question: 'Disha is more:',
      options: ['Emotional', 'Practical', 'Balanced'],
    ),
    QuizQuestion(
      key: 'q8_personality',
      question: 'Disha is:',
      options: ['Introvert', 'Extrovert', 'Ambivert'],
    ),
    QuizQuestion(
      key: 'q9_time',
      question: 'Disha prefers:',
      options: ['Night', 'Morning'],
    ),
    QuizQuestion(
      key: 'q10_career',
      question: 'If not engineering, Disha would choose:',
      options: ['Business', 'Creative field', 'Teaching', 'Something else'],
    ),
    QuizQuestion(
      key: 'q11_overthinking',
      question: 'Disha overthinks:',
      options: ['A lot', 'Sometimes', 'Rarely', 'Never'],
    ),
  ];

  final Map<String, String> selectedAnswers = {};

  Future<void> handleSubmit() async {
    if (selectedAnswers.length != questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService.submitQuiz(
        name: widget.userName,
        data: selectedAnswers,
      );

      final match = response['match_percentage'] ?? 0;

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            matchPercentage: match,
            userName: widget.userName,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz submission failed: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget questionCard(QuizQuestion q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 12),
          ...q.options.map(
                (option) => RadioListTile<String>(
              value: option,
              groupValue: selectedAnswers[q.key],
              activeColor: AppColors.buttonPink,
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              onChanged: (value) {
                setState(() {
                  selectedAnswers[q.key] = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match with Disha'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SectionHeading(
                title: 'Let’s see how much we match 💫',
                subtitle: 'Choose the options that feel right',
              ),
              const SizedBox(height: 22),
              ...questions.map(questionCard),
              AppButton(
                text: isLoading ? 'Submitting...' : 'Show Match %',
                icon: Icons.favorite_rounded,
                onTap: isLoading ? () {} : handleSubmit,
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int matchPercentage;
  final String userName;

  const ResultScreen({super.key, required this.matchPercentage, required this.userName});

  String resultMessage() {
    if (matchPercentage >= 90) {
      return 'You know me too well 😳💛';
    } else if (matchPercentage >= 70) {
      return 'Okayy you’re close 😌';
    } else if (matchPercentage >= 50) {
      return 'Hmm you need to know me better 👀';
    } else {
      return 'Do you even know me 😭';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Result'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 72, color: AppColors.buttonPink),
            const SizedBox(height: 20),
            Text(
              '$matchPercentage%',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w800,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You and Disha match',
              style: TextStyle(fontSize: 20, color: AppColors.text),
            ),
            const SizedBox(height: 18),
            Text(
              resultMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 30),
            AppButton(
              text: 'Choose Another Section',
              icon: Icons.home_rounded,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(userName: userName),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NoteScreen extends StatefulWidget {
  final String userName;

  const NoteScreen({super.key, required this.userName});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  Future<void> handleSubmit() async {
    if (noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.submitNote(
        name: widget.userName,
        message: noteController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note sent to Disha 💌')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ThankYouScreen(userName: widget.userName),
        ),
      );
      noteController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit note: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note for Disha'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Write something for me 💌',
              subtitle: 'Anything soft, real, honest, or silly',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: noteController,
              maxLines: 8,
              decoration: appInputDecoration('Write anything you feel for Disha'),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: isLoading ? 'Sending...' : 'Send Note',
              icon: Icons.send_rounded,
              onTap: isLoading ? () {} : handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  final String userName;

  const FavoritesScreen({super.key, required this.userName});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final foodController = TextEditingController();
  final songController = TextEditingController();
  final placeController = TextEditingController();
  final movieController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    foodController.dispose();
    songController.dispose();
    placeController.dispose();
    movieController.dispose();
    super.dispose();
  }

  Widget field(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: appInputDecoration(hint),
      ),
    );
  }

  Future<void> handleSubmit() async {
    if (foodController.text.trim().isEmpty ||
        songController.text.trim().isEmpty ||
        placeController.text.trim().isEmpty ||
        movieController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all favorite fields 💗'),
        ),
      );
      return;
    }
    setState(() => isLoading = true);

    try {
      await ApiService.submitFavorites(
        name: widget.userName,
        data: {
          'favorite_food': foodController.text.trim(),
          'favorite_song_type': songController.text.trim(),
          'favorite_place': placeController.text.trim(),
          'favorite_movie_vibe': movieController.text.trim(),
        },
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ThankYouScreen(userName: widget.userName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit favorites: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            const SectionHeading(
              title: 'Your Favorites 💕',
              subtitle: 'Tell me about your favorites',
            ),
            const SizedBox(height: 24),
            field('Your favorite food', foodController),
            field('Your favorite song type', songController),
            field('Your favorite place', placeController),
            field('Your favorite movie vibe', movieController),
            const SizedBox(height: 8),
            AppButton(
              text: isLoading ? 'Submitting...' : 'Submit Favorites',
              icon: Icons.favorite_rounded,
              onTap: isLoading ? () {} : handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  final String userName;

  const AdminDashboardScreen({super.key, required this.userName});

  Widget adminCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.heading),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.text),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: () {
          if (title == 'View Notes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminNotesScreen(),
              ),
            );
          } else if (title == 'View Slam Responses') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminSlamResponsesScreen(),
              ),
            );
          } else if (title == 'View Quiz Responses') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminQuizResponsesScreen(),
              ),
            );
          } else if (title == 'View Favorites Responses') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminFavoritesResponsesScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section is not connected yet'),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel - $userName'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            const SectionHeading(
              title: 'Admin Dashboard 👑',
              subtitle: 'Your private space inside DishaVerse',
            ),
            const SizedBox(height: 24),
            adminCard(
              context,
              'View Slam Responses',
              'Open all slam responses',
              Icons.menu_book_rounded,
            ),
            adminCard(
              context,
              'View Quiz Responses',
              'See all quiz scores and answers',
              Icons.quiz_rounded,
            ),
            adminCard(
              context,
              'View Notes',
              'Read all notes from friends',
              Icons.edit_note_rounded,
            ),
            adminCard(
              context,
              'View Favorites Responses',
              'See all favorites submitted by friends',
              Icons.star_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
class ThankYouScreen extends StatelessWidget {
  final String userName;

  const ThankYouScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A little message 💛'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_rounded,
              size: 80,
              color: AppColors.buttonPink,
            ),
            const SizedBox(height: 24),
            const Text(
              'Thank you for being part of my world 💛',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Your time, your words, and your little effort mean a lot to me.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 30),
            AppButton(
              text: 'Choose Another Section',
              icon: Icons.home_rounded,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(userName: userName),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
class AdminNotesScreen extends StatefulWidget {
  const AdminNotesScreen({super.key});

  @override
  State<AdminNotesScreen> createState() => _AdminNotesScreenState();
}

class _AdminNotesScreenState extends State<AdminNotesScreen> {
  late Future<List<dynamic>> notesFuture;

  @override
  void initState() {
    super.initState();
    notesFuture = ApiService.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                notesFuture = ApiService.getNotes();
              });
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong. Please try again.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final notes = snapshot.data ?? [];

            if (notes.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 50,
                      color: AppColors.buttonPink,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No notes yet 💌',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your friends’ messages will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['name']?.toString() ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note['message']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        note['created_at']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AdminSlamResponsesScreen extends StatefulWidget {
  const AdminSlamResponsesScreen({super.key});

  @override
  State<AdminSlamResponsesScreen> createState() =>
      _AdminSlamResponsesScreenState();
}

class _AdminSlamResponsesScreenState extends State<AdminSlamResponsesScreen> {
  late Future<List<dynamic>> slamFuture;

  @override
  void initState() {
    super.initState();
    slamFuture = ApiService.getSlamResponses();
  }

  Widget detailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slam Responses'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: slamFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final responses = snapshot.data ?? [];

            if (responses.isEmpty) {
              return const Center(
                child: Text(
                  'No slam responses found yet 💛',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.heading,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: responses.length,
              itemBuilder: (context, index) {
                final slam = responses[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      slam['name']?.toString() ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                    subtitle: Text(
                      slam['created_at']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 8),
                      detailText('Nickname', slam['nickname']?.toString() ?? ''),
                      detailText('How Met', slam['how_met']?.toString() ?? ''),
                      detailText('First Impression',
                          slam['first_impression']?.toString() ?? ''),
                      detailText('Favorite Thing',
                          slam['favorite_thing']?.toString() ?? ''),
                      detailText('Describe in 3 Words',
                          slam['describe_in_3_words']?.toString() ?? ''),
                      detailText('Perception Change',
                          slam['perception_change']?.toString() ?? ''),
                      detailText('Vibe', slam['vibe']?.toString() ?? ''),
                      detailText('Cute Habit',
                          slam['cute_habit']?.toString() ?? ''),
                      detailText('Change Habit',
                          slam['change_habit']?.toString() ?? ''),
                      detailText('Grateful For',
                          slam['grateful_for']?.toString() ?? ''),
                      detailText('Memory', slam['memory']?.toString() ?? ''),
                      detailText('Common Thing',
                          slam['common_thing']?.toString() ?? ''),
                      detailText('Dedicated Song',
                          slam['dedicated_song']?.toString() ?? ''),
                      detailText('Character Type',
                          slam['character_type']?.toString() ?? ''),
                      detailText('Things To Try',
                          slam['things_to_try']?.toString() ?? ''),
                      detailText('Hobbies', slam['hobbies']?.toString() ?? ''),
                      detailText('Favorite Shows',
                          slam['favorite_shows']?.toString() ?? ''),
                      detailText('Suggestions',
                          slam['suggestions']?.toString() ?? ''),
                      detailText('Unsaid Thing',
                          slam['unsaid_thing']?.toString() ?? ''),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
class AdminFavoritesResponsesScreen extends StatefulWidget {
  const AdminFavoritesResponsesScreen({super.key});

  @override
  State<AdminFavoritesResponsesScreen> createState() =>
      _AdminFavoritesResponsesScreenState();
}

class _AdminFavoritesResponsesScreenState
    extends State<AdminFavoritesResponsesScreen> {
  late Future<List<dynamic>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = ApiService.getFavoritesResponses();
  }

  Widget detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Responses'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No favorites responses yet 💗',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.heading,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final fav = data[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      fav['name']?.toString() ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                    subtitle: Text(
                      fav['created_at']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 8),
                      detail('Favorite Food', fav['favorite_food']?.toString() ?? ''),
                      detail('Favorite Song Type', fav['favorite_song_type']?.toString() ?? ''),
                      detail('Favorite Place', fav['favorite_place']?.toString() ?? ''),
                      detail('Favorite Movie Vibe', fav['favorite_movie_vibe']?.toString() ?? ''),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AdminQuizResponsesScreen extends StatefulWidget {
  const AdminQuizResponsesScreen({super.key});

  @override
  State<AdminQuizResponsesScreen> createState() =>
      _AdminQuizResponsesScreenState();
}

class _AdminQuizResponsesScreenState
    extends State<AdminQuizResponsesScreen> {
  late Future<List<dynamic>> quizFuture;

  @override
  void initState() {
    super.initState();
    quizFuture = ApiService.getQuizResponses();
  }

  Widget detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.text, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Responses')),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, AppColors.pale],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: quizFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(
                child: Text('No quiz responses yet 💛'),
              );
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final q = data[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      q['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                      ),
                    ),
                    subtitle: Text(
                      'Score: ${q['score']}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    children: [
                      detail('Music', q['q1_music'] ?? ''),
                      detail('Reaction', q['q2_reaction'] ?? ''),
                      detail('Food', q['q3_food'] ?? ''),
                      detail('Hangout', q['q4_hangout'] ?? ''),
                      detail('Quality', q['q5_quality'] ?? ''),
                      detail('Values', q['q6_values'] ?? ''),
                      detail('Nature', q['q7_nature'] ?? ''),
                      detail('Personality', q['q8_personality'] ?? ''),
                      detail('Time', q['q9_time'] ?? ''),
                      detail('Career', q['q10_career'] ?? ''),
                      detail('Overthinking', q['q11_overthinking'] ?? ''),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}