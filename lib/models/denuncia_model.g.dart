// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denuncia_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DenunciaModel _$DenunciaModelFromJson(Map<String, dynamic> json) {
  return DenunciaModel()
    ..id = json['id'] as String
    ..usuarioCondomino = json['usuarioCondomino'] as String
    ..usuarioSindico = json['usuarioSindico'] as String
    ..observacao = json['observacao'] as String
    ..tipo = json['tipo'] as String
    ..status = json['status'] as int
    ..dataAlteracaoStatus = json['dataAlteracaoStatus'] == null
        ? null
        : DateTime.parse(json['dataAlteracaoStatus'] as String)
    ..dataCriacao = json['dataCriacao'] == null
        ? null
        : DateTime.parse(json['dataCriacao'] as String)
    ..images = json['images'] as List;
}

Map<String, dynamic> _$DenunciaModelToJson(DenunciaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuarioCondomino': instance.usuarioCondomino,
      'usuarioSindico': instance.usuarioSindico,
      'observacao': instance.observacao,
      'tipo': instance.tipo,
      'status': instance.status,
      'dataAlteracaoStatus': instance.dataAlteracaoStatus,
      'dataCriacao': instance.dataCriacao,
      'images': instance.images,
    };
