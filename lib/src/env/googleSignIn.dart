import 'package:firebase_auth/firebase_auth.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:money_hooks/firebase_options.dart';

Future<UserCredential> signInWithGoogle() async {
  // // Trigger the authentication flow
  // final GoogleSignInAccount? googleUser = await GoogleSignIn(
  //     clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
  //     .signIn();
  //
  // // Obtain the auth details from the request
  // final GoogleSignInAuthentication? googleAuth =
  //     await googleUser?.authentication;
  //
  // // Create a new credential
  // final credential = GoogleAuthProvider.credential(
  //   accessToken: googleAuth?.accessToken,
  //   idToken: googleAuth?.idToken,
  // );
  //
  // // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(credential);

  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);
}
