import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final phoneController =
      TextEditingController();

  final otpController =
      TextEditingController();

  String verificationId = "";

  bool otpSent = false;
  bool loading = false;

  // 📩 SEND OTP
  Future<void> sendOTP() async {
    setState(() {
      loading = true;
    });

    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber:
          phoneController.text.trim(),

      verificationCompleted:
          (PhoneAuthCredential credential) async {

        await FirebaseAuth.instance
            .signInWithCredential(
                credential);

        goToHome();
      },

      verificationFailed:
          (FirebaseAuthException e) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              e.message ??
                  "Verification Failed",
            ),
          ),
        );
      },

      codeSent:
          (String verId,
              int? resendToken) {

        setState(() {
          verificationId = verId;
          otpSent = true;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text("OTP Sent"),
          ),
        );
      },

      codeAutoRetrievalTimeout:
          (String verId) {
        verificationId = verId;
      },
    );

    setState(() {
      loading = false;
    });
  }

  // ✅ VERIFY OTP
  Future<void> verifyOTP() async {
    try {
      setState(() {
        loading = true;
      });

      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode:
            otpController.text.trim(),
      );

      await FirebaseAuth.instance
          .signInWithCredential(
              credential);

      // ✅ IMPORTANT
      goToHome();

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP"),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  // 🏠 GO TO HOME
  void goToHome() {

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const MainNavigation(),
      ),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 60),

                const Icon(
                  Icons.account_balance,
                  size: 100,
                  color: Colors.green,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Smart Village",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Login with Phone Number",
                  style:
                      TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                // 📱 PHONE
                TextField(
                  controller:
                      phoneController,

                  keyboardType:
                      TextInputType.phone,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Phone Number",

                    hintText:
                        "+91XXXXXXXXXX",

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                    ),

                    prefixIcon:
                        const Icon(
                            Icons.phone),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔐 OTP
                if (otpSent)
                  TextField(
                    controller:
                        otpController,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Enter OTP",

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    12),
                      ),

                      prefixIcon:
                          const Icon(
                              Icons.lock),
                    ),
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed:
                        loading
                            ? null
                            : otpSent
                                ? verifyOTP
                                : sendOTP,

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.green,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    12),
                      ),
                    ),

                    child: loading

                        ? const CircularProgressIndicator(
                            color:
                                Colors
                                    .white,
                          )

                        : Text(
                            otpSent
                                ? "Verify OTP"
                                : "Send OTP",

                            style:
                                const TextStyle(
                              fontSize: 16,
                              color:
                                  Colors
                                      .white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}