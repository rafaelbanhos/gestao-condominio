import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/bloc/progress_bloc.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:projeto_final/screens/login.dart';

void main() {
  runApp(BlocProvider(
    blocs: [
      Bloc((i) => UserBloc()),
      Bloc((i) => ReportBloc()),
      Bloc((i) => ProgressBloc())
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Questrial",
        ),
        home: Login()),
  ));
}
