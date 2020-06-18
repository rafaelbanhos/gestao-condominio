import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:projeto_final/models/denuncia_model.dart';
import 'package:projeto_final/screens/image_details_screen.dart';
import 'package:projeto_final/screens/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var userBloc = BlocProvider.getBloc<UserBloc>();
  var reportBloc = BlocProvider.getBloc<ReportBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(8, 86, 151, 1),
          title: Image.asset('assets/image/logoAppBar.png',
              height: 36, fit: BoxFit.cover),
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
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: userBloc.verificarSeEhSindico(),
          builder: (a, b) {
            if (!b.hasData) {
              return Container(
                child: Center(
                  child: Text("Carregando."),
                ),
              );
            }
            return Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: b.data
                        ? reportBloc.selecionarDenunciasParaSindico()
                        : reportBloc.selecionarMinhasDenuncias(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(
                              child: Text("Carregando."),
                            ),
                          );
                        default:
                          if (snapshot.data.documents.length == 0) {
                            return Container(
                              child: Center(
                                child: Text("Nenhum registro encontrado."),
                              ),
                            );
                          }
                      }
                      return ListView.builder(
                          itemBuilder: (context, index) {
                            DenunciaModel model = DenunciaModel.fromDocument(
                                snapshot.data.documents[index]);

                            return Container(
                              padding: EdgeInsets.zero,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: reportBloc
                                                    .retornarCorBaseadoNoStatusDoProcesso(
                                                        model.status),
                                                width: 5))),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: GestureDetector(
                                            onTap: () {
                                              Alert(
                                                context: context,
                                                type: AlertType.none,
                                                title: model.tipo,
                                                desc: "",
                                                content: Container(
                                                  child: Image.network(
                                                      model.images[0]),
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      "Ampliar",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImageDetailsScreen(
                                                                      model.images[
                                                                          0])));
                                                    },
                                                    width: 120,
                                                  )
                                                ],
                                              ).show();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image(
                                                  image: AdvancedNetworkImage(
                                                    model.images[0],
                                                    useDiskCache: true,
                                                    cacheRule: CacheRule(
                                                        maxAge: const Duration(
                                                            days: 7)),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(model.tipo,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
//                                      subtitle: Text(model.tipo,
//                                          style: TextStyle(fontSize: 12)),
                                          trailing: Container(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    reportBloc.statusDoProcesso(
                                                        model.status),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  formatDate(model.dataCriacao,
                                                      [dd, '-', mm, '-', yyyy]),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                              stream:
                                                  userBloc.outEhSindicoLogado,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                return snapshot.data &&
                                                        model.status >= 1 &&
                                                        model.status < 2
                                                    ? Expanded(
                                                        child: FlatButton(
                                                        color: Colors.white,
                                                        child: Text("Aprovar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green)),
                                                        onPressed: () {
                                                          reportBloc
                                                              .atualizarStatusDaDenuncia(
                                                                  model,
                                                                  StatusDaDenuncia
                                                                      .APROVADO,
                                                                  context);
                                                        },
                                                      ))
                                                    : Container();
                                              },
                                            ),
                                            StreamBuilder<bool>(
                                              stream:
                                                  userBloc.outEhSindicoLogado,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                return snapshot.data &&
                                                        model.status == 0
                                                    ? Expanded(
                                                        child: FlatButton(
                                                        color: Colors.white,
                                                        child: Text("Analisar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green)),
                                                        onPressed: () {
                                                          reportBloc
                                                              .atualizarStatusDaDenuncia(
                                                                  model,
                                                                  StatusDaDenuncia
                                                                      .ANALISAR,
                                                                  context);
                                                        },
                                                      ))
                                                    : Container();
                                              },
                                            ),
                                            StreamBuilder<bool>(
                                              stream:
                                                  userBloc.outEhSindicoLogado,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                return snapshot.data &&
                                                        model.status >= 1 &&
                                                        model.status < 2
                                                    ? Expanded(
                                                        child: FlatButton(
                                                        color: Colors.white,
                                                        child: Text("Rejeitar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent)),
                                                        onPressed: () {
                                                          reportBloc
                                                              .atualizarStatusDaDenuncia(
                                                                  model,
                                                                  StatusDaDenuncia
                                                                      .REJEITADO,
                                                                  context);
                                                        },
                                                      ))
                                                    : Container();
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: ExpansionTile(
                                              title: Text("Detalhes",
                                                  style: TextStyle(
                                                      color: Colors.black54)),
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    model.observacao,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.justify,
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
                              ),
                            );
                          },
                          itemCount: snapshot.data.documents.length);
                    }));
          },
        ),
      ),
    );
  }
}
