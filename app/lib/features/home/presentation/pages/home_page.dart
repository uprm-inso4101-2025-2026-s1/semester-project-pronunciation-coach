import '../../../../core/common/colors.dart';
import 'package:app/features/dashboard/presentation/widgets/user_info_box.dart';
import 'package:app/features/dashboard/presentation/widgets/welcome_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/features/dashboard/presentation/widgets/home_sections.dart';
import 'package:app/features/ChatBotPage/chat_bot_page.dart';

/// ===========================================================================
/// HOME SCREEN - MAIN APPLICATION LANDING PAGE
/// ===========================================================================
/// 
/// PURPOSE:
/// - Primary landing page and navigation hub for the application
/// - Centralized access point to all main features and activities
/// - Personalized user dashboard with quick access to key functions
/// 
/// ARCHITECTURE:
/// - Stateful widget managing the main home interface
/// - Integrates multiple dashboard widgets for comprehensive overview
/// - Provides floating action button for quick chatbot access
/// 
/// LAYOUT STRUCTURE:
/// 1. App Bar: Branding and navigation
/// 2. User Info Box: Profile summary and statistics
/// 3. Welcome Back Box: Personalized greeting and quick actions
/// 4. Home Sections: Main activity cards and features
/// 5. Floating Action Button: Quick access to AI chatbot
/// ===========================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main background color from app theme
      backgroundColor: AppColors.background,
      
      // Application header with branding
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
      
      // Main content area with scrollable layout
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // User profile and statistics section
                const UserInfoBox(
                    name: "Maria Hernandez",
                    avatarURL: "https://www.applesfromny.com/wp-content/uploads/2020/06/SnapdragonNEW.png",
                    proficiencyLevel: "Intermediate Student",
                ),
                const SizedBox(height: 10),
                
                // Personalized welcome and quick actions section
                const WelcomeBackBox(
                    name: "Maria", 
                ),
                const SizedBox(height: 16), // Espacio
                
                // Main activity sections and feature cards
                const HomeSections(),
           ],
        ),
      ),
      
      // Quick access floating action button for AI chatbot
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
