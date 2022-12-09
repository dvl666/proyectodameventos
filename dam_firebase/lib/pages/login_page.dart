import 'dart:collection';
import 'dart:ffi';
import 'package:dam_firebase/pages/admin/eventos_admin_page.dart';
import 'package:dam_firebase/providers/usuarios_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dam_firebase/pages/cliente/eventos_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/schemes/auth_token.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String error = '';
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 1),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink, Colors.purple])),
            child: Image.asset(
              'assets/images/e.png',
              height: 200,
              color: Colors.white,
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.only(left: 20, right: 20, top: 220),
              color: Color.fromARGB(255, 241, 230, 201),
              child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                              label: Text(
                                'Corre electrónico',
                                style: GoogleFonts.ubuntu(),
                              ),
                              prefixIcon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          controller: passwordCtrl,
                          decoration: InputDecoration(
                              label: Text(
                                'Contraseña',
                                style: GoogleFonts.ubuntu(),
                              ),
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                          obscureText: _obscureText,
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 176, 24, 24)),
                            child: Text(
                              'INICIAR SESIÓN',
                              style: GoogleFonts.ubuntu(),
                            ),
                            onPressed: () => login(),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 219, 248)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MdiIcons.twitter),
                                Text(
                                  ' TWITTER',
                                  style: GoogleFonts.ubuntu(),
                                ),
                              ],
                            ),
                            onPressed: () => loginV2(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 760),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Power by ',
                  style: GoogleFonts.ubuntu(fontSize: 25),
                ),
                Image.asset('assets/images/Logo_UTFSM.png')
              ],
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    if (emailCtrl.text.isEmpty) {
      error = 'Ingrese un Email';
      setState(() {});
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('user', userCredential.user!.email.toString());
        String email = emailCtrl.text.trim();

        var respuesta = await UsuariosProvider().getUsuario(email);
        if (respuesta['usuario'] == null) {
          var respuesta = await UsuariosProvider().agregar(email, 2);
        } else {}
        print("la respuesta es " + respuesta.toString());

        if (respuesta['tipo'] == "1") {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => eventosadminPage(),
          );
          Navigator.pushReplacement(context, route);
        } else {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => eventosadminPage(),
          );
          Navigator.pushReplacement(context, route);
        }
        print("la respuesta es " + respuesta.toString());
      } on FirebaseAuthException catch (ex) {
        switch (ex.code) {
          case 'user-not-found':
            error = 'Usuario no existe';
            break;
          case 'wrong-password':
            error = 'Contraseña incorrecta';
            break;
          case 'user-disabled':
            error = 'Cuenta desactivada';
            break;
          case 'invalid-email':
            error = 'Ingrese un Email valido';
            break;
          default:
            error = 'Email no puede ser null 666';
            break;
        }

        setState(() {});
        String email = emailCtrl.text.trim();
        int tipo = 2;
        var respuesta = await UsuariosProvider().getUsuario(email);
      }
    }
  }

  Future loginV2() async {
    try {
      String? usuario = '';
      final twitterLogin = TwitterLogin(
        apiKey: 'TQXofJb9bwwQAemFBmgTbAivr',
        apiSecretKey: 'xu13VbkW92DSLm8MCAcxsIIwwSzOia9Hr3ryxIPEcTxTbERorT',
        redirectURI: 'gaspao666://',
      );
      if (twitterLogin != null) {}
      await twitterLogin.loginV2().then(((value) async {
        final AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: value.authToken!,
          secret: value.authTokenSecret!,
        );
        usuario = value.user?.name.toString();
        await FirebaseAuth.instance.signInWithCredential(credential);
        var respuesta = await UsuariosProvider().getUsuario(usuario.toString());
        if (respuesta['usuario'] == null) {
          var respuesta =
              await UsuariosProvider().agregar(usuario.toString(), 2);
        } else {
          print("666");
        }
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => eventosPage(usuario.toString()),
        );
        Navigator.pushReplacement(context, route);
        print('el usuario logeado es ' + usuario.toString());
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('user', usuario.toString());
      }));
    } on AuthResult catch (ex) {
      switch (ex.errorMessage) {
        case 'Null check operator used on a null value':
          error = 'Usuario cancelo el login con twitter';
          break;
        case '_CastError':
          error = 'Ingrese un Email valido';
          break;
      }
    }
  }
}
