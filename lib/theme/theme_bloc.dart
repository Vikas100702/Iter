import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggle) {
        emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
      }
    });
  }
}
