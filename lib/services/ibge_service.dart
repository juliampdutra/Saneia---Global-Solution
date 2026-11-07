import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/neighborhood.dart';
import 'api_exception.dart';

/// Consome a API REST de localidades do IBGE.
/// Endpoint: GET /api/v1/localidades/municipios/{id}/distritos
class IbgeService {
  static const String baseUrl =
      'https://servicodados.ibge.gov.br/api/v1/localidades';

  /// Código IBGE do município de São Paulo.
  static const int saoPauloId = 3550308;

  Future<List<Neighborhood>> getNeighborhoods() async {
    final uri = Uri.parse('$baseUrl/municipios/$saoPauloId/distritos');

    final response = await _get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'Erro ao buscar os bairros (código ${response.statusCode}).',
      );
    }

    try {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));

      final neighborhoods =
          jsonList.map((json) => Neighborhood.fromJson(json)).toList();

      neighborhoods.sort((a, b) => a.name.compareTo(b.name));

      return neighborhoods;
    } catch (_) {
      throw const ApiException('Os dados recebidos estão em formato inválido.');
    }
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      return await http.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException(
        'O servidor demorou para responder. Tente novamente.',
      );
    } catch (_) {
      throw const ApiException(
        'Não foi possível conectar. Verifique sua internet.',
      );
    }
  }
}
