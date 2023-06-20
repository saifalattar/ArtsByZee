import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/AdminScreens/addProducts.dart';
import 'package:artsbyzee/modules/AdminScreens/allOrders.dart';
import 'package:artsbyzee/modules/AdminScreens/deleteProducts.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          title: const Center(
            child: Text("Admin App"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  ZEECubit.Get(context).signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                      (route) => false);
                },
                icon: const Icon(Icons.person, color: Colors.grey))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                  child: Text(
                "Welcome ZOZAAA !!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.blue[200]),
              )),
              Container(
                decoration: BoxDecoration(
                    color: babyBlue, borderRadius: BorderRadius.circular(25)),
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Total number\nof orders :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    FutureBuilder(
                      builder: (ctx, ss) {
                        if (ss.hasData) {
                          return Text(
                            "${ss.data}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          );
                        }
                        return const Loading(
                          width: 90,
                        );
                      },
                      future: ZEECubit.Get(context).getStatistics(),
                    )
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink[200],
                      borderRadius: BorderRadius.circular(25)),
                  height: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Add new products\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                        IconButton(
                            onPressed: () {
                              goTo(context, const AddProduct());
                            },
                            icon: const Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink[200],
                      borderRadius: BorderRadius.circular(25)),
                  height: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Delete products\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                        IconButton(
                            onPressed: () {
                              goTo(context, const DeleteProduct());
                            },
                            icon: const Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                )
              ]),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: pink, borderRadius: BorderRadius.circular(25)),
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("View Orders\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          goTo(context, const AllOrders());
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
