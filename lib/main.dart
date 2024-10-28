// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/surah_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SurahProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurahScreen(),
    );
  }
}

class SurahScreen extends StatefulWidget {
  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SurahProvider>(context, listen: false).fetchSurahs();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurahProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('surah Reader'),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<int>(
                  value: provider.currentSurahIndex,
                  items: provider.surahs
                      .asMap()
                      .entries
                      .map((e) => DropdownMenuItem<int>(
                            value: e.key,
                            child: Text(e.value.name),
                          ))
                      .toList(),
                  onChanged: (index) {
                    if (index != null) provider.setSurah(index);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.ayahsPage.length,
                    itemBuilder: (context, index) {
                      final ayah = provider.ayahsPage[index];
                      return ListTile(
                        title: Text(ayah.text),
                        subtitle: Text('Ayah ${ayah.number}'),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: provider.ayahPageIndex > 0
                          ? () {
                              provider.ayahPageIndex--;
                              provider.notifyListeners();
                            }
                          : null,
                      child: Text("Previous"),
                    ),
                    ElevatedButton(
                      onPressed: provider.nextPage,
                      child: Text("Next"),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
