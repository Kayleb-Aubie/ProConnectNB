import 'package:flutter/material.dart';
import '../../services/api.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String result = "Tester API";

  void callApi() async {
    Api api = Api();
    String response = await api.getUser();

    setState(() {
      result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Test")),
      body: Center(child: Text(result)),
      floatingActionButton: FloatingActionButton(
        onPressed: callApi,
        child: const Icon(Icons.send),
      ),
    );
  }
}