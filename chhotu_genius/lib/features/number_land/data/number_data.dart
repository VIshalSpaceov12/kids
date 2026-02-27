class NumberItem {
  final int number;
  final String englishName;
  final String gujaratiName;
  final String emoji;
  final String emojiName;

  const NumberItem({
    required this.number,
    required this.englishName,
    required this.gujaratiName,
    required this.emoji,
    required this.emojiName,
  });
}

class NumberData {
  static const List<NumberItem> numbers = [
    NumberItem(
      number: 1,
      englishName: 'One',
      gujaratiName: '\u{0A8F}\u{0A95}',
      emoji: '\u{1F34E}',
      emojiName: 'Apple',
    ),
    NumberItem(
      number: 2,
      englishName: 'Two',
      gujaratiName: '\u{0AAC}\u{0AC7}',
      emoji: '\u{2B50}',
      emojiName: 'Star',
    ),
    NumberItem(
      number: 3,
      englishName: 'Three',
      gujaratiName: '\u{0AA4}\u{0ACD}\u{0AB0}\u{0AA3}',
      emoji: '\u{1F41F}',
      emojiName: 'Fish',
    ),
    NumberItem(
      number: 4,
      englishName: 'Four',
      gujaratiName: '\u{0A9A}\u{0ABE}\u{0AB0}',
      emoji: '\u{1F98B}',
      emojiName: 'Butterfly',
    ),
    NumberItem(
      number: 5,
      englishName: 'Five',
      gujaratiName: '\u{0AAA}\u{0ABE}\u{0A82}\u{0A9A}',
      emoji: '\u{1F33A}',
      emojiName: 'Flower',
    ),
    NumberItem(
      number: 6,
      englishName: 'Six',
      gujaratiName: '\u{0A9B}',
      emoji: '\u{1F353}',
      emojiName: 'Strawberry',
    ),
    NumberItem(
      number: 7,
      englishName: 'Seven',
      gujaratiName: '\u{0AB8}\u{0ABE}\u{0AA4}',
      emoji: '\u{1F308}',
      emojiName: 'Rainbow',
    ),
    NumberItem(
      number: 8,
      englishName: 'Eight',
      gujaratiName: '\u{0A86}\u{0AA0}',
      emoji: '\u{1F419}',
      emojiName: 'Octopus',
    ),
    NumberItem(
      number: 9,
      englishName: 'Nine',
      gujaratiName: '\u{0AA8}\u{0AB5}',
      emoji: '\u{1F31F}',
      emojiName: 'Glowing Star',
    ),
    NumberItem(
      number: 10,
      englishName: 'Ten',
      gujaratiName: '\u{0AA6}\u{0AB8}',
      emoji: '\u{1F34C}',
      emojiName: 'Banana',
    ),
    NumberItem(
      number: 11,
      englishName: 'Eleven',
      gujaratiName: '\u{0A85}\u{0A97}\u{0ABF}\u{0AAF}\u{0ABE}\u{0AB0}',
      emoji: '\u{26BD}',
      emojiName: 'Football',
    ),
    NumberItem(
      number: 12,
      englishName: 'Twelve',
      gujaratiName: '\u{0AAC}\u{0ABE}\u{0AB0}',
      emoji: '\u{1F382}',
      emojiName: 'Cake',
    ),
    NumberItem(
      number: 13,
      englishName: 'Thirteen',
      gujaratiName: '\u{0AA4}\u{0AC7}\u{0AB0}',
      emoji: '\u{1F36D}',
      emojiName: 'Lollipop',
    ),
    NumberItem(
      number: 14,
      englishName: 'Fourteen',
      gujaratiName: '\u{0A9A}\u{0ACC}\u{0AA6}',
      emoji: '\u{1F3C0}',
      emojiName: 'Basketball',
    ),
    NumberItem(
      number: 15,
      englishName: 'Fifteen',
      gujaratiName: '\u{0AAA}\u{0A82}\u{0AA6}\u{0AB0}',
      emoji: '\u{1F33B}',
      emojiName: 'Sunflower',
    ),
    NumberItem(
      number: 16,
      englishName: 'Sixteen',
      gujaratiName: '\u{0AB8}\u{0ACB}\u{0AB3}',
      emoji: '\u{1F680}',
      emojiName: 'Rocket',
    ),
    NumberItem(
      number: 17,
      englishName: 'Seventeen',
      gujaratiName: '\u{0AB8}\u{0AA4}\u{0ACD}\u{0AA4}\u{0AB0}',
      emoji: '\u{1F98B}',
      emojiName: 'Butterfly',
    ),
    NumberItem(
      number: 18,
      englishName: 'Eighteen',
      gujaratiName: '\u{0A85}\u{0AA2}\u{0ABE}\u{0AB0}',
      emoji: '\u{1F40C}',
      emojiName: 'Snail',
    ),
    NumberItem(
      number: 19,
      englishName: 'Nineteen',
      gujaratiName: '\u{0A93}\u{0A97}\u{0AA3}\u{0AC0}\u{0AB8}',
      emoji: '\u{1F99E}',
      emojiName: 'Lobster',
    ),
    NumberItem(
      number: 20,
      englishName: 'Twenty',
      gujaratiName: '\u{0AB5}\u{0AC0}\u{0AB8}',
      emoji: '\u{1F339}',
      emojiName: 'Rose',
    ),
  ];

  static List<NumberItem> getNumbersForClass(int maxNumber) {
    return numbers.where((n) => n.number <= maxNumber).toList();
  }
}
