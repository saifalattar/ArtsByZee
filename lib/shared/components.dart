import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String BASE_URL = "http://192.168.1.15:8000";

String? userToken;

String? tempOtp;

bool isRendered = true;

var email = TextEditingController();
var userName = TextEditingController();
var passWord = TextEditingController();
var phoneNumber = TextEditingController();

Color pink = Colors.pink[100] as Color;
Color blue = Colors.blue[100] as Color;
Color babyBlue = Colors.lightBlue[50] as Color;

InputDecoration inputDecoration(
    String labelText, Icon prefixIcon, Color? borderColor) {
  return InputDecoration(
      floatingLabelStyle: const TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: babyBlue,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10)),
      labelText: labelText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor as Color)));
}

class ZeeAppButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const ZeeAppButton(this.text, this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(pink),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
    );
  }
}

void goTo(BuildContext context, Widget nextPage) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
}

class Loading extends StatelessWidget {
  final double width;
  const Loading({Key? key, this.width = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Image.asset("images/ZeeLoading.gif"),
    );
  }
}
