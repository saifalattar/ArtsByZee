import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/shared/components.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswrod extends StatelessWidget {
  const ForgotPasswrod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      var theEmail = TextEditingController();
      var cubit = ZEECubit.Get(context);
      return Scaffold(
        backgroundColor: babyBlue,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: theEmail,
                decoration: InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: Icon(Icons.email, color: pink),
                    prefixIconColor: pink,
                    floatingLabelStyle: TextStyle(color: pink),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: pink,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: babyBlue,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              isRendered
                  ? ZeeAppButton("Submit", () async {
                      await cubit.forgotPassword(context, theEmail.text);
                    })
                  : const Loading(
                      width: 150,
                    )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          backgroundColor: pink,
          title: const Center(child: Text("Forgot Password")),
        ),
      );
    }));
  }
}

class ResetPassword extends StatelessWidget {
  final String email;
  const ResetPassword(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var password = TextEditingController();
    var confirmPass = TextEditingController();

    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
        backgroundColor: babyBlue,
        appBar: AppBar(
          elevation: 0,
          title: const Center(child: Text("Change password")),
          toolbarHeight: 50,
          backgroundColor: pink,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                          labelText: "New Password",
                          prefixIcon: Icon(Icons.password, color: pink),
                          prefixIconColor: pink,
                          floatingLabelStyle: TextStyle(color: pink),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: babyBlue,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: confirmPass,
                      decoration: InputDecoration(
                          labelText: "Confirm new password",
                          prefixIcon: Icon(Icons.password, color: pink),
                          prefixIconColor: pink,
                          floatingLabelStyle: TextStyle(color: pink),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: babyBlue,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
                isRendered
                    ? ZeeAppButton("Change Password", () {
                        if (confirmPass.text == password.text &&
                            password.text != "" &&
                            confirmPass.text != "") {
                          cubit.changePassword(context, email, password.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Row(
                                children: const [
                                  Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  Text("Passwords are not match, Try again !!")
                                ],
                              )));
                        }
                      })
                    : const Loading(
                        width: 150,
                      )
              ],
            ),
          ),
        ),
      );
    }));
  }
}
