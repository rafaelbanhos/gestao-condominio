import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/bloc/report_bloc.dart';
import 'package:projeto_final/models/avisos_model.dart';

class NewMeetingScreen extends StatefulWidget {
  @override
  _NewMeetingScreenState createState() => _NewMeetingScreenState();
}

class _NewMeetingScreenState extends State<NewMeetingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var promotionBloc = BlocProvider.getBloc<ReportBloc>();
  AvisoModel model;

  @override
  void initState() {
    model = AvisoModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(8, 86, 151, 1),
        elevation: 0,
        title: Text('Nova Ata', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: CardSettings(
          children: <Widget>[
            CardSettingsHeader(
              label: 'Cadastrar Ata',
              color: Color.fromRGBO(8, 86, 151, 1),
            ),
            CardSettingsText(
              label: 'Descrição:',
              maxLength: 100,
              requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Descrição deve ser informada.';
              },
              onSaved: (value) => model.titulo = value.toUpperCase(),
            ),
            CardSettingsText(
              maxLength: 100,
              requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
              label: 'Assembleia:',
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Assembleia deve ser informada.';
              },
              onSaved: (value) => model.descricao = value.toUpperCase(),
            ),
            CardSettingsParagraph(
              maxLength: 500,
              requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
              label: 'Pautas:',
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Pautas deve ser informado.';
              },
              onSaved: (value) => model.observacao = value.toUpperCase(),
            ),
            CardSettingsButton(
              label: 'Enviar',
              backgroundColor: Color.fromRGBO(8, 86, 151, 1),
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  promotionBloc.adicionarNovoAviso(
                      model, TipoDeAviso.ATA, context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
