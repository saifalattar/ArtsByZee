import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/forgotPassword.dart';
import 'package:artsbyzee/modules/auth/signup.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hidePass = true;

    var formKey = GlobalKey<FormState>();
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
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
                    "Log Into Your Account",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: pink,
                        border: Border.all(color: Colors.white, width: 5)),
                    margin: const EdgeInsets.all(25),
                    height: 300,
                    child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                    const Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    pink),
                              ),
                              const SizedBox(
                                height: 45,
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
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: pink))),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Forgot your password ?"),
                                  TextButton(
                                      onPressed: () {
                                        goTo(context, const ForgotPasswrod());
                                      },
                                      child: const Text("Reset password"))
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                  isRendered
                      ? ZeeAppButton("Log In", () async {
                          if (formKey.currentState!.validate()) {
                            await ZEECubit.Get(context)
                                .logIn(context, email.text, passWord.text);
                          }
                        })
                      : const Loading(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?"),
                      TextButton(
                          onPressed: () => goTo(context, const SignUp()),
                          child: const Text("Sign Up"))
                    ],
                  )
                ],
              ),
            ),
          ));
    });
  }
}
