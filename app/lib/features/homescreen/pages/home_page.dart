import 'package:app/core/constants/colors.dart';
import 'package:app/features/homescreen/widgets/user_info_box.dart';
import 'package:app/features/homescreen/widgets/welcome_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            body: Column(
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
              ]              
            )
        );
    }
}
