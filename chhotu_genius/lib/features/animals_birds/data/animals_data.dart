class AnimalItem {
  final String name;
  final String hindiName;
  final String emoji;
  final String category; // 'animal' or 'bird'
  final String habitat;
  final String funFact;

  const AnimalItem({
    required this.name,
    required this.hindiName,
    required this.emoji,
    required this.category,
    required this.habitat,
    required this.funFact,
  });
}

class AnimalsData {
  static const List<AnimalItem> animals = [
    AnimalItem(
      name: 'Lion',
      hindiName: '\u{0936}\u{0947}\u{0930}',
      emoji: '\u{1F981}',
      category: 'animal',
      habitat: 'Gir Forest, Gujarat',
      funFact: 'The Asiatic lion is found only in India!',
    ),
    AnimalItem(
      name: 'Tiger',
      hindiName: '\u{092C}\u{093E}\u{0918}',
      emoji: '\u{1F42F}',
      category: 'animal',
      habitat: 'Forests across India',
      funFact: 'India has the most tigers in the world!',
    ),
    AnimalItem(
      name: 'Elephant',
      hindiName: '\u{0939}\u{093E}\u{0925}\u{0940}',
      emoji: '\u{1F418}',
      category: 'animal',
      habitat: 'Forests of Kerala & Karnataka',
      funFact: 'Elephants can remember places for many years!',
    ),
    AnimalItem(
      name: 'Cow',
      hindiName: '\u{0917}\u{093E}\u{092F}',
      emoji: '\u{1F404}',
      category: 'animal',
      habitat: 'Farms & villages',
      funFact: 'Cows are loved and respected all over India!',
    ),
    AnimalItem(
      name: 'Monkey',
      hindiName: '\u{092C}\u{0902}\u{0926}\u{0930}',
      emoji: '\u{1F435}',
      category: 'animal',
      habitat: 'Temples & forests',
      funFact: 'Monkeys love bananas and live in big groups!',
    ),
    AnimalItem(
      name: 'Camel',
      hindiName: '\u{090A}\u{0901}\u{091F}',
      emoji: '\u{1F42A}',
      category: 'animal',
      habitat: 'Rajasthan desert',
      funFact: 'Camels can go days without drinking water!',
    ),
    AnimalItem(
      name: 'Deer',
      hindiName: '\u{0939}\u{093F}\u{0930}\u{0923}',
      emoji: '\u{1F98C}',
      category: 'animal',
      habitat: 'National parks',
      funFact: 'Spotted deer are the most common deer in India!',
    ),
    AnimalItem(
      name: 'Rhinoceros',
      hindiName: '\u{0917}\u{0948}\u{0902}\u{0921}\u{093E}',
      emoji: '\u{1F98F}',
      category: 'animal',
      habitat: 'Kaziranga, Assam',
      funFact: 'Indian rhinos have one horn, not two!',
    ),
    AnimalItem(
      name: 'Snake',
      hindiName: '\u{0938}\u{093E}\u{0901}\u{092A}',
      emoji: '\u{1F40D}',
      category: 'animal',
      habitat: 'Fields & forests',
      funFact: 'King Cobra is the longest venomous snake!',
    ),
    AnimalItem(
      name: 'Dog',
      hindiName: '\u{0915}\u{0941}\u{0924}\u{094D}\u{0924}\u{093E}',
      emoji: '\u{1F436}',
      category: 'animal',
      habitat: 'Homes & streets',
      funFact: 'Dogs are our best friends and very loyal!',
    ),
    // Birds
    AnimalItem(
      name: 'Peacock',
      hindiName: '\u{092E}\u{094B}\u{0930}',
      emoji: '\u{1F99A}',
      category: 'bird',
      habitat: 'Forests & gardens',
      funFact: 'Peacock is the national bird of India!',
    ),
    AnimalItem(
      name: 'Parrot',
      hindiName: '\u{0924}\u{094B}\u{0924}\u{093E}',
      emoji: '\u{1F99C}',
      category: 'bird',
      habitat: 'Trees & gardens',
      funFact: 'Parrots can learn to talk like humans!',
    ),
    AnimalItem(
      name: 'Sparrow',
      hindiName: '\u{0917}\u{094C}\u{0930}\u{0948}\u{092F}\u{093E}',
      emoji: '\u{1F426}',
      category: 'bird',
      habitat: 'Houses & cities',
      funFact: 'Sparrows love to live near people!',
    ),
    AnimalItem(
      name: 'Crow',
      hindiName: '\u{0915}\u{094C}\u{0906}',
      emoji: '\u{1F426}\u{200D}\u{2B1B}',
      category: 'bird',
      habitat: 'Everywhere in India',
      funFact: 'Crows are one of the smartest birds!',
    ),
    AnimalItem(
      name: 'Pigeon',
      hindiName: '\u{0915}\u{092C}\u{0942}\u{0924}\u{0930}',
      emoji: '\u{1F54A}\u{FE0F}',
      category: 'bird',
      habitat: 'Cities & temples',
      funFact: 'Pigeons can find their way home from far away!',
    ),
    AnimalItem(
      name: 'Eagle',
      hindiName: '\u{091A}\u{0940}\u{0932}',
      emoji: '\u{1F985}',
      category: 'bird',
      habitat: 'Mountains & forests',
      funFact: 'Eagles can see fish from very high in the sky!',
    ),
    AnimalItem(
      name: 'Owl',
      hindiName: '\u{0909}\u{0932}\u{094D}\u{0932}\u{0942}',
      emoji: '\u{1F989}',
      category: 'bird',
      habitat: 'Old trees & ruins',
      funFact: 'Owls can turn their head almost all the way around!',
    ),
    AnimalItem(
      name: 'Swan',
      hindiName: '\u{0939}\u{0902}\u{0938}',
      emoji: '\u{1F9A2}',
      category: 'bird',
      habitat: 'Lakes & rivers',
      funFact: 'Swans are symbols of beauty and grace in India!',
    ),
    AnimalItem(
      name: 'Kingfisher',
      hindiName: '\u{0915}\u{093F}\u{0902}\u{0917}\u{092B}\u{093F}\u{0936}\u{0930}',
      emoji: '\u{1F426}',
      category: 'bird',
      habitat: 'Rivers & ponds',
      funFact: 'Kingfishers dive super fast to catch fish!',
    ),
    AnimalItem(
      name: 'Flamingo',
      hindiName: '\u{0930}\u{093E}\u{091C}\u{0939}\u{0902}\u{0938}',
      emoji: '\u{1F9A9}',
      category: 'bird',
      habitat: 'Kutch, Gujarat',
      funFact: 'Flamingos are pink because of what they eat!',
    ),
  ];
}
