import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';


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
      home: App(),
    );
  }
}

const String FLAGS = "assets/img/flags/";

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final translationBloc = TranslatorBloc.of()..init(deviceLc: Locale('it'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TranslationButton(
            path: FLAGS,
          ),
        ],
      ),
      endDrawer: TranslationDrawer(
        locales:[Locale('it'), Locale('en')],
        path: FLAGS,
      ),
    );
  }
}
