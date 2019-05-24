import 'package:flutter/material.dart';
import 'package:easy_blocs/easy_blocs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestBarScreen(),
    );
  }
}

class TestBarScreen extends StatefulWidget {
  @override
  _TestBarScreenState createState() => _TestBarScreenState();
}

class _TestBarScreenState extends State<TestBarScreen> {
  PageConnector eventListener;
  List<int> values;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    values = List.generate(9, (index) => index);
    eventListener = PageConnector(onPage: _listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ScrollController();
    eventListener.controller = _controller;
  }

  _listener(int currentPage) {
    print(currentPage);
    print(values.length);
    setState(() {
      values = List.generate(currentPage*5, (index) => index);
      eventListener.nextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        controller: _controller,
        children: values.map((index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Value: $index", style: Theme
                .of(context)
                .textTheme
                .display2,),
          );
        }).toList(),
      ),
    );
  }
}