import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:projeto_final/bloc/progress_bloc.dart';
import 'package:projeto_final/bloc/user_bloc.dart';
import 'package:projeto_final/models/avisos_model.dart';
import 'package:projeto_final/models/denuncia_model.dart';
import 'package:rxdart/rxdart.dart';

enum StatusDaDenuncia { APROVADO, REJEITADO, ANALISAR }
enum TipoDeAviso { ATA, REUNIAO }

class ReportBloc extends BlocBase {
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outLoading => _loadingController.stream;

  final _firebaseInstance = Firestore.instance;

  var userBloc = BlocProvider.getBloc<UserBloc>();
  var progressBloc = BlocProvider.getBloc<ProgressBloc>();

  Stream<QuerySnapshot> selecionarDenunciasParaSindico() {
    return _firebaseInstance
        .collection("denuncias")
        .orderBy("dataCriacao", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> selecionarMinhasDenuncias() {
    return _firebaseInstance
        .collection("denuncias")
        .where("usuarioCondomino", isEqualTo: userBloc.userConnected().uid)
        .orderBy("dataCriacao", descending: true)
        .snapshots();
  }

  Future _setDefaultValues(DenunciaModel promotion) async {
    promotion.status = 0;
    promotion.dataCriacao = DateTime.now();
  }

  Future<bool> saveProduct(
      DenunciaModel promotion, File imagem, BuildContext contexto) async {
    //_loadingController.add(true);
    progressBloc.mostrarLoading(contexto, true);

    try {
      await _setDefaultValues(promotion);

      var promotionConverted = promotion.toJson();

      await _setUserInformations(promotionConverted);

      DocumentReference ref = await _firebaseInstance
          .collection("denuncias")
          .add(Map.from(promotionConverted)..remove("imagens"));

      await _uploadImagens(ref.documentID, imagem, promotionConverted);
      await ref.updateData(promotionConverted);

      //_loadingController.add(false);
      progressBloc.mostrarLoading(contexto, false);

      return true;
    } on PlatformException catch (e) {
      //_loadingController.add(false);
      progressBloc.mostrarLoading(contexto, false);
      throw PlatformException(code: e.code, message: e.message, details: null);
    }
  }

  void _setUserInformations(Map<String, dynamic> json) {
    json["usuarioCondomino"] = userBloc.userConnected().uid;
  }

  void _setImgens(Map<String, dynamic> json, String image) {
    json["images"] = [image];
  }

  Future _uploadImagens(
      String promotionId, File imagem, Map<String, dynamic> json) async {
    StorageUploadTask storegeUploadTask = FirebaseStorage.instance
        .ref()
        .child(promotionId)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imagem);

    StorageTaskSnapshot s = await storegeUploadTask.onComplete;
    String downloadUrl = await s.ref.getDownloadURL();

    _setImgens(json, downloadUrl);
  }

  Future<File> imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(croppedImage.path);

      File compressedFile = await FlutterNativeImage.compressImage(
          croppedImage.path,
          quality: 65,
          targetWidth: 600,
          targetHeight: (properties.height * 600 / properties.width).round());

      return compressedFile;
    }
    return null;
  }

  String statusDoProcesso(int status) {
    switch (status) {
      case 0:
        return 'Aguardando';
      case 1:
        return 'Em analise';
      case 2:
        return 'Aprovado';
      case 3:
        return 'Rejeitado';
    }
  }

  Color retornarCorBaseadoNoStatusDoProcesso(int status) {
    switch (status) {
      case 0:
        return Colors.orangeAccent;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.redAccent;
    }
  }

  atualizarStatusDaDenuncia(DenunciaModel imprudence,
      StatusDaDenuncia novoStatus, BuildContext context) {
    Firestore.instance
        .collection('denuncias')
        .document(imprudence.id)
        .updateData({
      "status": converterStatusEmValor(novoStatus),
      "usuarioSindico": userBloc.userConnected().uid,
      "dataAlteracaoStatus": DateTime.now()
    });

    EdgeAlert.show(context,
        title: 'Informação',
        backgroundColor: Colors.green,
        description: 'Denúncia atualizada com sucesso!',
        gravity: EdgeAlert.BOTTOM);
  }

  Future<List<String>> selectCategories() async {
    List<String> lst = List<String>();

    QuerySnapshot query =
        await Firestore.instance.collection("categorias").getDocuments();

    query.documents.forEach((valor) {
      lst.add(valor.data['nome'].toString().toUpperCase());
    });

    return lst;
  }

  int converterStatusEmValor(StatusDaDenuncia status) {
    switch (status) {
      case StatusDaDenuncia.ANALISAR:
        return 1;
      case StatusDaDenuncia.APROVADO:
        return 2;
      case StatusDaDenuncia.REJEITADO:
        return 3;
    }
  }

  void _configuracoesPadroesMeetins(AvisoModel model) {
    model.data = DateTime.now();
    model.status = 0;
  }

  void adicionarNovoAviso(
      AvisoModel model, TipoDeAviso tipo, BuildContext context) {
    _configuracoesPadroesMeetins(model);
    model.tipo = tipo == TipoDeAviso.ATA ? 0 : 1;
    _firebaseInstance.collection('avisos').add(model.toJson());
    Navigator.of(context).pop();
  }

  void deletarAviso(String id) {
    _firebaseInstance.collection('avisos').document(id).delete();
  }

  @override
  void dispose() {
    _loadingController.close();
  }
}
