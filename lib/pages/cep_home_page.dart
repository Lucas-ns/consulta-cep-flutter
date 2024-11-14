import 'package:consulta_cep/model/endereco_model.dart';
import 'package:consulta_cep/repository/cep_back4app_repository.dart';
import 'package:consulta_cep/service/cep_service.dart';
import 'package:flutter/material.dart';

class CepHomePage extends StatefulWidget {
  const CepHomePage({super.key});

  @override
  State<CepHomePage> createState() => _CepHomePageState();
}

class _CepHomePageState extends State<CepHomePage> {
  final _cepController = TextEditingController();
  var cepBack4appRepository = CepBack4appRepository();
  var endereco = Endereco();
  var cepService = CepService();
  var loading = false;

  void _carregarCEP(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      setState(() {
        loading = true;
      });
      endereco = await cepService.getCep(cep);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _addCep() async {
    final cep = _cepController.text.trim();

    if (cep.isNotEmpty) {
      try {
        await cepBack4appRepository.inserirNovoCep(endereco);
        _cepController.clear();
        _carregarCEP(cep);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP adicionado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Digite o CEP",
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
              keyboardType: const TextInputType.numberWithOptions(),
              controller: _cepController,
              onChanged: (String value) {
                _carregarCEP(value);
              }),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          endereco.logradouro ?? "",
          style: const TextStyle(fontSize: 16),
        ),
        Text("${endereco.bairro ?? ""} - ${endereco.uf ?? ""}",
            style: const TextStyle(fontSize: 16)),
        Text("CEP: ${endereco.cep ?? ""}",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: _addCep,
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)),
          child: const Text(
            "Adicionar CEP",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    ));
  }
}
