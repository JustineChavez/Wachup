import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_wachup/pages/auth/login_page.dart';
import 'package:flutter_wachup/pages/home_page.dart';
import 'package:flutter_wachup/service/auth_service.dart';
import 'package:flutter_wachup/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../global/language.dart';
import '../shared/constants.dart';
import '../shared/constants_v2.dart';
import '../shared/drawer.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  String accountType;
  ProfilePage(
      {Key? key,
      required this.email,
      required this.userName,
      required this.accountType})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  FinalConstants con = FinalConstants(isEnglish: Language().isEnglish());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context),
      drawer: CustomDrawer(
        currentPage: 3, //Profile Page,
        currentUserName: widget.userName,
        currentEmail: widget.email,
        currentAccountType: widget.accountType,
      ),
      body: buildContainer(context),
    );
  }

  SingleChildScrollView buildContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  //height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Constants().customBackColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Locales.string(context, "profile_title"),
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: Constants().kDefaultPadding,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: Constants().kDefaultPadding + 130,
                          ),
                          Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Constants().customForeColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 200,
                                color: Constants().customBackColor,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Locales.string(context, "name_text"),
                              style: const TextStyle(fontSize: 17)),
                          Text(widget.userName,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                      const Divider(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Locales.string(context, "email_text"),
                              style: const TextStyle(fontSize: 17)),
                          Text(widget.email,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
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
                            Locales.string(context, "prof_v_introduction"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            //login();
                            //loginOffline();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
    );
  }
}
