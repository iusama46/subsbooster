import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static var token;
  final _googleSignIn = GoogleSignIn();

  // Future<UserCredential> signInWithGoogle() async {
  //
  //
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //
  //   // Create a new credential
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   print('token ' + credential.accessToken);
  //   //print('token1 '+credential.idToken);
  //   //print('token2 '+credential.token.toString());
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
    print('SignOut');
    //await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/youtube', // Youtube scope
      ],
    );
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // You'll need this token to call the Youtube API. It expires every 30 minutes.
    //final token = googleSignInAuthentication.accessToken;
    token = googleSignInAuthentication.accessToken;
    print('token: ' + token);

    return await _auth.signInWithCredential(credential);
  }
}
