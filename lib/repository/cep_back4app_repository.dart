import 'package:consulta_cep/model/endereco_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CepBack4appRepository {
  final _dio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL'), headers: {
    'X-Parse-Application-Id': dotenv.get('APPLICATION_ID'),
    'X-Parse-REST-API-Key': dotenv.get('RESTAPI_KEY'),
    'Content-Type': "application/json"
  }));

  CepBack4appRepository();

  Future<EnderecosModel> obterCEPs() async {
    var response = await _dio.get('/Cep');
    return EnderecosModel.fromJson(response.data);
  }

  Future<bool> verificarCepExistente(String cep) async {
    try {
      final response =
          await _dio.get('/Cep', queryParameters: {'where': '{"cep": "$cep"}'});
      final results = response.data['results'] as List;
      return results.isNotEmpty;
    } on DioException catch (e) {
      throw Exception('Erro ao verificar o CEP: ${e.message}');
    }
  }

  Future<void> inserirNovoCep(Endereco cepModel) async {
    try {
      bool response = await verificarCepExistente(cepModel.cep ?? "");

      if (response) {
        print('Este CEP já está cadastrado.');
      } else {
        await _dio.post('/Cep', data: cepModel.toCreateJson());
        print('Novo CEP adicionado com sucesso.');
      }
    } catch (e) {
      print('Erro ao inserir o CEP: $e');
      rethrow;
    }
  }

  Future<void> editarCep(Endereco cepModel) async {
    try {
      await _dio.put("/Cep/${cepModel.objectId}",
          data: cepModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletarCep(String objectId) async {
    try {
      await _dio.delete("/Cep/$objectId");
    } on DioException catch (e) {
      throw Exception('Erro ao deletar o CEP: ${e.message}');
    }
  }
}
