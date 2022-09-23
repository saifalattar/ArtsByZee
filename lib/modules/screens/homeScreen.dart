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
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "images/ZeeIcon.png",
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: pink,
                              borderRadius: BorderRadius.circular(25)),
                          height: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("See All Products\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.white)),
                              IconButton(
                                  onPressed: () {
                                    goTo(context, const ProductsScreen());
                                  },
                                  icon: const Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Log Out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white)),
                              IconButton(
                                  onPressed: () {
                                    cubit.signOut().then((value) {
                                      goTo(context, const LogIn());
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.navigate_before,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Developed by : ",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                  ),
                                  Image.asset(
                                    "images/iyp grey.png",
                                    width: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]))));
    });
  }
}
