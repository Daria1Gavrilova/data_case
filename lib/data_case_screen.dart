import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class DataCounter extends StatelessWidget {
  const DataCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CounterData(title: "Задание 3.1", storage: CounterStorage()),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try{
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch(e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class CounterData extends StatefulWidget {
  const CounterData ({Key? key, required this.title, required this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  _CounterDataState createState() => _CounterDataState();
}

class _CounterDataState extends State<CounterData> {
  int _counter = 0;
  int _counter2 = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter2 = value;
      });
    });
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0)+1;
      prefs.setInt('counter', _counter);
    });
  }

  Future<File> _incrementCounter2() {
    setState(() {
      _counter2++;
    });
    return widget.storage.writeCounter(_counter2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(90),
        child: Center(
          child: Column(
            children: [
              const Text("Счетчик shared_preferences"),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: _incrementCounter,
                        child: const Icon(Icons.add)
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text('$_counter', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text("Счетчик с записью в файл"),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: _incrementCounter2,
                        child: const Icon(Icons.add)
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text('$_counter2', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
