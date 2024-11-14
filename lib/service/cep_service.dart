import 'package:consulta_cep/model/endereco_model.dart';
import 'package:dio/dio.dart';

class CepService {
  final Dio _dio = Dio();

  Future<Endereco> getCep(String cep) async {
    final response = await _dio.get("https://viacep.com.br/ws/$cep/json/");

    if (response.statusCode == 200) {
      if (response.data.containsKey('erro')) {
        return Endereco();
      }
      return Endereco.fromJson(response.data);
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
}
