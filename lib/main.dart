import 'package:flutter/material.dart';

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
        body: FormContainer(),
      ),
    );
  }
}

class FormContainer extends StatelessWidget {
  const FormContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.all(32),
      child: Container(
        color: Colors.red,
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
                  color: Colors.green,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.pink,
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: const TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Input Judul'
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: const TextField(
                              decoration: InputDecoration(
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
                  color: Colors.white,
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
                        child: const MethodRadio(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {  },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(88, 50)
                          ),
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
                        child: const Text(
                          "Hasil 1, Hasil 2, Hasil 3, Hasil 4, Hasil 5",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
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

class MethodRadio extends StatefulWidget {
  const MethodRadio({Key? key}) : super(key: key);

  @override
  State<MethodRadio> createState() => _MethodRadioState();
}

class _MethodRadioState extends State<MethodRadio> {
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
                  onChanged: (KeyphraseExtractionMethod? value) {
                    setState(() {
                      _keyphraseExtractionMethod = value;
                    });
                  },
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
                  onChanged: (KeyphraseExtractionMethod? value) {
                    setState(() {
                      _keyphraseExtractionMethod = value;
                    });
                  },
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
                  onChanged: (KeyphraseExtractionMethod? value) {
                    setState(() {
                      _keyphraseExtractionMethod = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('TopicRank'),
                leading: Radio<KeyphraseExtractionMethod>(
                  value: KeyphraseExtractionMethod.topicRank,
                  groupValue: _keyphraseExtractionMethod,
                  onChanged: (KeyphraseExtractionMethod? value) {
                    setState(() {
                      _keyphraseExtractionMethod = value;
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

enum KeyphraseExtractionMethod { yake, textRank, positionRank, topicRank }
