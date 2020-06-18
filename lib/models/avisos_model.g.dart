// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avisos_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvisoModel _$AvisoModelFromJson(Map<String, dynamic> json) {
  return AvisoModel()
    ..id = json['id'] as String
    ..titulo = json['titulo'] as String
    ..descricao = json['descricao'] as String
    ..observacao = json['observacao'] as String
    ..tipo = json['tipo'] as int
    ..status = json['status'] as int
    ..data =
        json['data'] == null ? null : DateTime.parse(json['data'] as String);
}

Map<String, dynamic> _$AvisoModelToJson(AvisoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'observacao': instance.observacao,
      'tipo': instance.tipo,
      'status': instance.status,
      'data': instance.data,
    };
