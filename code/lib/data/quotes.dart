import 'package:confident_voice/models/classes/Quote.dart';
import 'dart:math';

final Random _random = Random();

final List<Quote> inspirationalQuotes = [
  Quote(
    id: 1,
    quote: "Your voice has the power to move mountains. Use it wisely.",
  ),
  Quote(
    id: 2,
    quote: "Speak with confidence, and the world will listen.",
  ),
  Quote(
    id: 3,
    quote: "Every great speaker was once a beginner who kept going.",
  ),
  Quote(
    id: 4,
    quote: "Your words can change someone's world. Make them count.",
  ),
  Quote(
    id: 5,
    quote: "Confidence isn't about being perfect; it's about being present.",
  ),
  Quote(
    id: 6,
    quote: "The journey of a thousand speeches begins with a single word.",
  ),
  Quote(
    id: 7,
    quote: "Let your voice be the bridge between your dreams and reality.",
  ),
  Quote(
    id: 8,
    quote: "In the symphony of life, your voice is the most important instrument.",
  ),
  Quote(
    id: 9,
    quote: "Speak from the heart, and you'll never go wrong.",
  ),
  Quote(
    id: 10,
    quote: "The most powerful voice in the room is the authentic one.",
  ),
  Quote(
    id: 11,
    quote: "Your story matters. Tell it with pride.",
  ),
  Quote(
    id: 12,
    quote: "Every voice has a stage waiting for it.",
  ),
  Quote(
    id: 13,
    quote: "The world needs your voice, exactly as it is.",
  ),
  Quote(
    id: 14,
    quote: "Confidence grows in the moments when you think you can't go on but you keep going anyway.",
  ),
  Quote(
    id: 15,
    quote: "Your voice is your power. Own it.",
  ),
];

Quote getRandomQuote() {
  // Get a random quote each time
  return inspirationalQuotes[_random.nextInt(inspirationalQuotes.length)];
}
