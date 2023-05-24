import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/models/user_model.dart';

class FirebaseAuthService {
  MyPref? _box = Get.find<MyPref>();
  MyPref get box => _box!;

  setBox(final MyPref box) {
    _box = box;
  }

  FirebaseAuthService._internal() {
    // save the client so that it can be used else where
    _firebaseAuth = FirebaseAuth.instance;

    try {
      var isLogged = box.pLogin.val;
      debugPrint("isLogged: $isLogged");
      if (isLogged) {
        getFirebaseUserId();
        listenUserChange();
      }
    } catch (e) {
      debugPrint("isLogged: ${e.toString()}");
    }
  }

  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  static FirebaseAuthService get instance => _instance;

  FirebaseAuth? _firebaseAuth;
  FirebaseAuth get firebaseAuth => _firebaseAuth!;

  User? _firebaseUser;
  User get firebaseUser => _firebaseUser!;

  isSignedIn() async {
    if (_firebaseAuth == null) return false;
    return (_firebaseAuth!.currentUser != null);
  }

  dynamic _member;
  dynamic get member => _member;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  listenUserChange() {
    _firebaseAuth!.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
        var isLogged = box.pLogin.val;

        if (isLogged) {
          //reauthenticating
          var mmb = box.pMember.val;
          if (mmb != '') {
            _member = jsonDecode(mmb);
            _userModel = UserModel.fromJson(_member);
            //debugPrint(member);

            reAuthentication(userModel.email!, getPassword()!);
          }
        }
      } else {
        debugPrint('User is signed in!');
        _firebaseUser = user;
      }
    });
  }

  getFirebaseUserId() {
    try {
      _firebaseUser = _firebaseAuth!.currentUser;
      return (_firebaseUser == null) ? null : firebaseUser.uid;
    } catch (e) {
      debugPrint("Error getFirebaseUserId: ${e.toString()}");
    }

    return null;
  }

  firebaseSignInByEmailPwd(String email, String passwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, //"barry.allen@example.com",
        password: passwd, //"SuperSecretPassword!",
      );

      _firebaseUser = userCredential.user;
      savePassword(passwd);

      try {
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
          EasyLoading.dismiss();
          showEmailVerifyDialog();
        }
      } catch (e) {
        debugPrint("isLogged: ${e.toString()}");
      }

      // listen
      listenUserChange();

      //EasyLoading.showSuccess("Login success...");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');

        //await firebaseSignUpByEmailPwd(email, passwd);
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  gotoEmailVerifyScreen(final bool usingPhone) async {
    debugPrint("gotoEmailVerifyScreen is running");
    try {
      debugPrint("User check firebaseUser.uid: ${firebaseUser.uid}");

      if (!firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
      }
    } catch (e) {
      debugPrint("Error gotoEmailVerifyScreen $e");
    }

    EasyLoading.dismiss();
    //Get.offAll(SuccessSignup(usingPhone: usingPhone));
  }

  static showEmailVerifyDialog() {
    CoolAlert.show(
      context: Get.context!,
      backgroundColor: Get.theme.canvasColor,
      type: CoolAlertType.info,
      text:
          "Already sent to your email for verification, click link in your body email to procced registration successfully...",
      title: 'Information',
      onConfirmBtnTap: () {
        Get.back();
      },
      //autoCloseDuration: Duration(seconds: 10),
    );
  }

  savePassword(String? ppaswd) {
    box.pPassword.val = ppaswd!;
  }

  getPassword() {
    return box.pPassword.val;
  }

  final getVerificationId = "".obs;
  loginPhoneUser(String phone) async {
    FirebaseAuth fauth = FirebaseAuth.instance;

    fauth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        debugPrint("[FirebaseAuth] verificationCompleted");
        UserCredential result = await fauth.signInWithCredential(credential);
        User? user = result.user;

        if (user != null) {
          _firebaseUser = user;
        } else {
          debugPrint("[FirebaseAuth] Error user is Null");
        }

        //This callback would gets called when verification is done auto maticlly
      },
      verificationFailed: (FirebaseAuthException exception) {
        debugPrint("[FirebaseAuth] $exception");
      },
      codeSent: (String? verificationId, [int? forceResendingToken]) {
        debugPrint("[FirebaseAuth] showDialog SMS Code");
        getVerificationId.value = verificationId!;

        EasyLoading.showToast('SMS Code OTP send to your phone...');
      },
      codeAutoRetrievalTimeout: (String? text) {
        debugPrint("text: $text");
      },
    );
  }

  doVerifyCode(final String smsCode) async {
    debugPrint("doVerifyCode smsCode: $smsCode");

    FirebaseAuth fauth = FirebaseAuth.instance;
    try {
      String? verificationId = getVerificationId.value;
      //String smsCode = 'xxxx';

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      UserCredential result = await fauth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        debugPrint("[FirebaseAuth] doVerifyCode success uid ${user.uid}");
        _firebaseUser = user;

        Future.microtask(() => listenUserChange());
      } else {
        debugPrint("[FirebaseAuth] doVerifyCode Error user is Null");
      }
    } catch (e) {
      debugPrint("doVerifyCode error: ${e.toString()}");
      EasyLoading.showToast(
          "You have to many login attemps, try a few hours later...");
    }
  }

  firebaseResetPassword(final String? newPassword) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await reAuthentication(currentUser.email!, getPassword());

    currentUser.updatePassword(newPassword!).then((_) async {
      // Password has been updated.
      _firebaseUser = currentUser;
      debugPrint("UpdatePassword success newPassword: $newPassword");

      savePassword(newPassword);
    }).catchError((err) {
      // An error has occured.
      debugPrint("Error: firebaseResetPassword ${err.toString()}");
    });
  }

  firebaseUpdatePassword(final String? newPassword) async {
    //User currentUser = firebaseUser;
    User currentUser = FirebaseAuth.instance.currentUser!;
    await reAuthentication(currentUser.email!, getPassword());

    currentUser.updatePassword(newPassword!).then((_) async {
      // Password has been updated.
      //_firebaseAuth!.currentUser!.updatePassword(newPassword);
      _firebaseUser = currentUser;
      debugPrint("UpdatePassword success");

      savePassword(newPassword);

      Future.delayed(const Duration(seconds: 2), () {
        //reAuthentication(currentUser.email!, newPassword);
      });
    }).catchError((err) {
      // An error has occured.
      debugPrint("Error: updatePassword ${err.toString()}");
    });
  }

  firebaseSignUpByEmailPwd(String email, String passwd) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email, //"barry.allen@example.com",
        password: passwd, //"SuperSecretPassword!",
      );
      _firebaseUser = userCredential.user;

      try {
        savePassword(passwd);
      } catch (e) {
        debugPrint("isLogged: ${e.toString()}");
      }

      try {
        debugPrint("User check firebaseUser.uid: ${firebaseUser.uid}");

        /*Future.microtask(() {
          if (!userCredential.user!.emailVerified) {
            userCredential.user!.sendEmailVerification();
          }
        });*/

        gotoEmailVerifyScreen(false);
      } catch (e) {
        debugPrint("isLogged: ${e.toString()}");
      }

      // listen
      listenUserChange();

      //EasyLoading.showSuccess("Process success...");
    } on FirebaseAuthException catch (e) {
      String datamsg = 'The password provided is too weak.';
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        datamsg = 'The account already exists for that email.';
      }

      EasyLoading.showError('Error FirebaseAuthException: $datamsg');
    } catch (e) {
      debugPrint(e.toString());

      EasyLoading.showError('Error: $e');
    }
  }

  reAuthentication(final String email, final String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // Reauthenticate
      final UserCredential userCredential = await _firebaseAuth!.currentUser!
          .reauthenticateWithCredential(credential);

      _firebaseUser = userCredential.user;

      // listen
      listenUserChange();
    } catch (e) {
      debugPrint("isLogged: ${e.toString()}");
    }
  }

  signOut() async {
    await _firebaseAuth!.signOut();
  }
}
