import 'package:flutter/material.dart';

class ListaCepPage extends StatefulWidget {
  const ListaCepPage({super.key});

  @override
  State<ListaCepPage> createState() => _ListaCepPageState();
}

class _ListaCepPageState extends State<ListaCepPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Lista de CEPs"),
      ),
      body: Container(),
    ));
  }
}
