import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avisos_model.g.dart';

@JsonSerializable()
class AvisoModel {
  String id;
  String titulo;
  String descricao;
  String observacao;
  int tipo;
  int status;
  DateTime data;

  AvisoModel();

  AvisoModel.fromDocument(DocumentSnapshot snapshop) {
    id = snapshop.documentID;
    titulo = snapshop.data["titulo"];
    descricao = snapshop.data["descricao"];
    observacao = snapshop.data["observacao"];
    tipo = snapshop.data["tipo"];
    status = snapshop.data["status"];
    data = snapshop.data["data"] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            snapshop.data["data"].millisecondsSinceEpoch)
        : null;
  }

  factory AvisoModel.fromJson(Map<String, dynamic> json) =>
      _$AvisoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvisoModelToJson(this);
}
