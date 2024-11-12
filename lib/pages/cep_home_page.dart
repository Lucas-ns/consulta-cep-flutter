import 'package:consulta_cep/model/cep_model.dart';
import 'package:consulta_cep/repository/viacep_repository.dart';
import 'package:flutter/material.dart';

class CepHomePage extends StatefulWidget {
  const CepHomePage({super.key});

  @override
  State<CepHomePage> createState() => _CepHomePageState();
}

class _CepHomePageState extends State<CepHomePage> {
  var cepController = TextEditingController();
  var viacepRepository = ViaCepRepository();
  var viacepModel = ViaCepModel();
  var loading = false;

  void _carregarCEP(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      setState(() {
        loading = true;
      });
      viacepModel = await viacepRepository.getCep(cep);
      if (viacepModel.cep == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CEP inserido não existe!")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("CEP inválido!")));
    }
    setState(() {
      loading = false;
    });
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
            controller: cepController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        loading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Text(viacepModel.logradouro ?? ""),
                  Text("${viacepModel.bairro ?? ""} - ${viacepModel.uf ?? ""}"),
                  Text("CEP: ${viacepModel.cep ?? ""}"),
                  TextButton(
                    child: const Text("Mostrar"),
                    onPressed: () {
                      _carregarCEP(cepController.text);
                    },
                  )
                ],
              )
      ]),
    ));
  }
}
