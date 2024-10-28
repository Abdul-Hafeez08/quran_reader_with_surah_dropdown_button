class Ayah {
  final int number;
  final String text;

  Ayah({required this.number, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['numberInSurah'],
      text: json['text'],
    );
  }
}

class Surah {
  final int number;
  final String name;
  final List<Ayah> ayahs;

  Surah({required this.number, required this.name, required this.ayahs});

  factory Surah.fromJson(Map<String, dynamic> json) {
    var ayahsJson = json['ayahs'] as List;
    List<Ayah> ayahsList = ayahsJson.map((i) => Ayah.fromJson(i)).toList();

    return Surah(
      number: json['number'],
      name: json['name'],
      ayahs: ayahsList,
    );
  }
}
