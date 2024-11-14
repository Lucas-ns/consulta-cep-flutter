import 'package:consulta_cep/model/endereco_model.dart';
import 'package:consulta_cep/repository/cep_back4app_repository.dart';
import 'package:flutter/material.dart';

class ListaCepPage extends StatefulWidget {
  const ListaCepPage({super.key});

  @override
  State<ListaCepPage> createState() => _ListaCepPageState();
}

class _ListaCepPageState extends State<ListaCepPage> {
  late CepBack4appRepository cepBack4appRepository;
  var _enderecos = EnderecosModel([]);
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    cepBack4appRepository = CepBack4appRepository();
    carregarCEPs();
  }

  void carregarCEPs() async {
    setState(() {
      _isLoading = true;
    });
    _enderecos = await cepBack4appRepository.obterCEPs();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _editarCep(Endereco enderecoModel) async {
    final logradouroController =
        TextEditingController(text: enderecoModel.logradouro);
    final bairroController = TextEditingController(text: enderecoModel.bairro);
    final localidadeController =
        TextEditingController(text: enderecoModel.localidade);
    final ufController = TextEditingController(text: enderecoModel.uf);
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Editar CEP'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: logradouroController,
                    decoration: const InputDecoration(labelText: 'Logradouro'),
                  ),
                  TextField(
                    controller: bairroController,
                    decoration: const InputDecoration(labelText: 'Bairro'),
                  ),
                  TextField(
                    controller: localidadeController,
                    decoration: const InputDecoration(labelText: 'Localidade'),
                  ),
                  TextField(
                    controller: ufController,
                    decoration: const InputDecoration(labelText: 'UF'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () async {
                    enderecoModel.logradouro = logradouroController.text.trim();
                    enderecoModel.bairro = bairroController.text.trim();
                    enderecoModel.localidade = localidadeController.text.trim();
                    enderecoModel.uf = ufController.text.trim();

                    await cepBack4appRepository.editarCep(enderecoModel);
                    Navigator.pop(context);

                    carregarCEPs();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('CEP atualizado com sucesso!')),
                    );
                  },
                  child: const Text('Salvar'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Lista de CEPs"),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _enderecos.results.length,
                  itemBuilder: (_, index) {
                    var enderecoModel = _enderecos.results[index];
                    return Dismissible(
                        onDismissed: (direction) async {
                          await cepBack4appRepository
                              .deletarCep(enderecoModel.objectId!);
                        },
                        key: Key(enderecoModel.cep ?? ""),
                        child: ListTile(
                            trailing: InkWell(
                                onTap: () {
                                  _editarCep(enderecoModel);
                                },
                                child: const Icon(Icons.edit)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(enderecoModel.cep ?? ""),
                                Text(
                                    "${enderecoModel.logradouro} - ${enderecoModel.bairro}"),
                                Text(
                                    "${enderecoModel.estado} - ${enderecoModel.uf}"),
                              ],
                            )));
                  },
                )),
    );
  }
}
