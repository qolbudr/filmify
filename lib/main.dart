import 'package:flutter/material.dart';
import 'package:film/page/home.dart';
import 'package:provider/provider.dart';
import 'package:film/model/bookmark.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BookmarkModel>(create: (_) => BookmarkModel()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarIconBrightness: Brightness.light, systemNavigationBarColor: Colors.black)
    );
    return MaterialApp(
      title: 'Filmify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: Color(0xff141414),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xff141414),
          selectedLabelStyle: TextStyle(fontSize: 10),
          unselectedLabelStyle: TextStyle(fontSize: 10)
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}