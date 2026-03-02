import 'dart:convert';

class ChildProfile {
  final String name;
  final int age;
  final String classLevel;
  final String avatar;
  final String pet;
  final String language;
  final String parentPin;
  final String serverId; // Server-side child UUID for API calls

  ChildProfile({
    required this.name,
    this.age = 5,
    required this.classLevel,
    required this.avatar,
    this.pet = '',
    this.language = 'en',
    this.parentPin = '',
    this.serverId = '',
  });

  ChildProfile copyWith({
    String? name,
    int? age,
    String? classLevel,
    String? avatar,
    String? pet,
    String? language,
    String? parentPin,
    String? serverId,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      classLevel: classLevel ?? this.classLevel,
      avatar: avatar ?? this.avatar,
      pet: pet ?? this.pet,
      language: language ?? this.language,
      parentPin: parentPin ?? this.parentPin,
      serverId: serverId ?? this.serverId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'classLevel': classLevel,
      'avatar': avatar,
      'pet': pet,
      'language': language,
      'parentPin': parentPin,
      'serverId': serverId,
    };
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 5,
      classLevel: json['classLevel'] as String? ?? 'nursery',
      avatar: json['avatar'] as String? ?? 'lion',
      pet: json['pet'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      parentPin: json['parentPin'] as String? ?? '',
      serverId: json['serverId'] as String? ?? '',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ChildProfile.fromJsonString(String jsonString) {
    return ChildProfile.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}
