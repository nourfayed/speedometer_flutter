import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';

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
              primarySwatch: Colors.green,
               visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Your Speed Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _from10to30 = 0;
  int _from30to10 = 0;
  int _speed = 0;
  int reached30 = 0;
  AccelerometerEvent _event;
  double _curSpeed;


  void _getSpeed()   {

    var geolocator = Geolocator().getPositionStream(LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10)).listen((position) {
      _curSpeed = position.speed; // this is your speed
    });
    if(_curSpeed != null)
   {
     _speed=(_curSpeed*3.6).round(); //to convert to km/hr
   }
    print(_speed);
  }

  //increment _from10to30 till it reaches 30
  void _incrementfrom10to30(){

    if(reached30 == 0){
      _from10to30++;
      if( _speed >= 30 ){
        reached30=1;
        _from10to30=0;
      }
    }
  }

  //increment _from30to10 till it reaches 10
  void _incrementfrom30to10(){
    if(reached30 == 1 ){
      _from30to10++;
      if(_speed<=10){
        reached30=0;
        _from30to10=0;
      }
    }
  }

  @override
  void initState()  {
    super.initState();

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
     // resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        //backgroundColor: Color(0xFFFF1744),
        backgroundColor:Colors.greenAccent,
      ),



      body: new Container(
        child: ListView(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0,20,0,20),
              child:Text(
                ' Current Speed',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child:Text(
                ' $_speed',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 70 ,color: Colors.greenAccent),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child:Text(
                ' kmh',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 20 ),
              ),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child:Text(
                '$_from10to30',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 50,color: Colors.greenAccent),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child:Text(
                'Seconds',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,20),
              child:Text(
                '$_from30to10',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle( fontSize: 50,color: Colors.greenAccent),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child:Text(
                'Seconds',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
            ),

          ],
        ),
     ),

    );
  }
}
