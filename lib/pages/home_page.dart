import 'dart:convert';

import 'package:desafio_fazpay/util/activities_list.dart';
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

  List activitiesList = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _saveActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(activitiesList);
    await prefs.setString('listaAtividades', encodedData);
  }

  Future<void> _loadActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('listaAtividades');
    if (encodedData != null) {
      setState(() {
        activitiesList = List<dynamic>.from(jsonDecode(encodedData));
      });
    }
  }

  void checkBoxChanged(int index) {
    setState(() {
      activitiesList[index][1] = !activitiesList[index][1];
    });
    _saveActivities();
  }

  void saveNewActivity() {
    setState(() {
      activitiesList.add([textController.text, false]);
    });
    _saveActivities();
  }

  void deleteActivity(int index) {
    setState(() {
      activitiesList.removeAt(index);
    });
    _saveActivities();
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
                      if (textController.text.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Aviso'),
                              content: const Text(
                                  'Por favor, insira uma atividade!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        saveNewActivity();
                        Navigator.pop(context);
                        textController.clear();
                      }
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
        itemCount: activitiesList.length,
        itemBuilder: (BuildContext context, index) {
          return ActivitiesList(
            nameActivity: activitiesList[index][0],
            activityCompleted: activitiesList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (value) => deleteActivity(index),
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
