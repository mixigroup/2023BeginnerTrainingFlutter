import 'package:json_annotation/json_annotation.dart';

// 最初はエラー出ててOK！
part 'repository.g.dart';

@JsonSerializable()
class Repository {
  final int id;
  final String name;

  Repository({
    required this.id,
    required this.name,
  });

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}
