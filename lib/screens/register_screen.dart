import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp/provider/auth_provider.dart';
import 'package:otp/widgets/backgroung_image.dart';
import 'package:otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "964",
    countryCode: "IQ",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Iraq",
    example: "Iraq",
    displayName: "Iraq",
    displayNameNoCountryCode: "IQ",
    e164Key: "",
  );

// Function to send a verification code to the provided phone number
  Future<void> sendPhoneNumber() async {
    String phoneNumber = "+9647712442505";
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+9647712442505",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification Failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
            ),
          ),
        );
        print('Code Sent: $verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code Auto-Retrieval Timeout: $verificationId');
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 110,
                      ),
                    ),
                    const SizedBox(height: 70),
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Add your phone number. We'll send you a verification code",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: Colors.white,
                      controller: phoneController,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter phone number",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.blue[45],
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                },
                              );
                            },
                            child: Text(
                              "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        suffixIcon: phoneController.text.length > 9
                            ? Container(
                                height: 30,
                                width: 30,
                                margin: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: "Login",
                        onPressed: () => sendPhoneNumber(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
