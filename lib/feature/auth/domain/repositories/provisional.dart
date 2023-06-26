import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_play/feature/auth/presentation/screens/token_print.dart';

class AuthService {
  //sign in
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }

  signOut() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
   
  }

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return TokenPrint();
        } else {
          return TokenPrint();
        }
      },
    );
  }

  getCredential() {
    return FirebaseAuth.instance.currentUser!.getIdToken() ?? "no token";
  }
}
