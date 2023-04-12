import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';

class Language {
  Future<bool?> isEnglish() async {
    await HelperFunctions.getUserLanguageSF().then((value) {
      if (value != null) {
        if (value == "English") {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    });
  }

  // bool? isEnglish() {
  //   HelperFunctions.getUserIsEnglish().then((value) {
  //     if (value != null) {
  //       //return value;
  //       return true;
  //     } else {
  //       return true;
  //     }
  //   });
  // }
}
