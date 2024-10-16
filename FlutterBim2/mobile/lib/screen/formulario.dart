import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  final Map<String, dynamic>? transacao; // Recebe a transação como argumento

  const FormularioScreen({Key? key, this.transacao}) : super(key: key);

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _valorController;

  @override
  void initState() {
    super.initState();

    // Inicializa os campos com os valores da transação, se disponíveis
    _nomeController = TextEditingController(
      text: widget.transacao != null ? widget.transacao!['nome'] : '',
    );
    _valorController = TextEditingController(
      text: widget.transacao != null ? widget.transacao!['Valor'].toString() : '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transacao != null ? 'Editar Transação' : 'Nova Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Retorna os dados atualizados
                    Navigator.pop(context, {
                      'nome': _nomeController.text,
                      'Valor': int.parse(_valorController.text),
                    });
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
