import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smartAlacena',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 85, 107, 47), 
        ),
      ),
      home: const MyHomePage(title: 'SmartAlacena'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> listItems = ["Aceite: No hay", "Harina: Si hay", "Pimienta: Si hay", "Sal: No hay", "Sazonador: No hay"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 231, 198),
                    foregroundColor: Colors.black,
                    shadowColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    minimumSize: const Size(250, 70), 
                  ),
              child: const Text("Inspeccionar", style: TextStyle(fontSize: 24),),
            ),
            const SizedBox(height: 30),
            Container(
              width: 250.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.circle, size: 15.0),
                    title: Text(
                      listItems[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
