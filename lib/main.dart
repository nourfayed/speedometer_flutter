import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Your Speed Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _from10to30 = 0;
  int _from30to10 = 0;
  int _speed = 0;
  int reached30 = 0;
  var rng = new Random();
  AccelerometerEvent _event;


  void _getSpeed(){
     //read from sensor
     int rnd=((_event.y).round()).abs() * 10;
     //limit speed from 10 to 30
     if(rnd > 30) _speed = 30;
     else if(rnd < 10) _speed = 10;
     else _speed = rnd;

  }

  //increment _from10to30 till it reaches 30
  void _incrementfrom10to30(){

    if(reached30 == 0){
      _from10to30++;
      if( _speed == 30 ){
        reached30=1;
        _from10to30=0;
      }
    }
  }

  //increment _from30to10 till it reaches 10
  void _incrementfrom30to10(){
    if(reached30== 1 ){
      _from30to10++;
      if(_speed<=10){
        reached30=0;
        _from30to10=0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
     _event = event;
    });
    Timer _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _getSpeed();
        _incrementfrom10to30();
        _incrementfrom30to10();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        //backgroundColor: Color(0xFFFF1744),
        backgroundColor:Colors.greenAccent,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
       child:Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child:Text(
                ' Current Speed',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '$_speed',
              style: TextStyle(height: 1, fontSize: 70 ,color: Colors.greenAccent),
            ),
            Text(
              'kmh',
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,20),
              child:Text(
                ' From 10 to 30 ',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Text(
              '$_from10to30',
              style: TextStyle(height: 1, fontSize: 50,color: Colors.greenAccent),
            ),
            Text(
              'Seconds',
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,20),
              child:Text(
                ' From 30 to 10 ',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Text(
              '$_from30to10',
              style: TextStyle(height: 1, fontSize: 50,color: Colors.greenAccent),
            ),
            Text(
              'Seconds',
            ),
          ],
        ),
     ),

    );
  }
}
