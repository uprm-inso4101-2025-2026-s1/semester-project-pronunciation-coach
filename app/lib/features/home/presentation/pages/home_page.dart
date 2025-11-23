import '../../../../core/common/colors.dart';
import 'package:app/features/dashboard/presentation/widgets/user_info_box.dart';
import 'package:app/features/dashboard/presentation/widgets/welcome_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/features/dashboard/presentation/widgets/home_sections.dart';
import 'package:app/features/ChatBotPage/chat_bot_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const UserInfoBox(
                    name: "Maria Hernandez",
                    avatarURL: "https://www.applesfromny.com/wp-content/uploads/2020/06/SnapdragonNEW.png",
                    proficiencyLevel: "Intermediate Student",
                ),
                const SizedBox(height: 10),
                const WelcomeBackBox(
                    name: "Maria", 
                ),
                const SizedBox(height: 16), // Espacio
                const HomeSections(),
           ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
            );
        },
      )
    );
  }
}
