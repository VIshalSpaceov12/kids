class ClassLevel {
  final String id;
  final String name;
  final int maxNumber;

  const ClassLevel({
    required this.id,
    required this.name,
    required this.maxNumber,
  });
}

class AvatarOption {
  final String id;
  final String emoji;
  final String name;

  const AvatarOption({
    required this.id,
    required this.emoji,
    required this.name,
  });
}

class AppConstants {
  static const String appName = 'Chhotu Genius';
  static const String tagline = 'Learn, Play, Grow!';

  static const List<ClassLevel> classLevels = [
    ClassLevel(id: 'nursery', name: 'Nursery', maxNumber: 10),
    ClassLevel(id: 'kg', name: 'KG', maxNumber: 20),
    ClassLevel(id: 'class1', name: 'Class 1', maxNumber: 50),
    ClassLevel(id: 'class2', name: 'Class 2', maxNumber: 100),
    ClassLevel(id: 'class3', name: 'Class 3', maxNumber: 100),
    ClassLevel(id: 'class4', name: 'Class 4', maxNumber: 100),
  ];

  static const List<AvatarOption> avatarOptions = [
    AvatarOption(id: 'lion', emoji: '\u{1F981}', name: 'Lion'),
    AvatarOption(id: 'tiger', emoji: '\u{1F42F}', name: 'Tiger'),
    AvatarOption(id: 'elephant', emoji: '\u{1F418}', name: 'Elephant'),
    AvatarOption(id: 'peacock', emoji: '\u{1F99A}', name: 'Peacock'),
    AvatarOption(id: 'monkey', emoji: '\u{1F435}', name: 'Monkey'),
    AvatarOption(id: 'parrot', emoji: '\u{1F99C}', name: 'Parrot'),
  ];

  static ClassLevel getClassLevel(String id) {
    return classLevels.firstWhere(
      (level) => level.id == id,
      orElse: () => classLevels.first,
    );
  }

  static AvatarOption getAvatar(String id) {
    return avatarOptions.firstWhere(
      (avatar) => avatar.id == id,
      orElse: () => avatarOptions.first,
    );
  }
}
