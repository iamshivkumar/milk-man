import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/auth_view_model_provider.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var authModel = useProvider(authViewModelProvider);
    final phoneController = useTextEditingController();
    final otpController = useTextEditingController();
    final theme = Theme.of(context);
    final style = theme.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Theme(
        data: ThemeData.dark().copyWith(
          accentColor: Colors.white,
          primaryColor: Colors.white,
          indicatorColor: Colors.white,
          textTheme: style,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            labelStyle: style.bodyText1!.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Milk Man Login",
                  style: style.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: phoneController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone Number", prefixText: "+91 "),
                      ),
                    ),
                    authModel.phoneLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : OutlinedButton(
                            style: Theme.of(context).textButtonTheme.style,
                            onPressed: () {
                              authModel.sendOTP(
                                phoneNumber: phoneController.text,
                              );
                            },
                            child: Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  enabled: authModel.otpSent,
                  autofocus: true,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "OTP",
                  ),
                ),
              ),
              authModel.loading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Center(
                      child: MaterialButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: authModel.otpSent
                            ? () {
                                authModel.verifyOtp(otp: otpController.text);
                              }
                            : null,
                        child: Text(
                          "VERIFY",
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
