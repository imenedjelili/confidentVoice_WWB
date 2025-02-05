class Quote {
  final int id;
  final String quote;

  const Quote({
    required this.id,
    required this.quote,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as int,
      quote: map['quote'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': quote,
    };
  }

  @override
  String toString() {
    return 'Quote{id: $id, quote: $quote}';
  }
}
