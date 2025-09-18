# Semester Project – Pronunciation Coach

A Flutter application for the course semester project.  
This repo has been initialized as a proper Flutter project so everyone can clone and run it immediately.
When you open the project in your IDE, make sure to use the cd command to navigate to the "app" folder first.
This will make sure the project runs correctly and reads all the necessary files. If you have any doubts regarding
this, contact a Team Leader or Manager.

A few resources to get you started if this is your first Flutter project:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 🔧 Project Structure 

For this project, we will be having a structure to follow for programming. There will be a "core" folder which will 
include the core files of the project. These files include: widgets to be reused throughout the app, constants, and more. 
For the features of the app, there will be a folder for each folder. In there, there will be a "widgets", "pages", and "routes" folder in where you will store the routes, widgets, and pages SPECIFICALLY from thagt feature. This will ensure efficiency and code organization. If you have any doubts regarding this, contact a Team Leader or Manager.


## 🔧 Verify Your Setup 

Run these commands to make sure Flutter is installed correctly:

```bash
flutter --version
flutter doctor

## After everything is running without problems, proceed to clone the repo.

git clone https://github.com/<org-or-username>/semester-project-pronunciation-coach.git
cd semester-project-pronunciation-coach\app  
flutter pub get
flutter run
