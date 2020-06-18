import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'denuncia_model.g.dart';

@JsonSerializable()
class DenunciaModel {
  String id;
  String usuarioCondomino;
  String usuarioSindico;
  String observacao;
  String tipo;
  int status;
  DateTime dataAlteracaoStatus;
  DateTime dataCriacao;
  List images;

  DenunciaModel();

  DenunciaModel.fromDocument(DocumentSnapshot snapshop) {
    id = snapshop.documentID;
    usuarioCondomino = snapshop.data["usuarioCondomino"];
    usuarioSindico = snapshop.data["usuarioSindico"];
    observacao = snapshop.data["observacao"];
    tipo = snapshop.data["tipo"];
    status = snapshop.data["status"];
    dataAlteracaoStatus = snapshop.data["dataAlteracaoStatus"] != null
        ? snapshop.data["dataAlteracaoStatus"].toDate()
        : null;
    dataCriacao = snapshop.data["dataCriacao"].toDate();
    images = snapshop.data["images"];
  }

  DenunciaModel.fromJsonSimple(Map<String, dynamic> json) {
    observacao = json["observacao"];
    tipo = json["titulo"];
  }

  factory DenunciaModel.fromJson(Map<String, dynamic> json) =>
      _$DenunciaModelFromJson(json);

  Map<String, dynamic> toJson() => _$DenunciaModelToJson(this);
}
