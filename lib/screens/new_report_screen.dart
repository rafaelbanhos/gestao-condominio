import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:card_settings/card_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_final/models/denuncia_model.dart';
import 'package:projeto_final/screens/main_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewReportScreen extends StatefulWidget {
  File image;

  NewReportScreen(this.image);

  @override
  _NewReportScreenState createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var promotionBloc = BlocProvider.getBloc<ReportBloc>();
  DenunciaModel promo = DenunciaModel();

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54)));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(8, 86, 151, 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nova denúncia', style: TextStyle(color: Color.fromRGBO(8, 86, 151, 1))),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: CardSettings(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.file(widget.image, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 0,
                          child: FlatButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            color: Colors.black,
                            icon: Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                            label: Text("Excluir",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<String>>(
                      future: promotionBloc.selectCategories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Center(
                              child: Text("Carregando."),
                            ),
                          );
                        }

                        return CardSettingsListPicker(
                          label: 'Tipo',
                          requiredIndicator:
                              Text('*', style: TextStyle(color: Colors.red)),
                          hintText: 'Selecione o tipo',
                          options: snapshot.data,
                          initialValue: promo.tipo,
                          validator: (String value) {
                            if (value == null || value.isEmpty)
                              return 'O tipo deve ser informado.';
                            return null;
                          },
                          onSaved: (value) => promo.tipo = value,
                          onChanged: (value) {
                            setState(() {
                              promo.tipo = value;
                            });
                          },
                        );
                      }),
                  CardSettingsParagraph(
                    label: 'Observação',
                    maxLength: 500,
                    onSaved: (value) => promo.observacao = value.toUpperCase(),
                    requiredIndicator:
                        Text('*', style: TextStyle(color: Colors.red)),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Uma observação deve ser informada.';
                    },
                  ),
                  CardSettingsButton(
                    label: 'Salvar',
                    textColor: Colors.white,
                    backgroundColor: Color.fromRGBO(8, 86, 151, 1),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        bool sucess = await promotionBloc.saveProduct(
                            promo, widget.image, context);

                        if (sucess) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MainScreen()));

                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Sucesso!",
                            desc: "Sua denúncia foi enviada!",
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
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<bool>(
              stream: promotionBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              })
        ],
      ),
    );
  }
}
