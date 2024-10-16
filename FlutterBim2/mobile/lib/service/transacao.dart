import 'package:flutter/material.dart';
import 'package:mobile/screen/formulario.dart';
import 'package:mobile/service/abstract_api.dart';

class TransacaoPage extends StatefulWidget {
  const TransacaoPage({super.key});

  @override
  _TransacaoPageState createState() => _TransacaoPageState();
}

class _TransacaoPageState extends State<TransacaoPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> futureTransacoes;

  @override
  void initState() {
    super.initState();
    futureTransacoes = apiService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureTransacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final transacoes = snapshot.data!;
            return ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transacoes[index]['nome']),
                  subtitle: Text('Valor: ${transacoes[index]['Valor']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // Abre o formulário de edição com dados atuais da transação
                          final updatedTransaction = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormularioScreen(
                                transacao: transacoes[index], // Passa a transação atual
                              ),
                            ),
                          );

                          // Se houver alteração, atualiza a transação
                          if (updatedTransaction != null) {
                            try {
                              await apiService.update(
                                transacoes[index]['id'],
                                updatedTransaction,
                              );
                              setState(() {
                                futureTransacoes = apiService.getAll(); // Atualiza a lista
                              });
                            } catch (e) {
                              print('Erro ao atualizar: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao atualizar: $e')),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await apiService.delete(transacoes[index]['id']);
                          setState(() {
                            futureTransacoes = apiService.getAll(); // Atualiza a lista
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de formulário
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioScreen()),
          ).then((newTransaction) async {
            if (newTransaction != null) {
              ApiService apiService = ApiService();
              try {
                await apiService.create(newTransaction);
                setState(() {
                  futureTransacoes = apiService.getAll();
                });
              } catch (e) {
                print('Erro ao criar transação: $e');
              }
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
