import 'dart:convert';
import 'package:animate_do/animate_do.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/pg1.dart';




class usersign extends StatefulWidget {
  const usersign({super.key});

  @override
  State<usersign> createState() => _usersignState();
}
class _usersignState extends State<usersign> {
  final GoogleSignIn  googleSignIn = GoogleSignIn(
      clientId:
      "823876101682-o1eko634bih4v0djdmafpft0o64a4g2h.apps.googleusercontent.com" );


  signInWithGoogle(BuildContextcontext) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      // Sign the user out before every login attempt
      await GoogleSignIn().signOut();
      await _auth.signOut();

      UserCredential userCredential;
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
        final user = userCredential.user;
        print(user);
      } else {
        print("Initiating Google Sign-In...");
        GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
        final user = userCredential.user;
        print(user);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PokedexScreen()));


      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white),onPressed: ()   {
                signInWithGoogle(context);
              }, child: Text("Sign In with Google")
              ),
            ),//,
          ],
        ),
      ),
    );
  }
}