// ignore_for_file: prefer_int_literals, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyApp());
}

const actions = <Widget>[
  Padding(
    padding: EdgeInsets.all(8.0),
    child: Icon(
      Icons.delete,
    ),
  ),
  Padding(
    padding: EdgeInsets.all(8.0),
    child: Icon(
      Icons.share,
    ),
  ),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Slidable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Closer closer = Closer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Slidable'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slidable(
              closer: closer,
              startActionPane: ActionPane(
                direction: Axis.horizontal,
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('$index'),
                      );
                    },
                  ),
                ),
              ),
              endActionPane: const ActionPane(
                direction: Axis.horizontal,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.amber,
                      Colors.blueGrey,
                    ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: actions,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text("Let's not be ridiculously\npretentious... Just moderately smug."),
                subtitle: Text('Extra words.'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          closer.close();
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  @override
  void dispose() {
    closer.dispose();
    super.dispose();
  }
}

class Closer extends ChangeNotifier {
  void close() => notifyListeners();
}
