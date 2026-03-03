import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              // child:
              // Container(
              // decoration: BoxDecoration(                           // visu pour m'aider
              //   border: Border.all(color: Colors.red, width: 2),
              //   borderRadius: BorderRadius.circular(8),
              // ),
              child: Column(
                spacing: 60,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mot de passe généré",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IntrinsicWidth(
                    // (width: fit-content)
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
                            int length = int.tryParse(value) ?? 1;
                            print("Nouvelle longueur : $length");
                          },
                        ),
                        OptionCheckBox(
                          label: 'Minuscules',
                          value: _hasLower,
                          onChanged: (val) =>
                              setState(() => (_hasLower = val!)),
                        ),
                        OptionCheckBox(
                          label: 'Majuscules',
                          value: _hasUpper,
                          onChanged: (val) => setState(() => _hasUpper = val!),
                        ),
                        OptionCheckBox(
                          label: 'Chiffres',
                          value: _hasNumbers,
                          onChanged: (val) =>
                              setState(() => _hasNumbers = val!),
                        ),
                        OptionCheckBox(
                          label: 'Caractères spéciaux',
                          value: _hasSpecial,
                          onChanged: (val) =>
                              setState(() => (_hasSpecial = val!)),
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
                          print("azAZ".codeUnits);
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
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Icon(Icons.copy),
                            SizedBox(width: 8),
                            Text('Copier'),
                          ],
                        ),
                      ),
                      // MyLabeledCheckbox(label: "Test", value: true, onChanged: (val) {})
                    ],
                  ),
                ],
              ),
              // ),
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
