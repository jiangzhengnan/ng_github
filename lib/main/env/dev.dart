import 'package:json_annotation/json_annotation.dart';

part 'dev.g.dart';

//读取的配置json
@JsonLiteral('env_json_dev.json', asConst: true)
Map<String, dynamic> get config => _$configJsonLiteral;