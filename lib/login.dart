import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class LoginPage extends StatelessWidget {
  // Google 認証
  final _google_signin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  GoogleSignInAccount googleUser;
  GoogleSignInAuthentication googleAuth;
  AuthCredential credential;

  // Firebase 認証
  final _auth = FirebaseAuth.instance;
  UserCredential result;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child:ElevatedButton.icon(
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: const Text('googleログイン'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    // Google認証の部分
                    googleUser = await _google_signin.signIn();
                    googleAuth = await googleUser.authentication;

                    credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    // Google認証を通過した後、Firebase側にログイン　※emailが存在しなければ登録
                    try {
                      result = await _auth.signInWithCredential(credential);
                      user = result.user;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }),
                      );
                    } catch (e) {
                      print(e);
                    }
                  }),
            ),
            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: const Text('Googleログアウト'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    _auth.signOut();
                    _google_signin.signOut();
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
