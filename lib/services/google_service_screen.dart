import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

String? name;

Future<User?> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication!.accessToken,
      idToken: googleSignInAuthentication.idToken);

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  User? user = userCredential.user;

  name = user!.email;

  if (user != null) {
    return user;
  } else {
    return null;
  }
}

Future signOut() async {
  await googleSignIn.signOut();
  print("logout");
}
