import 'dart:async';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:get/get.dart';

String phoneNumber = "";
String otp = "00000";
bool login = false;
var verificationCode;

class OTPState extends GetxController {
  // phone number

  // Initial Count Timer value

  var SCount = 30;
  var times = 2;

  // button enable setting
  bool buttonEnable = false;

  // texts
  String belowButton = "";
  String mainButtonText = "Resend OTP";
  String bottomText = "";
  String topText1 = "Incorrect number? ";
  String topText2 = "Change";

  //object for Timer Class
  late Timer _timer;

  // a Method to start the Count Down
  void StateTimerStart() {
    //Timer Loop will execute every 1 second, until it reach 0
    // once counter value become 0, we store the timer using _timer.cancel()

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      belowButton = "Resend OTP in ${SCount}s";
      if (SCount > 0) {
        SCount--;
        update();
      } else {
        buttonEnable = true;
        belowButton = "";
        update();
        _timer.cancel();
      }
    });
  }

  // user can set count down seconds, from TextField
  void setnumber(var num) {
    SCount = int.parse(num);
    update();
  }

  // pause the timer
  void Pause() {
    _timer.cancel();
    update();
  }

  // reset count value to 10
  void reset() {
    _timer.cancel();
    SCount = 30 * times++;
    update();
  }

  void changeTexts() {
    mainButtonText = "Done";
    if (SCount == 0) {
      belowButton = "Don’t you receive any code?";
      bottomText = "resend Code";
    }
    topText1 = "";
    topText2 = "";
    update();
  }
}
