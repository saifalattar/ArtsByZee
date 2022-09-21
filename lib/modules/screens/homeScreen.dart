import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/modules/screens/productsScreen.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
        backgroundColor: babyBlue,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  cubit.signOut().then((value) {
                    goTo(context, const LogIn());
                  });
                },
                icon: const Icon(Icons.person))
          ],
          title: const Center(
            child: Text("Home"),
          ),
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
        ),
        body: Column(
          children: [
            FloatingActionButton(onPressed: () {
              goTo(context, const ProductsScreen());
            }),
            Loading()
          ],
        ),
      );
    });
  }
}
