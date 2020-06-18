import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:card_settings/card_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:projeto_final/models/avisos_model.dart';
import 'package:projeto_final/screens/new_meeting_screen.dart';

import 'login.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var userBloc = BlocProvider.getBloc<UserBloc>();
  var promotionBloc = BlocProvider.getBloc<ReportBloc>();

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
      floatingActionButton: StreamBuilder<bool>(
        stream: userBloc.outEhSindicoLogado,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return snapshot.data
              ? FloatingActionButton(
                  heroTag: 'ftabMeeting',
                  backgroundColor: Color.fromRGBO(8, 86, 151, 1),
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewMeetingScreen()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  elevation: 5,
                  highlightElevation: 10,
                )
              : Container();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("avisos")
                    .where("tipo", isEqualTo: 0)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: Text("Carregando."),
                      ),
                    );
                  }

                  if (snapshot.data.documents.length == 0) {
                    return Container(
                      child: Center(
                        child: Text("Nenhum registro encontrado."),
                      ),
                    );
                  }

                  return ListView.builder(
                      itemBuilder: (context, index) {
                        AvisoModel model = AvisoModel.fromDocument(
                            snapshot.data.documents[index]);

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            StreamBuilder<bool>(
                                stream: userBloc.outEhSindicoLogado,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  return snapshot.data
                                      ? IconSlideAction(
                                          caption: 'Delete',
                                          color: Colors.red,
                                          icon: Icons.delete,
                                          onTap: () {
                                            promotionBloc
                                                .deletarAviso(model.id);
                                          },
                                        )
                                      : Container();
                                }),
                          ],
                          child: Container(
                            padding: EdgeInsets.zero,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(model.titulo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    subtitle: Text(model.descricao,
                                        style: TextStyle(fontSize: 12)),
                                    trailing: Container(
                                      width: 75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            formatDate(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        model.data
                                                            .millisecondsSinceEpoch),
                                                [dd, '-', mm, '-', yyyy]),
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: ExpansionTile(
                                        trailing: Icon(Icons.remove_red_eye),
                                        title: Text("Detalhes",
                                            style: TextStyle(
                                                color: Colors.black54)),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  ["observacao"],
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.justify,
                                            ),
                                          )
                                        ],
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.documents.length);
                })),
      ),
    );
  }
}
