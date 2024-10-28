import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/surah_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SurahProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        backgroundColor: Colors.blue,
        title: Text(
          'Surah Reader',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      return Column(
                        children: [
                          ListTile(
                            title: Text(ayah.text),
                            subtitle: Text('Ayah ${ayah.number}'),
                          ),
                          if (index < provider.ayahsPage.length - 1) Divider(),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: provider.nextPage,
                      child: Text(
                        "Next",
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10)
              ],
            ),
    );
  }
}
