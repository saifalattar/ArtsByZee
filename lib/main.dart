import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/signup.dart';
import 'package:artsbyzee/modules/screens/homeScreen.dart';
import 'package:artsbyzee/shared/components.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await SharedPreferences.getInstance();
  userToken = db.getString("token");
  print(userToken);
  runApp(BlocProvider(
    create: (context) => ZEECubit(),
    child: BlocBuilder<ZEECubit, ZEEStates>(builder: (context, states) {
      return MaterialApp(
          home: userToken == null ? const SignUp() : const HomeScreen());
    }),
  ));
}
