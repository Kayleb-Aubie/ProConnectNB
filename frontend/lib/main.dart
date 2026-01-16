import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultat = "Appuyer sur un bouton pour appeler l'API";

  Future<void> callApiTest() async {
    final Api api = Api();
    final response = await api.getTest();

    setState(() {
      resultat = response;
    });
  }

  Future<void> callApiDB() async {
    final Api api = Api();
    final String response = await api.getTest();

    setState(() {
      resultat = response;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('API Testing')),
      body: Center(
        child: Text(
          resultat,
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),

      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: callApiTest,
            child: Icon(Icons.send),
          ),

          SizedBox(width: 12),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: callApiDB,
            child: Icon(Icons.air),
          ),
        ],

      ),

    );

  }

}
