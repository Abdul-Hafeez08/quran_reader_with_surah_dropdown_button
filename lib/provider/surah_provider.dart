import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran_reader/model/surah.dart';

class SurahProvider with ChangeNotifier {
  List<Surah> surahs = [];
  int currentSurahIndex = 0;
  int ayahPageIndex = 0;
  bool isLoading = false;

  Surah? get currentSurah =>
      surahs.isNotEmpty ? surahs[currentSurahIndex] : null;
  List<Ayah> get ayahsPage =>
      currentSurah?.ayahs.skip(ayahPageIndex * 8).take(8).toList() ?? [];

  Future<void> fetchSurahs() async {
    isLoading = true;
    notifyListeners();

    final response = await http
        .get(Uri.parse('https://api.alquran.cloud/v1/quran/ur.jhaladhry'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['surahs'];
      surahs = (data as List).map((item) => Surah.fromJson(item)).toList();
    }

    isLoading = false;
    notifyListeners();
  }

  void nextPage() {
    if (ayahPageIndex * 8 + 8 < currentSurah!.ayahs.length) {
      ayahPageIndex++;
    } else {
      nextSurah();
    }
    notifyListeners();
  }

  void nextSurah() {
    if (currentSurahIndex < surahs.length - 1) {
      currentSurahIndex++;
      ayahPageIndex = 0;
    }
    notifyListeners();
  }

  void setSurah(int index) {
    currentSurahIndex = index;
    ayahPageIndex = 0;
    notifyListeners();
  }
}
