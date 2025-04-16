📝 ToDo App
A simple yet powerful To-Do App built with Flutter using BLoC pattern, Sqflite, and Local Theme Persistence. Organize your life, tasks, and productivity—all in one place.

🚀 Features
✅ Add, Edit, Delete Tasks

📅 Categorized by status: New, Done, Archived

🌓 Dark Mode & Light Mode — saved locally

💾 Data saved using SQLite (sqflite)

🧠 State Management with flutter_bloc

📱 Clean UI with Material Design principles

🧪 Tech Stack

Tool / Library	Use
Flutter	Cross-platform UI
flutter_bloc	State Management
sqflite	Local storage
intl	Date formatting
shared_preferences / cache_helper	Theme mode persistence
📸 Screenshots
<div align="center"> <img src="screenshots/1.png" width="250" /> <img src="screenshots/2.png" width="250" /> <img src="screenshots/3.png" width="250" /> </div>
🔧 Getting Started
bash
Copy
Edit
git clone https://github.com/Mohmdhamad/todoapp.git
cd todoapp
flutter pub get
flutter run
🧠 Structure Overview
bash
Copy
Edit
lib/
├── layout/
│   └── todo_app/
│       └── todo_layout.dart
├── modules/
│   ├── archived_tasks/
│   ├── done_tasks/
│   ├── new_tasks/
├── shared/
│   ├── bloc_observer.dart
│   ├── components/
│   ├── constants/
│   ├── cubit/
│   ├── network/
│   │   └── local/
│   │       └── sqflite_helper.dart
👨‍💻 Author
Mohamed Hamad
