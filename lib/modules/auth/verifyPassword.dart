import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/forgotPassword.dart';
import 'package:artsbyzee/modules/screens/homeScreen.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyUser extends StatelessWidget {
  final bool isVerify;
  final String? Email;
  const VerifyUser({Key? key, this.isVerify = true, this.Email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(this.Email);
    return BlocBuilder<ZEECubit, ZEEStates>(builder: ((context, state) {
      var cubit = ZEECubit.Get(context);
      return Scaffold(
          backgroundColor: babyBlue,
          body: SafeArea(
            child: Column(children: [
              Center(
                child: Text(
                  isVerify
                      ? "\n\nVerify your account"
                      : "\n\nReset your password",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              const Text("\nWrite the OTP we sent it for you in your email."),
              isRendered
                  ? TextButton(
                      onPressed: () async {
                        isVerify
                            ? await cubit.verifyUser(
                                context,
                                email.text,
                                passWord.text,
                              )
                            : await cubit.forgotPassword(
                                context, Email.toString());
                      },
                      child: const Text("\nResend email\n\n"))
                  : const Loading(width: 90),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme.defaults(inactiveColor: pink),
                    appContext: context,
                    length: 6,
                    onChanged: (value) {
                      if (value == tempOtp) {
                        if (isVerify) {
                          cubit.signUp(userName.text, email.text, passWord.text,
                              phoneNumber.text, context);
                          goTo(context, const HomeScreen());
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false);
                        } else {
                          goTo(context, ResetPassword(Email as String));
                        }
                      } else if (value.length == 6 && value != tempOtp) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Row(
                              children: const [
                                Icon(Icons.error),
                                Text("Incorrect OTP , Try again !!")
                              ],
                            )));
                      }
                    }),
              )
            ]),
          ));
    }));
  }
}
