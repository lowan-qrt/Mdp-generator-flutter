import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Générateur de mot de passe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: const MyHomePage(title: 'Générateur de mot de passe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  bool _hasLower = true;
  bool _hasUpper = false;
  bool _hasNumbers = false;
  bool _hasSpecial = false;
  int _length = 12;

  String _generatedPwd = '';

  /// Plages de caractères à utiliser
  List<List<int>> getSelectedCharRanges() {
    List<List<int>> ranges = [];
    if (_hasLower) ranges.add([97, 122]); // a-z
    if (_hasUpper) ranges.add([65, 90]); // A-Z
    if (_hasNumbers) ranges.add([48, 57]); // 0-9
    if (_hasSpecial) {
      ranges.addAll([
        [33, 47], // !"#$%&'()*+,-./
        [58, 64], // :;<=>?@
        [91, 96], // [\]^_`
        [123, 126], // {|}~
      ]);
    }
    return ranges;
  }

  String generatePwd(int nbChars) {
    List<List<int>> ranges = getSelectedCharRanges();
    if (ranges.isEmpty) return '';

    Random rnd = Random.secure();

    List<int> chars = [];

    for (final range in ranges) {
      final codeUnit = range[0] + rnd.nextInt(range[1] - range[0] + 1);
      chars.add(codeUnit);
    }

    final remaining = nbChars - chars.length;

    for (int i = 0; i < remaining; ++i) {
      final range = ranges[rnd.nextInt(ranges.length)];
      final codeUnit = range[0] + rnd.nextInt(range[1] - range[0] + 1);
      chars.add(codeUnit);
    }

    chars.shuffle(rnd);

    return String.fromCharCodes(chars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Bienvenue sur l’application : générez facilement un mot de passe sécurisé en un clic !',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 60,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _generatedPwd.isNotEmpty ? _generatedPwd : "Mot de passe généré",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "Options de sécurité",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Longueur",
                            hintText: "Ex: 12",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _length = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                        OptionCheckBox(
                          label: 'Minuscules',
                          value: _hasLower,
                          onChanged: (value) =>
                              setState(() => (_hasLower = value!)),
                        ),
                        OptionCheckBox(
                          label: 'Majuscules',
                          value: _hasUpper,
                          onChanged: (value) =>
                              setState(() => _hasUpper = value!),
                        ),
                        OptionCheckBox(
                          label: 'Chiffres',
                          value: _hasNumbers,
                          onChanged: (value) =>
                              setState(() => _hasNumbers = value!),
                        ),
                        OptionCheckBox(
                          label: 'Caractères spéciaux',
                          value: _hasSpecial,
                          onChanged: (value) =>
                              setState(() => (_hasSpecial = value!)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final ranges = getSelectedCharRanges();
                          if (_length < ranges.length) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Longueur insuffisante pour couvrir tous les types sélectionnés."),
                              ),
                            );
                            return;
                          }
                          final pwd = generatePwd(_length);
                          setState(() {
                            _generatedPwd = pwd;
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.auto_awesome),
                            SizedBox(width: 8),
                            Text('Générer'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_generatedPwd.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: _generatedPwd));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Mot de passe copié dans le presse-papiers !"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Aucun mot de passe à copier."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.copy),
                            SizedBox(width: 8),
                            Text('Copier'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class OptionCheckBox extends StatelessWidget {
  const OptionCheckBox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: Text(label),
      onChanged: onChanged,
    );
  }
}
