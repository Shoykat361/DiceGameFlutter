import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.russoOneTextTheme(),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String result = '';
  final diceList = [
    'images/dice1.jpg',
    'images/dice2.jpg',
    'images/dice3.png',
    'images/dice4.jpg',
    'images/dice5.png',
    'images/dice6.png',
  ];
  int firstIndex = 0;
  int secontIndex = 0,target = 0;
  int diceSum =0;
  bool hasTrget = false;
  final random = Random.secure();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
        title:  Text('Luck Checker'),
      ),
      body:  Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'My Dice Game',
              style: TextStyle(fontSize: 50),
            ),
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(diceList[firstIndex],height: 80,width: 80,),
                const SizedBox(width:10,),
                Image.asset(diceList[secontIndex],height: 80,width: 80,),

              ],
            ),
            Text('Dice Sum = $diceSum'),
            if(hasTrget)
              Text('your Target  $target\n keep Rolling to match the $target'),
            Text(result,style: TextStyle(fontSize: 50),),
            ElevatedButton(
                onPressed: rollTheDice,
                child: Text('Roll the dice'),),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: reSet,
                child: Text('Reset'),),


          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void rollTheDice() {
    setState(() {
      firstIndex = random.nextInt(6);
      secontIndex = random.nextInt(6);
      diceSum =firstIndex+secontIndex+2;
      if(hasTrget){
        checkTarget();

      }else{
        checkFirstRoll();
      }

    });
  }

  void checkTarget() {
    if(diceSum == target){
      result ='You Win !!!';
    }else if(diceSum == 7 ){
      result = 'You lost!!!';
    }
  }

  void checkFirstRoll() {
    if(diceSum == 7 || diceSum == 11){
      result = 'You Win the Game !!!';
    }else if (diceSum == 2 || diceSum ==3 || diceSum ==12){
      result = 'You Lost The Game !!!';
    }else{
      hasTrget = true;
      target =diceSum;
    }
  }

  void reSet() {
    setState(() {
      firstIndex =0;
      secontIndex =0;
      target = 0;
      hasTrget =false;
      diceSum =0;
      result ='';
    });
  }
}
