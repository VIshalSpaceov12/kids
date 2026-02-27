class GujaratiLetter {
  final String letter;
  final String transliteration;
  final String exampleWord;
  final String wordMeaning;
  final String emoji;
  final bool isVowel;

  const GujaratiLetter({
    required this.letter,
    required this.transliteration,
    required this.exampleWord,
    required this.wordMeaning,
    required this.emoji,
    required this.isVowel,
  });
}

class GujaratiData {
  static const List<GujaratiLetter> vowels = [
    GujaratiLetter(letter: '\u{0A85}', transliteration: 'A', exampleWord: '\u{0A85}\u{0AA8}\u{0ACD}\u{0AA8}', wordMeaning: 'Food', emoji: '\u{1F35A}', isVowel: true),
    GujaratiLetter(letter: '\u{0A86}', transliteration: 'Aa', exampleWord: '\u{0A86}\u{0AAE}', wordMeaning: 'Mango', emoji: '\u{1F96D}', isVowel: true),
    GujaratiLetter(letter: '\u{0A87}', transliteration: 'I', exampleWord: '\u{0A87}\u{0AAE}\u{0ABE}\u{0AB0}\u{0AA4}', wordMeaning: 'Building', emoji: '\u{1F3E2}', isVowel: true),
    GujaratiLetter(letter: '\u{0A88}', transliteration: 'Ee', exampleWord: '\u{0A88}\u{0A96}', wordMeaning: 'Sugarcane', emoji: '\u{1F33E}', isVowel: true),
    GujaratiLetter(letter: '\u{0A89}', transliteration: 'U', exampleWord: '\u{0A89}\u{0A82}\u{0AA6}\u{0AB0}', wordMeaning: 'Rat', emoji: '\u{1F400}', isVowel: true),
    GujaratiLetter(letter: '\u{0A8A}', transliteration: 'Oo', exampleWord: '\u{0A8A}\u{0AA8}', wordMeaning: 'Wool', emoji: '\u{1F9F6}', isVowel: true),
    GujaratiLetter(letter: '\u{0A8B}', transliteration: 'Ru', exampleWord: '\u{0A8B}\u{0AA4}\u{0AC1}', wordMeaning: 'Season', emoji: '\u{1F343}', isVowel: true),
    GujaratiLetter(letter: '\u{0A8F}', transliteration: 'E', exampleWord: '\u{0A8F}\u{0A95}\u{0AA4}\u{0ABE}\u{0AB0}', wordMeaning: 'Sitar', emoji: '\u{1F3B5}', isVowel: true),
    GujaratiLetter(letter: '\u{0A90}', transliteration: 'Ai', exampleWord: '\u{0A90}\u{0AB0}\u{0ABE}\u{0AB5}\u{0AA4}', wordMeaning: 'Iravat (elephant)', emoji: '\u{1F418}', isVowel: true),
    GujaratiLetter(letter: '\u{0A93}', transliteration: 'O', exampleWord: '\u{0A93}\u{0AB0}\u{0AA1}\u{0ABE}', wordMeaning: 'Room', emoji: '\u{1F6CF}\u{FE0F}', isVowel: true),
    GujaratiLetter(letter: '\u{0A94}', transliteration: 'Au', exampleWord: '\u{0A94}\u{0AB7}\u{0AA7}', wordMeaning: 'Medicine', emoji: '\u{1F48A}', isVowel: true),
    GujaratiLetter(letter: '\u{0A85}\u{0A82}', transliteration: 'Am', exampleWord: '\u{0A85}\u{0A82}\u{0A97}\u{0AC2}\u{0AA0}\u{0ABE}', wordMeaning: 'Thumb', emoji: '\u{1F44D}', isVowel: true),
    GujaratiLetter(letter: '\u{0A85}\u{0A83}', transliteration: 'Ah', exampleWord: '\u{0AA6}\u{0AC1}\u{0A83}\u{0A96}', wordMeaning: 'Sorrow', emoji: '\u{1F622}', isVowel: true),
  ];

  static const List<GujaratiLetter> consonants = [
    GujaratiLetter(letter: '\u{0A95}', transliteration: 'Ka', exampleWord: '\u{0A95}\u{0AAE}\u{0AB3}', wordMeaning: 'Lotus', emoji: '\u{1FAB7}', isVowel: false),
    GujaratiLetter(letter: '\u{0A96}', transliteration: 'Kha', exampleWord: '\u{0A96}\u{0ABE}\u{0AB0}\u{0AC0}', wordMeaning: 'Cot', emoji: '\u{1F6CF}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0A97}', transliteration: 'Ga', exampleWord: '\u{0A97}\u{0ABE}\u{0AAF}', wordMeaning: 'Cow', emoji: '\u{1F404}', isVowel: false),
    GujaratiLetter(letter: '\u{0A98}', transliteration: 'Gha', exampleWord: '\u{0A98}\u{0AB0}', wordMeaning: 'House', emoji: '\u{1F3E0}', isVowel: false),
    GujaratiLetter(letter: '\u{0A99}', transliteration: 'Nga', exampleWord: '\u{0AB0}\u{0A82}\u{0A97}', wordMeaning: 'Color', emoji: '\u{1F3A8}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9A}', transliteration: 'Cha', exampleWord: '\u{0A9A}\u{0A82}\u{0AA6}\u{0ACD}\u{0AB0}', wordMeaning: 'Moon', emoji: '\u{1F319}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9B}', transliteration: 'Chha', exampleWord: '\u{0A9B}\u{0AA4}\u{0ACD}\u{0AB0}\u{0AC0}', wordMeaning: 'Umbrella', emoji: '\u{2602}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9C}', transliteration: 'Ja', exampleWord: '\u{0A9C}\u{0AB9}\u{0ABE}\u{0A9C}', wordMeaning: 'Ship', emoji: '\u{1F6A2}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9D}', transliteration: 'Jha', exampleWord: '\u{0A9D}\u{0ABE}\u{0AA1}', wordMeaning: 'Tree', emoji: '\u{1F333}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9E}', transliteration: 'Nya', exampleWord: '\u{0A9C}\u{0ACD}\u{0A9E}\u{0ABE}\u{0AA8}', wordMeaning: 'Knowledge', emoji: '\u{1F4D6}', isVowel: false),
    GujaratiLetter(letter: '\u{0A9F}', transliteration: 'Ta', exampleWord: '\u{0A9F}\u{0AAE}\u{0ABE}\u{0A9F}\u{0ABE}', wordMeaning: 'Tomato', emoji: '\u{1F345}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA0}', transliteration: 'Tha', exampleWord: '\u{0AA0}\u{0A82}\u{0AA1}\u{0AC0}', wordMeaning: 'Cold', emoji: '\u{2744}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA1}', transliteration: 'Da', exampleWord: '\u{0AA1}\u{0AB0}', wordMeaning: 'Fear', emoji: '\u{1F628}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA2}', transliteration: 'Dha', exampleWord: '\u{0AA2}\u{0ACB}\u{0AB2}', wordMeaning: 'Drum', emoji: '\u{1FA98}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA3}', transliteration: 'Na', exampleWord: '\u{0AB0}\u{0ABE}\u{0AA3}\u{0AC0}', wordMeaning: 'Queen', emoji: '\u{1F478}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA4}', transliteration: 'Ta', exampleWord: '\u{0AA4}\u{0ABE}\u{0AB0}\u{0ABE}', wordMeaning: 'Stars', emoji: '\u{2B50}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA5}', transliteration: 'Tha', exampleWord: '\u{0AA5}\u{0ABE}\u{0AB3}\u{0AC0}', wordMeaning: 'Plate', emoji: '\u{1F37D}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA6}', transliteration: 'Da', exampleWord: '\u{0AA6}\u{0ABE}\u{0AA1}\u{0AAE}', wordMeaning: 'Pomegranate', emoji: '\u{1F34E}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA7}', transliteration: 'Dha', exampleWord: '\u{0AA7}\u{0ACD}\u{0AB5}\u{0A9C}', wordMeaning: 'Flag', emoji: '\u{1F3F3}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AA8}', transliteration: 'Na', exampleWord: '\u{0AA8}\u{0AA6}\u{0AC0}', wordMeaning: 'River', emoji: '\u{1F30A}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAA}', transliteration: 'Pa', exampleWord: '\u{0AAA}\u{0AA4}\u{0A82}\u{0A97}', wordMeaning: 'Kite', emoji: '\u{1FA81}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAB}', transliteration: 'Pha', exampleWord: '\u{0AAB}\u{0AC2}\u{0AB2}', wordMeaning: 'Flower', emoji: '\u{1F33A}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAC}', transliteration: 'Ba', exampleWord: '\u{0AAC}\u{0AA4}\u{0A95}', wordMeaning: 'Duck', emoji: '\u{1F986}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAD}', transliteration: 'Bha', exampleWord: '\u{0AAD}\u{0ABE}\u{0AB0}\u{0AA4}', wordMeaning: 'India', emoji: '\u{1F1EE}\u{1F1F3}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAE}', transliteration: 'Ma', exampleWord: '\u{0AAE}\u{0ACB}\u{0AB0}', wordMeaning: 'Peacock', emoji: '\u{1F99A}', isVowel: false),
    GujaratiLetter(letter: '\u{0AAF}', transliteration: 'Ya', exampleWord: '\u{0AAF}\u{0ACB}\u{0AA6}\u{0ACD}\u{0AA7}\u{0ABE}', wordMeaning: 'Warrior', emoji: '\u{2694}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB0}', transliteration: 'Ra', exampleWord: '\u{0AB0}\u{0ABE}\u{0A9C}\u{0ABE}', wordMeaning: 'King', emoji: '\u{1F451}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB2}', transliteration: 'La', exampleWord: '\u{0AB2}\u{0AC0}\u{0AAE}\u{0AA1}\u{0AC0}', wordMeaning: 'Lemon', emoji: '\u{1F34B}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB5}', transliteration: 'Va', exampleWord: '\u{0AB5}\u{0ABE}\u{0AA6}\u{0AB3}', wordMeaning: 'Cloud', emoji: '\u{2601}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB6}', transliteration: 'Sha', exampleWord: '\u{0AB6}\u{0AC7}\u{0AB0}\u{0AA1}\u{0AC0}', wordMeaning: 'Street', emoji: '\u{1F6E4}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB7}', transliteration: 'Sha', exampleWord: '\u{0AB7}\u{0A9F}\u{0ACD}\u{0A95}\u{0ACB}\u{0AA3}', wordMeaning: 'Hexagon', emoji: '\u{1F533}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB8}', transliteration: 'Sa', exampleWord: '\u{0AB8}\u{0AC2}\u{0AB0}\u{0A9C}', wordMeaning: 'Sun', emoji: '\u{2600}\u{FE0F}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB9}', transliteration: 'Ha', exampleWord: '\u{0AB9}\u{0ABE}\u{0AA5}\u{0AC0}', wordMeaning: 'Elephant', emoji: '\u{1F418}', isVowel: false),
    GujaratiLetter(letter: '\u{0AB3}', transliteration: 'La', exampleWord: '\u{0AB3}\u{0AC0}', wordMeaning: 'Green', emoji: '\u{1F33F}', isVowel: false),
  ];

  static List<GujaratiLetter> get allLetters => [...vowels, ...consonants];
}
