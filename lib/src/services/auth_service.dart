import 'dart:async';
import 'dart:math';

import 'package:book_my_doctor/src/model/user_details.dart';
import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:book_my_doctor/src/utils/activity_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  /*
    * Sign In Methods :-
    *      1) Google Sign In
    *      2) Email ID and Password [Requires updates]
    *
    *
    * Auth State Change to be monitored. => Streams
    * */

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();

  FacebookLogin facebookLogin = FacebookLogin();

  Future<Map<String, dynamic>> createUserWithEmailIDAndPassword(
      GlobalKey<ScaffoldState> globalKey, UserDetails userDetail,
      {@required String password}) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userDetail.email, password: password);
      print("Auth result User: " + authResult.user.email);
      if (authResult != null) {
        authResult.user.sendEmailVerification();
        userDetail.uid = authResult.user.uid;
        var map = await getRegisteredUser(userDetail);
        return map;
      } else {
        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(SnackBar(
          content: Text('Something went wrong. Try again later'),
        ));
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return await checkAuthError(globalKey, e);
    }
  }

  Future<Map<String, dynamic>> signInWithEmailIDAndPassword(
      GlobalKey<ScaffoldState> globalKey,
      {@required String email,
      @required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Result User Email : ${result.user.toString()}");
      if (result != null) {
        if (result.user.emailVerified) {
          UserDetails userDetails =
              await FbCloudServices().getUserById(result.user.uid);
          return userDetails.toJson();
        } else {
          ActivityUtils().showSnackBarMessage(globalKey.currentContext,
              "Please verify email address by clicking link sent on your registered email.");
          return null;
        }
      } else {
        ActivityUtils().showSnackBarMessage(globalKey.currentContext,
            "Something went wrong, please try again later.");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return await checkAuthError(globalKey, e);
    }
  }

  Future<UserCredential> _getGoogleUserCredentials() async {
    GoogleSignInAccount account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  Future<Map> signInWithGoogle(
      GlobalKey<ScaffoldState> globalKey, String baseUrl) async {
    try {
      UserCredential authResult = await _getGoogleUserCredentials();

      print("Auth result User: " + authResult.user.email);

      if (authResult != null) {
        UserDetails userDetails = getUserDetails(authResult.user);
        var map = await getRegisteredUser(userDetails);
        // _streamController.add(authResult.user);
        return map;
      } else {
        ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(SnackBar(
          content: Text('Something went wrong. Try again later'),
        ));
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential> _getFacebookUserCredentials() async {
    FacebookLoginResult loginResult = await facebookLogin.logIn(['email']);
    print("Facebook login status : ${loginResult.status}");
    print("Facebook login error message : ${loginResult.errorMessage}");
    if (loginResult.status == FacebookLoginStatus.loggedIn) {
      print("Facebook login token : ${loginResult.accessToken.toMap()}");
      final accessToken = loginResult.accessToken.token;
      AuthCredential credential = FacebookAuthProvider.credential(accessToken);
      print("Facebook login credential : ${credential.asMap()}");
      UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      print("Facebook Login authResult : ${authResult.toString()}");
      return authResult;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> signInWithFacebook(
      GlobalKey<ScaffoldState> globalKey) async {
    try {
      UserCredential authResult = await _getFacebookUserCredentials();
      print("Facebook Login : ${authResult.toString()}");
      if (authResult != null) {
        UserDetails userDetails = getUserDetails(authResult.user);
        var map = await getRegisteredUser(userDetails);
        // _streamController.add(authResult.user);
        return map;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return await checkAuthError(globalKey, e);
    }
  }

  // final _streamController = StreamController<User>();

  // Stream<User> get onAuthStateChange {

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
    // return _streamController.stream;
  }

  //   return _streamController.stream;
  // }

  User currentUser() {
    var user = _firebaseAuth.currentUser;
    // if (user != null) {
    //   _streamController.add(user);
    // }
    return user;
  }

  Future<void> signOutFromFirebase() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        user.providerData.forEach((element) {
          if (element.providerId == 'google.com') {
            googleSignIn.signOut().then((value) => print('google signed out'));
          } else if (element.providerId == 'facebook.com') {
            print('facebook.com sign in');
            facebookLogin
                .logOut()
                .then((value) => print('facebook signed out'));
          }
        });
      }
      // _streamController.add(null);
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getUserID() async {
    User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  String passwordGenerator() {
    String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
    String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String _numbers = "0123456789";
    String _special = "@#=!£\$%&?[](){}";

    //Create the empty string that will contain the allowed chars
    String _allowedChars = "";

    //Put chars on the allowed ones based on the input values
    _allowedChars += _lowerCaseLetters;
    _allowedChars += _upperCaseLetters;
    _allowedChars += _numbers;
    _allowedChars += _special;

    int i = 0;
    String _result = "";

    //Create password
    while (i < 12) {
      //Get random int
      int randomInt = Random.secure().nextInt(_allowedChars.length);
      //Get random char and append it to the password
      _result += _allowedChars[randomInt];
      i++;
    }
    return _result;
  }

  Future<Map<String, dynamic>> getRegisteredUser(UserDetails user) async {
    UserDetails userDetails = await FbCloudServices().getUserById(user.uid);
    if (userDetails != null) {
      return userDetails.toJson();
    } else {
      await FbCloudServices().addUser(user);
      return user.toJson();
    }
  }

  UserDetails getUserDetails(User user) {
    String name = user.displayName;
    String email = user.email;

    List names =
        (name != null && name.isNotEmpty) ? name.split(' ') : email.split('@');
    UserDetails userDetails = UserDetails(
      uid: user.uid,
      email: user.email,
      firstName: (names != null && names.isNotEmpty) ? names.first : "",
      lastName: (name != null && name.isNotEmpty) ? names?.last ?? "" : "",
    );
    return userDetails;
  }

  Future<Map<String, dynamic>> checkAuthError(
      GlobalKey<ScaffoldState> globalKey, FirebaseAuthException e) async {
    if (e.code == 'account-exists-with-different-credential') {
      // The account already exists with a different credential
      String email = e.email;
      AuthCredential pendingCredential = e.credential;

      // Fetch a list of what sign-in methods exist for the conflicting user
      List<String> userSignInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userSignInMethods.first == 'password') {
        bool isLink = await _linkAccountDialog(globalKey, "Direct ");
      } else if (userSignInMethods.first == 'google.com') {
        bool isLink = await _linkAccountDialog(globalKey, "Google");

        print("Can Login and link : $isLink");
        if (isLink) {
          // Create a new Google credential
          UserCredential userCredential = await _getGoogleUserCredentials();

          // Link the pending credential with the existing account
          UserCredential userCredentialNew =
              await userCredential.user.linkWithCredential(pendingCredential);

          // Success! Go back to your application flow
          if (userCredentialNew != null) {
            UserDetails userDetails = getUserDetails(userCredentialNew.user);
            var map = await getRegisteredUser(userDetails);
            // _streamController.add(authResult.user);
            return map;
          }
        }
      } else if (userSignInMethods.first == 'facebook.com') {
        bool isLink = await _linkAccountDialog(globalKey, "Facebook");

        print("Can Login and link : $isLink");
        if (isLink) {
          // Create a new Facebook credential
          UserCredential userCredential = await _getFacebookUserCredentials();

          // Link the pending credential with the existing account
          UserCredential userCredentialNew =
              await userCredential.user.linkWithCredential(pendingCredential);

          // Success! Go back to your application flow
          if (userCredentialNew != null) {
            UserDetails userDetails = getUserDetails(userCredentialNew.user);
            var map = await getRegisteredUser(userDetails);
            // _streamController.add(authResult.user);
            return map;
          }
        }
      }
    } else {
      ScaffoldMessenger.of(globalKey.currentContext).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
    return null;
  }

  Future<bool> _linkAccountDialog(
      GlobalKey<ScaffoldState> globalKey, String provider) async {
    return await showDialog(
      context: globalKey.currentContext,
      builder: (context) => AlertDialog(
        title: Text('Account already exist with email'),
        content: Text(
            "An account already exists with same email from $provider, would you like to login & link with $provider?"),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );
  }
}
