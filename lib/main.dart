import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iter/theme/theme_bloc.dart';
import 'package:iter/homePage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:iter/utils/constants.dart';

import 'chat/chat_bloc.dart';

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
