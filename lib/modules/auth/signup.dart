import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/modules/auth/verifyPassword.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hidePass = true;
    final formKey = GlobalKey<FormState>();

    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, states) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
          backgroundColor: babyBlue,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Create New Account",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: pink,
                          border: Border.all(color: Colors.white, width: 5)),
                      margin: const EdgeInsets.all(25),
                      height: 366,
                      child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  controller: userName,
                                  keyboardType: TextInputType.name,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  decoration: inputDecoration(
                                      "Username",
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      pink),
                                ),
                                TextFormField(
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  decoration: inputDecoration(
                                      "E-Mail",
                                      Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      pink),
                                ),
                                TextFormField(
                                  controller: passWord,
                                  obscureText: hidePass,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    } else if (val.length < 10) {
                                      return "Password is weak, its length must be more than 10 characters";
                                    } else if (!val.contains("@") &&
                                        !val.contains("#") &&
                                        !val.contains("!") &&
                                        !val.contains("\$") &&
                                        !val.contains("%")) {
                                      return "Password must have at least one special character";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      floatingLabelStyle:
                                          const TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: babyBlue,
                                            width: 3,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Password",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            hidePass = !hidePass;
                                            cubit.emit(UpdateSmallData());
                                          },
                                          icon: hidePass
                                              ? Icon(
                                                  Icons.remove_red_eye_outlined)
                                              : Icon(Icons.remove_red_eye)),
                                      prefixIcon: const Icon(Icons.password,
                                          color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(color: pink))),
                                ),
                                TextFormField(
                                  controller: phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    } else if (val.length != 11 &&
                                        val.length != 13 &&
                                        val.length != 14) {
                                      return "Wrong mobile number";
                                    }
                                  },
                                  decoration: inputDecoration(
                                      "Phone Number",
                                      Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      pink),
                                ),
                              ],
                            ),
                          )),
                    ),
                    isRendered
                        ? ZeeAppButton("Sign Up", () async {
                            if (formKey.currentState!.validate()) {
                              await cubit.verifyUser(
                                  context, email.text, passWord.text);
                            }
                          })
                        : const Loading(),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ?"),
                        TextButton(
                            onPressed: () {
                              goTo(context, LogIn());
                            },
                            child: Text("LogIn"))
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "Developed by : ",
                        style: TextStyle(
                            fontFamily: "content",
                            color: Colors.grey[600],
                            fontSize: 11),
                      ),
                      Image.asset(
                        "images/iyp grey.png",
                        width: 40,
                      ),
                    ]),
                  ]),
            ),
          ));
    });
  }
}
