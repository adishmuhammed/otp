import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp/main.dart';
import 'package:otp/otp_controller.dart';
import 'login_success.dart';
import 'styles.dart';
import 'package:pinput/pinput.dart';
import 'package:async/async.dart';
import 'package:country_picker/country_picker.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  static Color primary = const Color(0xff2C3234);
  static Color secondary = const Color(0xff9B9B9B);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OTPState state = Get.put(OTPState());

  @override
  Widget build(BuildContext context) {
    state.StateTimerStart();
    FirebaseAuth auth = FirebaseAuth.instance;
    sendOTP(phoneNumber: phoneNumber);
    return GetBuilder<OTPState>(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(17 * Get.textScaleFactor),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter OTP",
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.w600,
                        fontSize: 28 * Get.textScaleFactor,
                        color: OtpScreen.primary),
                  ),
                  SizedBox(
                    height: 16 * Get.textScaleFactor,
                  ),
                  Text(
                    "An five digit has been code sent to number",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: OtpScreen.primary,
                      fontFamily: "GenaralSans",
                    ),
                  ), // phone number here
                  SizedBox(
                    height: 16 * Get.textScaleFactor,
                  ),
                  Text(
                    state.topText1,
                    style: TextStyle(
                        fontFamily: "GenaralSans",
                        fontSize: 14 * Get.textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: OtpScreen.primary),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendOTP(
                        phoneNumber: phoneNumber,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (state.topText2 == "Change") {
                          Get.to(SignIn());
                        }
                      },
                      child: Text(
                        state.topText2,
                        style: const TextStyle(
                            fontFamily: "Cenra-Pro",
                            fontWeight: FontWeight.w500,
                            color: Colors.lightGreenAccent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 98,
              ),
              pipout(),
              SizedBox(
                height: 60 * Get.textScaleFactor,
              ),
              OutlinedButton(
                  onPressed: () async {
                    if (state.buttonEnable) {
                      if (state.mainButtonText == "Resend OTP") {
                        sendOTP(
                          phoneNumber: phoneNumber,
                        );
                      }
                      if (state.mainButtonText == "Done") {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationCode,
                                      smsCode: otp))
                              .then((value) async {
                            if (value.user != null) {
                              Get.to(Success());
                            }
                          });
                        } catch (e) {
                          Get.snackbar("authentication problem", e.toString());
                          print(otp);
                          print(e);
                        }
                      }
                    }
                  },
                  style: (state.buttonEnable)
                      ? OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.lightGreenAccent,
                          fixedSize: Size(343 * Get.textScaleFactor,
                              48 * Get.textScaleFactor))
                      : OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.grey,
                          fixedSize: Size(343 * Get.textScaleFactor,
                              48 * Get.textScaleFactor)),
                  child: Text(
                    state.mainButtonText,
                    style: normal(17 * Get.textScaleFactor),
                  )),
              SizedBox(
                height: 12 * Get.textScaleFactor,
              ),
              Text(
                state.belowButton,
                style: normal(14 * Get.textScaleFactor),
              ),
              SizedBox(
                height: 8 * Get.textScaleFactor,
              ),
              GestureDetector(
                onTap: () async {
                  if (state.bottomText == "resend Code") {
                    state.reset();
                    sendOTP(phoneNumber: phoneNumber);
                  }
                },
                child: Text(
                  state.bottomText,
                  style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontFamily: "CeraPro",
                      fontWeight: FontWeight.w700,
                      fontSize: 14 * Get.textScaleFactor),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget pipout() {
    final defaultPinTheme = PinTheme(
      width: Get.width,
      height: 46 * Get.textScaleFactor,
      textStyle: TextStyle(
          fontSize: 34 * Get.textScaleFactor,
          color: Colors.black54,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: OtpScreen.secondary),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border(bottom: BorderSide(color: OtpScreen.primary)),
    );

    return Pinput(
      length: 6,
      submittedPinTheme: focusedPinTheme,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorText: "Incorrect OTP",
      showCursor: false,
      closeKeyboardWhenCompleted: true,
      onCompleted: (pin) => print(pin),
      onChanged: (value) {
        otp = value;
        state.changeTexts();
        state.buttonEnable = true;
        state.mainButtonText = "Done";
      },
    );
  }

  Future<void> sendOTP({
    required String phoneNumber,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.to(Success());
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Get.showSnackbar(GetSnackBar(message: "invalid mobile number"));
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationCode = verificationId;
        });
  }

  @override
  void initState() {
    super.initState();
    state.reset();
    sendOTP(phoneNumber: phoneNumber);
  }
}
