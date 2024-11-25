import 'dart:convert';

import 'package:desafio_fazpay/util/lista_atividades.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  List listaAtividades = [];

  @override
  void initState() {
    super.initState();
    _carregarAtividades();
  }

  Future<void> _salvarAtividades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(listaAtividades);
    await prefs.setString('listaAtividades', encodedData);
  }

  Future<void> _carregarAtividades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('listaAtividades');
    if (encodedData != null) {
      setState(() {
        listaAtividades = List<dynamic>.from(jsonDecode(encodedData));
      });
    }
  }

  void checkBoxChanged(int index) {
    setState(() {
      listaAtividades[index][1] = !listaAtividades[index][1];
    });
    _salvarAtividades();
  }

  void salvarNovaAtividade() {
    setState(() {
      listaAtividades.add([textController.text, false]);
    });
    _salvarAtividades();
  }

  void deletarAtividade(int index) {
    setState(() {
      listaAtividades.removeAt(index);
    });
    _salvarAtividades();
  }

  void _showInputModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Insira uma atividade',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Adicione nova atividade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      salvarNovaAtividade();
                      Navigator.pop(context);
                      textController.clear();
                    },
                    child: const Text('OK'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: listaAtividades.length,
        itemBuilder: (BuildContext context, index) {
          return ListaAtividades(
            nomeAtividade: listaAtividades[index][0],
            atividadeCompleta: listaAtividades[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (value) => deletarAtividade(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade200,
          onPressed: () {
            _showInputModal(context);
          },
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}
