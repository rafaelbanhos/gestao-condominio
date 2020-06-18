import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:projeto_final/bloc/user_bloc.dart';

import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userBloc = BlocProvider.getBloc<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(8, 86, 151, 1),
          title: Image.asset('assets/image/logoAppBar.png', height: 36, fit: BoxFit.cover),
          actions: <Widget>[
            IconButton(
                icon: new Icon(MdiIcons.logout),
                onPressed: () async {
                  await userBloc.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }),
          ]),
      backgroundColor: Color.fromRGBO(236, 236, 236, 1),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                  0.5,
                  0.9
                ],
                    colors: [
                  Color.fromRGBO(8, 86, 151, 1),
                  Color.fromRGBO(8, 86, 151, 0.8)
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        child: Expanded(
                            child: Image.asset(
                      'assets/image/logo1.png',
                      fit: BoxFit.cover,
                    )))
//                    CircleAvatar(
//                      minRadius: 60,
//                      backgroundColor: Colors.white,
//                      child: CircleAvatar(
//                        //chamar img
//                        minRadius: 50,
//                      ),
//                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
//                Text(
//                  "Smart Report",
//                  style: TextStyle(fontSize: 22.0, color: Colors.white),
//                ),
                Text(
                  "Projeto Final - ADS 052",
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Email",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              userBloc.firebaseUser.email,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Celular",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "85 4042-1220",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Apartamento",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "Auditório / FAC",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Condomínio",
              style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
            ),
            subtitle: Text(
              "Faculdade Cearense (FAC)",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
