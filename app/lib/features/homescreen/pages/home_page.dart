import 'package:app/core/constants/colors.dart';
import 'package:app/features/homescreen/widgets/user_info_box.dart';
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
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                automaticallyImplyLeading: false,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("test"),
              ]              
            )
        );
    }
}
