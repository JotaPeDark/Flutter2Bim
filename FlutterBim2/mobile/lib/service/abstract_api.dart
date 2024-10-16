import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _urlLocalHost = 'http://localhost:3000/transacoes';

  Future<List<dynamic>> getAll() async {
    var response = await http.get(Uri.parse(_urlLocalHost));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar transações');
    }
  }

  Future<void> create(Map<String, dynamic> newTransaction) async {
    var response = await http.post(
      Uri.parse(_urlLocalHost),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newTransaction),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar nova transação');
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('http://localhost:3000/transacoes/$id'), // Verifique se a rota está correta
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao atualizar a transação');
  }
}

  Future<void> delete(String id) async {
    var response = await http.delete(Uri.parse('$_urlLocalHost/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir transação');
    }
  }
}
