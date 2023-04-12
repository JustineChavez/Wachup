import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_wachup/global/language.dart';
import 'package:flutter_wachup/main.dart';
import 'package:flutter_wachup/pages/auth/recover_page.dart';
import 'package:flutter_wachup/pages/auth/register_page.dart';
import 'package:flutter_wachup/service/auth_service.dart';
import 'package:flutter_wachup/service/database_service.dart';
import 'package:flutter_wachup/shared/constants.dart';
import 'package:flutter_wachup/widgets/widgets.dart';
import 'package:flutter_wachup/shared/constants_v2.dart';

import '../../helper/helper_function.dart';
import '../../shared/localization.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String userName = "";
  String password = "";
  bool isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    //timeDilation = 0.5;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      LocaleText("title",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 55,
                            color: Constants().customForeColor,
                          )),
                      const SizedBox(height: 5),
                      LocaleText("subtitle",
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Constants().customForeColor)),
                      const SizedBox(height: 50),
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          "assets/WachupLogoResized.png",
                          width: 200,
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: Locales.string(context, "email"),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            userName = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : Locales.string(context, "email_validate");
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: Locales.string(context, "password"),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return Locales.string(context, "password_validate");
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().customColor3,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            Locales.string(context, "sign_in"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            login();
                            //loginOffline();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: Locales.string(context, "no_account"),
                        style: TextStyle(
                            color: Constants().customForeColor, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: Locales.string(context, "reg_account"),
                              style: TextStyle(
                                  color: Constants().customForeColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                }),
                        ],
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: Locales.string(context, "forgot_pass"),
                        style: TextStyle(
                            color: Constants().customForeColor, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: Locales.string(context, "rec_account"),
                              style: TextStyle(
                                  color: Constants().customForeColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RecoverPage());
                                }),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: buildFloatLocalization(context),
    );
  }

  FloatingActionButton buildFloatLocalization(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.language_outlined),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LanguagePage()),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .loginUserWithEmailandPassword(userName, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(userName);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(userName);
          await HelperFunctions.saveUserFullNameSF(
              snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserAccountTypeSF(
              snapshot.docs[0]['accountType']);
          await HelperFunctions.saveUserLanguageSF(
              snapshot.docs[0]['userLanguage']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  loginOffline() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      nextScreenReplace(context, const HomePage());
      isLoading = false;
    }
  }
}
