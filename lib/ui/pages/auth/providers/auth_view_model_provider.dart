import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authViewModelProvider =
    ChangeNotifierProvider.autoDispose<AuthViewModel>((ref) => AuthViewModel());

class AuthViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String? _verificationId;
  bool loading = false;
  bool phoneLoading = false;
  bool otpSent = false;

  void sendOTP({required String phoneNumber}) async {
    phoneLoading = true;
    notifyListeners();
    try {
      var admins = await FirebaseFirestore.instance
          .collection("milkMans")
          .where("mobile", isEqualTo: phoneNumber)
          .get();
      if (admins.docs.isEmpty) {
        // Fluttertoast.showToast(
        //     msg: "Phone number not registered as milk man.",
        //     backgroundColor: Colors.white,
        //     textColor: Color(0xFFFD367E));
        phoneLoading = false;
        notifyListeners();
        return;
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          otpSent = false;
          notifyListeners();
          user = (await _auth.signInWithCredential(credential)).user;
          // Fluttertoast.showToast(
          //     msg: "Sign In Successful",
          //     backgroundColor: Color(0xFFFD367E),
          //     textColor: Colors.white);
          loading = false;
          otpSent = false;
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          loading = false;
          phoneLoading = false;
          notifyListeners();
          if (e.code == 'invalid-phone-number') {
            // Fluttertoast.showToast(
            //     msg: "The provided phone number is not valid.",
            //     backgroundColor: Colors.white,
            //     textColor: Color(0xFFFD367E));
          }
          //  else
          //   Fluttertoast.showToast(
          //       msg: e.code,
          //       backgroundColor: Colors.white,
          //       textColor: Color(0xFFFD367E));
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Fluttertoast.showToast(
          //     msg: "OTP sent",
          //     backgroundColor: Colors.white,
          //     textColor: Color(0xFFFD367E));
          otpSent = true;
          phoneLoading = false;
          _verificationId = verificationId;
          notifyListeners();
        },
        timeout: const Duration(seconds: 10),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      phoneLoading = false;
      notifyListeners();
    }
  }

  Future<User?> verifyOtp({required String otp}) async {
    loading = true;
    otpSent = false;
    notifyListeners();
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      // Fluttertoast.showToast(
      //     msg: "Login Successful",
      //     backgroundColor: Color(0xFFFD367E),
      //     textColor: Colors.white);
    } on FirebaseException catch (e) {
      // Fluttertoast.showToast(
      //     msg: "Failed to Login: " + e.code.toString(),
      //     backgroundColor: Colors.white,
      //     textColor: Color(0xFFFD367E));
      loading = false;
      otpSent = true;
      notifyListeners();
      return null;
    }
    loading = false;
    otpSent = false;
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
    // Fluttertoast.showToast(
    //   msg: "Logout Successful",
    //   backgroundColor: Color(0xFFFD367E),
    //   textColor: Colors.white,
    // );
  }
}
