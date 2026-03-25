class LyricLine {
  final String text;
  final double startTime; // seconds into the audio

  const LyricLine({required this.text, required this.startTime});
}

class RhymeItem {
  final String title;
  final String emoji;
  final String youtubeVideoId;
  final List<LyricLine> lines;

  const RhymeItem({
    required this.title,
    required this.emoji,
    required this.youtubeVideoId,
    required this.lines,
  });

  String get lyrics => lines.map((l) => l.text).join('\n');
}

class RhymesData {
  static const List<RhymeItem> rhymes = [
    RhymeItem(
      title: 'Twinkle Twinkle Little Star',
      emoji: '\u{2B50}',
      youtubeVideoId: 'yCjJyiqpAuU',
      lines: [
        LyricLine(text: 'Twinkle, twinkle, little star,', startTime: 0.0),
        LyricLine(text: 'How I wonder what you are!', startTime: 4.0),
        LyricLine(text: 'Up above the world so high,', startTime: 8.0),
        LyricLine(text: 'Like a diamond in the sky.', startTime: 12.0),
        LyricLine(text: 'Twinkle, twinkle, little star,', startTime: 16.0),
        LyricLine(text: 'How I wonder what you are!', startTime: 20.0),
      ],
    ),
    RhymeItem(
      title: 'Johnny Johnny Yes Papa',
      emoji: '\u{1F476}',
      youtubeVideoId: 'F4tHL8reNCs',
      lines: [
        LyricLine(text: 'Johnny, Johnny,', startTime: 0.0),
        LyricLine(text: 'Yes, Papa?', startTime: 3.0),
        LyricLine(text: 'Eating sugar?', startTime: 6.0),
        LyricLine(text: 'No, Papa!', startTime: 9.0),
        LyricLine(text: 'Telling lies?', startTime: 12.0),
        LyricLine(text: 'No, Papa!', startTime: 15.0),
        LyricLine(text: 'Open your mouth,', startTime: 18.0),
        LyricLine(text: 'Ha! Ha! Ha!', startTime: 21.0),
      ],
    ),
    RhymeItem(
      title: 'Jack and Jill',
      emoji: '\u{1F3D4}\u{FE0F}',
      youtubeVideoId: 'SLMJpHihykI',
      lines: [
        LyricLine(text: 'Jack and Jill went up the hill,', startTime: 0.0),
        LyricLine(text: 'To fetch a pail of water.', startTime: 4.0),
        LyricLine(text: 'Jack fell down and broke his crown,', startTime: 8.0),
        LyricLine(text: 'And Jill came tumbling after.', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Humpty Dumpty',
      emoji: '\u{1F95A}',
      youtubeVideoId: 'nrwzpiOBBCs',
      lines: [
        LyricLine(text: 'Humpty Dumpty sat on a wall,', startTime: 0.0),
        LyricLine(text: 'Humpty Dumpty had a great fall.', startTime: 4.0),
        LyricLine(text: 'All the king\'s horses and all the king\'s men,', startTime: 8.0),
        LyricLine(text: 'Couldn\'t put Humpty together again!', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Baa Baa Black Sheep',
      emoji: '\u{1F411}',
      youtubeVideoId: 'MR5XSOdjKMA',
      lines: [
        LyricLine(text: 'Baa, baa, black sheep,', startTime: 0.0),
        LyricLine(text: 'Have you any wool?', startTime: 3.0),
        LyricLine(text: 'Yes sir, yes sir,', startTime: 6.0),
        LyricLine(text: 'Three bags full.', startTime: 9.0),
        LyricLine(text: 'One for the master,', startTime: 13.0),
        LyricLine(text: 'One for the dame,', startTime: 16.0),
        LyricLine(text: 'And one for the little boy', startTime: 19.0),
        LyricLine(text: 'Who lives down the lane.', startTime: 22.0),
      ],
    ),
    RhymeItem(
      title: 'Mary Had a Little Lamb',
      emoji: '\u{1F411}',
      youtubeVideoId: 'mZVCNgnYfmU',
      lines: [
        LyricLine(text: 'Mary had a little lamb,', startTime: 0.0),
        LyricLine(text: 'Little lamb, little lamb.', startTime: 4.0),
        LyricLine(text: 'Mary had a little lamb,', startTime: 8.0),
        LyricLine(text: 'Its fleece was white as snow.', startTime: 12.0),
        LyricLine(text: 'And everywhere that Mary went,', startTime: 17.0),
        LyricLine(text: 'Mary went, Mary went.', startTime: 21.0),
        LyricLine(text: 'Everywhere that Mary went,', startTime: 25.0),
        LyricLine(text: 'The lamb was sure to go.', startTime: 29.0),
      ],
    ),
    RhymeItem(
      title: 'Old MacDonald Had a Farm',
      emoji: '\u{1F3E1}',
      youtubeVideoId: '_6HzoUcx3eo',
      lines: [
        LyricLine(text: 'Old MacDonald had a farm, E-I-E-I-O!', startTime: 0.0),
        LyricLine(text: 'And on his farm he had a cow, E-I-E-I-O!', startTime: 5.0),
        LyricLine(text: 'With a moo moo here, and a moo moo there,', startTime: 10.0),
        LyricLine(text: 'Here a moo, there a moo, everywhere a moo moo.', startTime: 14.0),
        LyricLine(text: 'Old MacDonald had a farm, E-I-E-I-O!', startTime: 19.0),
      ],
    ),
    RhymeItem(
      title: 'Wheels on the Bus',
      emoji: '\u{1F68C}',
      youtubeVideoId: 'e_04ZrNroTo',
      lines: [
        LyricLine(text: 'The wheels on the bus go round and round,', startTime: 0.0),
        LyricLine(text: 'Round and round, round and round.', startTime: 4.0),
        LyricLine(text: 'The wheels on the bus go round and round,', startTime: 8.0),
        LyricLine(text: 'All through the town!', startTime: 12.0),
        LyricLine(text: 'The horn on the bus goes beep beep beep,', startTime: 17.0),
        LyricLine(text: 'Beep beep beep, beep beep beep.', startTime: 21.0),
        LyricLine(text: 'The horn on the bus goes beep beep beep,', startTime: 25.0),
        LyricLine(text: 'All through the town!', startTime: 29.0),
      ],
    ),
    RhymeItem(
      title: 'Row Row Row Your Boat',
      emoji: '\u{1F6F6}',
      youtubeVideoId: '7otAJa3jui8',
      lines: [
        LyricLine(text: 'Row, row, row your boat,', startTime: 0.0),
        LyricLine(text: 'Gently down the stream.', startTime: 4.0),
        LyricLine(text: 'Merrily, merrily, merrily, merrily,', startTime: 8.0),
        LyricLine(text: 'Life is but a dream.', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Itsy Bitsy Spider',
      emoji: '\u{1F577}\u{FE0F}',
      youtubeVideoId: 'w_lCBkoGniQ',
      lines: [
        LyricLine(text: 'The itsy bitsy spider', startTime: 0.0),
        LyricLine(text: 'Climbed up the water spout.', startTime: 3.0),
        LyricLine(text: 'Down came the rain', startTime: 6.0),
        LyricLine(text: 'And washed the spider out.', startTime: 9.0),
        LyricLine(text: 'Out came the sun', startTime: 13.0),
        LyricLine(text: 'And dried up all the rain.', startTime: 16.0),
        LyricLine(text: 'And the itsy bitsy spider', startTime: 19.0),
        LyricLine(text: 'Climbed up the spout again.', startTime: 22.0),
      ],
    ),
    RhymeItem(
      title: 'London Bridge Is Falling Down',
      emoji: '\u{1F309}',
      youtubeVideoId: '-csGDoSSZyc',
      lines: [
        LyricLine(text: 'London Bridge is falling down,', startTime: 0.0),
        LyricLine(text: 'Falling down, falling down.', startTime: 4.0),
        LyricLine(text: 'London Bridge is falling down,', startTime: 8.0),
        LyricLine(text: 'My fair lady!', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Head Shoulders Knees and Toes',
      emoji: '\u{1F9D1}',
      youtubeVideoId: 'ZanHgPprl-0',
      lines: [
        LyricLine(text: 'Head, shoulders, knees and toes,', startTime: 0.0),
        LyricLine(text: 'Knees and toes.', startTime: 4.0),
        LyricLine(text: 'Head, shoulders, knees and toes,', startTime: 7.0),
        LyricLine(text: 'Knees and toes.', startTime: 11.0),
        LyricLine(text: 'And eyes and ears and mouth and nose.', startTime: 15.0),
        LyricLine(text: 'Head, shoulders, knees and toes,', startTime: 19.0),
        LyricLine(text: 'Knees and toes!', startTime: 23.0),
      ],
    ),
    RhymeItem(
      title: 'If You\'re Happy and You Know It',
      emoji: '\u{1F44F}',
      youtubeVideoId: 'l4WNrvVjiTw',
      lines: [
        LyricLine(text: 'If you\'re happy and you know it,', startTime: 0.0),
        LyricLine(text: 'Clap your hands!', startTime: 4.0),
        LyricLine(text: 'If you\'re happy and you know it,', startTime: 7.0),
        LyricLine(text: 'Clap your hands!', startTime: 11.0),
        LyricLine(text: 'If you\'re happy and you know it,', startTime: 15.0),
        LyricLine(text: 'And you really want to show it,', startTime: 19.0),
        LyricLine(text: 'If you\'re happy and you know it,', startTime: 23.0),
        LyricLine(text: 'Clap your hands!', startTime: 27.0),
      ],
    ),
    RhymeItem(
      title: 'Rain Rain Go Away',
      emoji: '\u{1F327}\u{FE0F}',
      youtubeVideoId: 'LFrKYjrIDs8',
      lines: [
        LyricLine(text: 'Rain, rain, go away,', startTime: 0.0),
        LyricLine(text: 'Come again another day.', startTime: 4.0),
        LyricLine(text: 'Little Johnny wants to play,', startTime: 8.0),
        LyricLine(text: 'Rain, rain, go away!', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Hickory Dickory Dock',
      emoji: '\u{1F42D}',
      youtubeVideoId: 'vAoKNJLf7R0',
      lines: [
        LyricLine(text: 'Hickory dickory dock,', startTime: 0.0),
        LyricLine(text: 'The mouse ran up the clock.', startTime: 3.0),
        LyricLine(text: 'The clock struck one,', startTime: 6.0),
        LyricLine(text: 'The mouse ran down,', startTime: 9.0),
        LyricLine(text: 'Hickory dickory dock!', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Five Little Monkeys',
      emoji: '\u{1F435}',
      youtubeVideoId: 'ZhODBFQ2-bQ',
      lines: [
        LyricLine(text: 'Five little monkeys jumping on the bed,', startTime: 0.0),
        LyricLine(text: 'One fell off and bumped his head.', startTime: 4.0),
        LyricLine(text: 'Mama called the doctor and the doctor said,', startTime: 8.0),
        LyricLine(text: 'No more monkeys jumping on the bed!', startTime: 12.0),
        LyricLine(text: 'Four little monkeys jumping on the bed,', startTime: 17.0),
        LyricLine(text: 'One fell off and bumped his head.', startTime: 21.0),
        LyricLine(text: 'Mama called the doctor and the doctor said,', startTime: 25.0),
        LyricLine(text: 'No more monkeys jumping on the bed!', startTime: 29.0),
      ],
    ),
    RhymeItem(
      title: 'Hot Cross Buns',
      emoji: '\u{1F35E}',
      youtubeVideoId: 'gJJsqGOkKYM',
      lines: [
        LyricLine(text: 'Hot cross buns! Hot cross buns!', startTime: 0.0),
        LyricLine(text: 'One a penny, two a penny,', startTime: 4.0),
        LyricLine(text: 'Hot cross buns!', startTime: 8.0),
        LyricLine(text: 'If you have no daughters,', startTime: 13.0),
        LyricLine(text: 'Give them to your sons.', startTime: 17.0),
        LyricLine(text: 'One a penny, two a penny,', startTime: 21.0),
        LyricLine(text: 'Hot cross buns!', startTime: 25.0),
      ],
    ),
    RhymeItem(
      title: 'Little Bo Peep',
      emoji: '\u{1F411}',
      youtubeVideoId: '-TjUkPHJdAI',
      lines: [
        LyricLine(text: 'Little Bo Peep has lost her sheep,', startTime: 0.0),
        LyricLine(text: 'And doesn\'t know where to find them.', startTime: 4.0),
        LyricLine(text: 'Leave them alone and they\'ll come home,', startTime: 8.0),
        LyricLine(text: 'Wagging their tails behind them.', startTime: 12.0),
      ],
    ),
    RhymeItem(
      title: 'Hey Diddle Diddle',
      emoji: '\u{1F31D}',
      youtubeVideoId: 'aHKEMRNMdKI',
      lines: [
        LyricLine(text: 'Hey diddle diddle,', startTime: 0.0),
        LyricLine(text: 'The cat and the fiddle,', startTime: 3.0),
        LyricLine(text: 'The cow jumped over the moon.', startTime: 6.0),
        LyricLine(text: 'The little dog laughed to see such fun,', startTime: 10.0),
        LyricLine(text: 'And the dish ran away with the spoon!', startTime: 14.0),
      ],
    ),
    RhymeItem(
      title: 'One Two Buckle My Shoe',
      emoji: '\u{1F45F}',
      youtubeVideoId: 'ib3Idyml-pU',
      lines: [
        LyricLine(text: 'One, two, buckle my shoe.', startTime: 0.0),
        LyricLine(text: 'Three, four, knock at the door.', startTime: 4.0),
        LyricLine(text: 'Five, six, pick up sticks.', startTime: 8.0),
        LyricLine(text: 'Seven, eight, lay them straight.', startTime: 12.0),
        LyricLine(text: 'Nine, ten, a big fat hen!', startTime: 16.0),
      ],
    ),
  ];
}
