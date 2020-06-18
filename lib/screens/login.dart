import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_final/bloc/progress_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'main_screen.dart';

class Login extends StatefulWidget {
  static final String path = "lib/src/pages/login/login3.dart";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var userBloc = BlocProvider.getBloc<UserBloc>();
  var progressBloc = BlocProvider.getBloc<ProgressBloc>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 650,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.blue, Colors.blueGrey.shade200],
                    [Color.fromRGBO(8, 86, 151, 1), Colors.blueGrey.shade200],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Container(
                height: 400,
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/image/logo1.png",
                          width: 220, height: 100),
                      Card(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                        color: Colors.transparent,
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: FormBuilderTextField(
                          autofocus: true,
                          attribute: "email",
                          validators: [
                            (val) {
                              if (val == null || val.isEmpty) {
                                return "O email deve ser informado.";
                              }

                              if (!val.toString().contains('@')) {
                                return "O email deve ser valido.";
                              }
                            }
                          ],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black26,
                              ),
                              suffixIcon: Icon(
                                Icons.check_circle,
                                color: Colors.black26,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.black26),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                        elevation: 11,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: FormBuilderTextField(
                          attribute: "senha",
                          obscureText: true,
                          validators: [
                            (val) {
                              if (val == null || val.isEmpty) {
                                return "A senha deve ser informada.";
                              }
                            }
                          ],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black26,
                              ),
                              hintText: "Senha",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(30.0),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          color: Colors.pink,
                          onPressed: () async {
                            if (_fbKey.currentState.validate()) {
                              _fbKey.currentState.save();

                              FirebaseUser user =
                                  await userBloc.ensureLoggedInWithGoogle(
                                      _fbKey.currentState.value['email'],
                                      _fbKey.currentState.value['senha'],
                                      context);

                              if (user != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()));
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Acesso inválido",
                                  desc: "Login ou senha inválidos.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            }
                          },
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: Text("Login",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
