import 'dart:convert';
import 'dart:async' as asyn;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Form(),
      ),
    );
  }
}

class Form extends StatefulWidget {
  const Form({Key? key}) : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  final TextEditingController _titleTextFieldController = TextEditingController();
  final TextEditingController _abstractTextFieldController = TextEditingController();
  asyn.Future<Keyphrases>? _futureKeyphrases;

  final List<String> _apiUrls = <String>[
    "YAKE",
    "TextRank",
    "http://127.0.0.1:5000",
    "TopicRank"
  ];
  
  String _apiUrl = "http://127.0.0.1:5000";
  String _title = "";
  String _abstract = "";

  void _onRadioSelected(KeyphraseExtractionMethod? methods) {
    if (methods != null) {
      setState(() {
        _apiUrl = _apiUrls.elementAt(methods.index);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      margin: const EdgeInsets.all(32),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(),
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: TextField(
                                controller: _titleTextFieldController,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _title = newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Input Judul'
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _abstractTextFieldController,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _abstract = newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Input Abstract'
                                ),
                                minLines: 16,
                                maxLines: 16,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: const TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Input Gold Keyphrase'
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                )
            ),
            Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 32),
                          child: const Text(
                            "Select Method",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: MethodSelection(
                            onMethodSelect: _onRadioSelected,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(88, 50)
                            ),
                            onPressed: () {
                              setState(() {
                                _futureKeyphrases = createListKeyphrase(_apiUrl, _title, _abstract);
                              });
                            },
                            child: const Text("Generate Keyphrase"),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 32),
                          child: const Text(
                            "Result : ",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 32),
                          child: (_futureKeyphrases == null) ?
                          const Text(
                            "No Result",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ) : FutureBuilder<Keyphrases>(
                              future: _futureKeyphrases,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                        "${snapshot.data!.keyphrases}",
                                      style: const TextStyle(
                                        fontSize: 18
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError){
                                  return Center(
                                    child: Text("${snapshot.error}"),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }
                          )
                        ),
                      ],
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}

enum KeyphraseExtractionMethod { yake, textRank, positionRank, topicRank }

class MethodSelection extends StatefulWidget {
  const MethodSelection({Key? key, required this.onMethodSelect}) : super(key: key);
  final void Function(KeyphraseExtractionMethod?) onMethodSelect;

  @override
  State<MethodSelection> createState() => _MethodSelectionState();
}

class _MethodSelectionState extends State<MethodSelection> {
  KeyphraseExtractionMethod? _keyphraseExtractionMethod = KeyphraseExtractionMethod.positionRank;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ListTile(
                title: const Text('YAKE'),
                leading: Radio<KeyphraseExtractionMethod>(
                  value: KeyphraseExtractionMethod.yake,
                  groupValue: _keyphraseExtractionMethod,
                  onChanged: (KeyphraseExtractionMethod? method) {
                    widget.onMethodSelect(method);
                    if (method != null) {
                      setState(() {
                        _keyphraseExtractionMethod = method;
                      });
                    }
                  }
                ),
              ),
              ListTile(
                title: const Text(
                  'TextRank',
                  softWrap: false,
                ),
                leading: Radio<KeyphraseExtractionMethod>(
                  value: KeyphraseExtractionMethod.textRank,
                  groupValue: _keyphraseExtractionMethod,
                  onChanged: (KeyphraseExtractionMethod? method) {
                    widget.onMethodSelect(method);
                    if (method != null) {
                      setState(() {
                        _keyphraseExtractionMethod = method;
                      });
                    }
                  }
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ListTile(
                title: const Text('PositionRank'),
                leading: Radio<KeyphraseExtractionMethod>(
                  value: KeyphraseExtractionMethod.positionRank,
                  groupValue: _keyphraseExtractionMethod,
                  onChanged: (KeyphraseExtractionMethod? method) {
                    widget.onMethodSelect(method);
                    if (method != null) {
                      setState(() {
                        _keyphraseExtractionMethod = method;
                      });
                    }
                  }
                ),
              ),
              ListTile(
                title: const Text('TopicRank'),
                leading: Radio<KeyphraseExtractionMethod>(
                  value: KeyphraseExtractionMethod.topicRank,
                  groupValue: _keyphraseExtractionMethod,
                  onChanged: (KeyphraseExtractionMethod? method) {
                    widget.onMethodSelect(method);
                    if (method != null) {
                      setState(() {
                        _keyphraseExtractionMethod = method;
                      });
                    }
                  }
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

asyn.Future<Keyphrases> createListKeyphrase(String url, String title, String abstract) async {
  final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'abstract': abstract
      })
  );
  if (response.statusCode == 200) {
    debugPrint("test : ${jsonDecode(response.body)}");
    Keyphrases test2 = Keyphrases.fromJson(jsonDecode(response.body));
    debugPrint("test 2 : ${test2.keyphrases.runtimeType}");
    return Keyphrases.fromJson(jsonDecode(response.body));
  } else {
    debugPrint("gagal");
    throw Exception('Failed to generate keyphrases');
  }
}

class Keyphrases {
  List<dynamic> keyphrases;

  Keyphrases({required this.keyphrases});

  factory Keyphrases.fromJson(Map<String, dynamic> json) {
    return Keyphrases(keyphrases: json['keyphrases']);
  }
}