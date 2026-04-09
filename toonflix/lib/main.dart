import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';
import 'package:toonflix/services/api_service.dart';

void main() {
  runApp(App());
}

//UI부분
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home_screen의 파일 내용을 import했다면 그 파일 안의 클래스 이름과 일치 시켜줘야 함
      home: HomeScreen(),
    );
  }
}
