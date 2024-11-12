import 'package:consulta_cep/model/cep_model.dart';
import 'package:dio/dio.dart';

class ViaCepRepository {
  final Dio _dio = Dio();
  ViaCepModel cepModel = ViaCepModel();

  Future<ViaCepModel> getCep(String cep) async {
    final response = await _dio.get("https://viacep.com.br/ws/$cep/json/");
    return ViaCepModel.fromJson(response.data);
  }
}
