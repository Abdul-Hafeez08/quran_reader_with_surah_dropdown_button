import 'package:flutter_test/flutter_test.dart';
import 'package:quran_reader/provider/surah_provider.dart';

void main() {
  group('SurahProvider Tests', () {
    test('Initial Surahs should be empty', () {
      final provider = SurahProvider();

      expect(provider.surahs, isEmpty);
    });

    test('fetchSurahs should populate the surahs list', () async {
      final provider = SurahProvider();

      await provider.fetchSurahs();

      expect(provider.surahs, isNotEmpty);
    });

    test('nextPage should increment the ayahPageIndex', () {
      final provider = SurahProvider();

      provider.setSurah(0);
      provider.fetchSurahs();

      expect(provider.ayahPageIndex, 0);

      provider.nextPage();

      expect(provider.ayahPageIndex, 1);
    });
  });
}
