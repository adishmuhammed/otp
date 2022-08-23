import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp/enter_otp.dart';
import 'package:otp/login_success.dart';
import 'package:otp/otp_controller.dart';
import 'package:otp/styles.dart';
import 'package:text_divider/text_divider.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/consts/strings_consts.dart';
import 'package:extended_phone_number_input/models/countries_list.dart';
import 'package:extended_phone_number_input/models/country.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:extended_phone_number_input/utils/number_converter.dart';
import 'package:extended_phone_number_input/widgets/country_code_list.dart';
import 'package:country_picker/country_picker.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GetMaterialApp(home: SignIn()));
}

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  static Color primary = const Color(0xff2C3234);
  static Color secondary = const Color(0xff9B9B9B);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Get.to(Success());
      }
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    // used for correcting sizes in different resolutions
    final heightFactor = Get.height / 812;
    final widthFactor = Get.width / 375;
    return DefaultTabController(
        length: 2,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(56 * heightFactor),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 17 * widthFactor),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Color(0xffE2E2E2)),
                            color: Colors.lightGreenAccent),
                        labelColor: primary,
                        tabs: [
                          Tab(
                            child: Text(
                              "Sign In",
                              style: normal(14 * heightFactor),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Sign Up",
                              style: normal(14 * heightFactor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                signInTab(widthFactor, heightFactor, context, auth),
                signUpTab(widthFactor, heightFactor, context, auth)
              ],
            ),
          );
        }));
  }

  signInTab(
      double widthFactor, double heightFactor, BuildContext context, auth) {
    final PhoneNumberInputController phoneNumberInputController =
        PhoneNumberInputController(context);
    return Padding(
      padding: EdgeInsets.only(
          left: 16 * widthFactor,
          top: 68 * heightFactor,
          right: 16 * widthFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back!!",
            style: GoogleFonts.lora(
                fontSize: 28 * heightFactor, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 63 * heightFactor,
          ),
          Text(
            "Please login with your phone number.",
            style: normal(16 * heightFactor),
          ),
          SizedBox(
            height: 16 * heightFactor,
          ),
          PhoneNumberInput(
              initialCountry: 'IN',
              errorText: "Invalid Number",
              hint: "Phone Number",
              countryListMode: CountryListMode.dialog,
              contactsPickerPosition: ContactsPickerPosition.suffix,
              allowPickFromContacts: false,
              onChanged: (p0) => phoneNumber = p0,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300))),
          SizedBox(
            height: 30 * heightFactor,
          ),
          OutlinedButton(
            // Within the `FirstRoute` widget
            onPressed: () {
              Get.to(OtpScreen());
            },
            child: Text(
              "Continue",
              style: normal(17 * heightFactor),
            ),
            style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.lightGreenAccent,
                fixedSize: Size(343 * widthFactor, 48 * heightFactor)),
          ),
          SizedBox(
            height: 27 * heightFactor,
          ),
          TextDivider(
            text: Text(
              "Or",
              style: TextStyle(
                  fontFamily: "Cera-Pro",
                  fontSize: 16 * heightFactor,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 23 * heightFactor,
          ),
          // social buttons
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/metamask1.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style: normal(14 * heightFactor),
                ),
                Text(
                  "Metamask",
                  style: bold(14 * heightFactor).copyWith(color: primary),
                )
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/google1.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style: normal(14 * heightFactor),
                ),
                Text(
                  "Google",
                  style: bold(14 * heightFactor).copyWith(color: primary),
                )
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Vector.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style:
                      normal(14 * heightFactor).copyWith(color: Colors.white),
                ),
                Text(
                  "Apple",
                  style: bold(14 * heightFactor).copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: bold(14 * heightFactor),
              ),
              GestureDetector(
                onTap: () => DefaultTabController.of(context)!.animateTo(1),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: "Satoshi",
                      fontWeight: FontWeight.w700,
                      color: Colors.lightGreenAccent,
                      fontSize: 14 * Get.textScaleFactor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  signUpTab(
      double widthFactor, double heightFactor, BuildContext context, auth) {
    final PhoneNumberInputController phoneNumberInputController =
        PhoneNumberInputController(context);
    return Padding(
      padding: EdgeInsets.only(
          left: 16 * widthFactor,
          top: 68 * heightFactor,
          right: 16 * widthFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to App",
            style: GoogleFonts.lora(
                fontSize: 28 * heightFactor, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 63 * heightFactor,
          ),
          Text(
            "Please signup with your phone number to get registered",
            style: normal(16 * heightFactor),
          ),
          SizedBox(
            height: 16 * heightFactor,
          ),
          PhoneNumberInput(
              initialCountry: 'IN',
              locale: 'en',
              countryListMode: CountryListMode.dialog,
              contactsPickerPosition: ContactsPickerPosition.suffix,
              allowPickFromContacts: false,
              hint: "Phone Number",
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300))),
          SizedBox(
            height: 30 * heightFactor,
          ),
          OutlinedButton(
            onPressed: () {
              Get.to(OtpScreen());
            },
            child: Text(
              "Continue",
              style: normal(17 * heightFactor),
            ),
            style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.lightGreenAccent,
                fixedSize: Size(343 * widthFactor, 48 * heightFactor)),
          ),
          SizedBox(
            height: 27 * heightFactor,
          ),
          TextDivider(
            text: Text(
              "Or",
              style: TextStyle(
                  fontFamily: "Cera-Pro",
                  fontSize: 16 * heightFactor,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 23 * heightFactor,
          ),
          // social buttons
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/metamask1.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style: normal(14 * heightFactor),
                ),
                Text(
                  "Metamask",
                  style: bold(14 * heightFactor).copyWith(color: primary),
                )
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/google1.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style: normal(14 * heightFactor),
                ),
                Text(
                  "Google",
                  style: bold(14 * heightFactor).copyWith(color: primary),
                )
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              shape:
                  StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Vector.png',
                  width: 21 * widthFactor,
                  height: 23 * heightFactor,
                ),
                Text(
                  " Connect to ",
                  style:
                      normal(14 * heightFactor).copyWith(color: Colors.white),
                ),
                Text(
                  "Apple",
                  style: bold(14 * heightFactor).copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: bold(14 * heightFactor),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: "Satoshi",
                      fontWeight: FontWeight.w700,
                      color: Colors.lightGreenAccent,
                      fontSize: 14 * heightFactor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> sendOTP(
      {required String phoneNumber, required FirebaseAuth auth}) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          Get.to(Success());
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Get.showSnackbar(GetSnackBar(message: "invalid mobile number"));
          }
          print(e);
        },
        codeSent: (String verificationId, int? resendToken) async {
          verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
