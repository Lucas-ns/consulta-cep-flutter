import 'package:consulta_cep/pages/cep_home_page.dart';
import 'package:consulta_cep/pages/lista_cep_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController(initialPage: 0);
  int _posicaoPagina = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _posicaoPagina = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _posicaoPagina = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Consultar CEP"),
      ),
      body: Column(
        children: [
          Expanded(
              child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: const [
              CepHomePage(),
              ListaCepPage(),
            ],
          )),
          BottomNavigationBar(
              currentIndex: _posicaoPagina,
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                    label: "Mostrar CEP", icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: "Lista de CEPs", icon: Icon(Icons.list)),
              ]),
        ],
      ),
    ));
  }
}
