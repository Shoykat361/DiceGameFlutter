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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.russoOneTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

enum GameStatus{
  running,
  over,
  none

}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameStatus gameStatus = GameStatus.none;
  static const win = 'You Win !!!';
  static const lost = 'You Lost !!!';
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
  bool hasTrget = false,shouldShowBoard = false;
  final random = Random.secure();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text('Luck Checker'),
      ),
      body:  Center(

        child: shouldShowBoard
            ? Column(
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
                      Image.asset(
                        diceList[firstIndex],
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        diceList[secontIndex],
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                  Text('Dice Sum = $diceSum'),
                  if (hasTrget)
                    Text(
                        'your Target  $target\n keep Rolling to match the $target'),
                  if(gameStatus == GameStatus.over)
                    Text(
                    result,
                    style: TextStyle(fontSize: 50),
                  ),
                  if(gameStatus  ==GameStatus.running)
                    ShakingButton(
                        label: 'ROLL',
                    onPressed: rollTheDice,
                  ),
                  const SizedBox(height: 10),
                  if(gameStatus == GameStatus.over)
                    diceButton(
                    onPressed: reSet,
                    lable: 'Reset',
                  ),
                ],
              )
            : startPage(onStart: startGame,),
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
      result = win;
      gameStatus =GameStatus.over;
    }else if(diceSum == 7 ){
      result = lost;
      gameStatus =GameStatus.over;
    }
  }

  void checkFirstRoll() {
    if(diceSum == 7 || diceSum == 11){
      result = win;
      gameStatus =GameStatus.over;
    }else if (diceSum == 2 || diceSum ==3 || diceSum ==12){
      result = lost;
      gameStatus =GameStatus.over;
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
      shouldShowBoard = false;
      gameStatus = GameStatus.none;
    });
  }

  void startGame() {
    setState(() {
      shouldShowBoard =true;
      gameStatus = GameStatus.running;
    });
  }
}

class startPage extends StatelessWidget {
  final VoidCallback onStart;
  const startPage({super.key,required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/dicelogo.jpg',width: 150,height: 150,),
        RichText(
          text: TextSpan(
            text: 'MEGA',style: GoogleFonts.russoOne().copyWith(
            color: Colors.red,
            fontSize: 40,
          ),children: [
            TextSpan(
              text: 'Roll',
              style: GoogleFonts.russoOne().copyWith(
                color: Colors.black12,
                fontSize: 45,
              ),
            ),TextSpan(
              text: 'Event',
              style: GoogleFonts.russoOne().copyWith(
                color: Colors.blue,
                fontSize: 42,
              ),
            ),
          ]
          )
        ),
        Spacer(),
        diceButton(lable: 'START', onPressed: onStart),
        diceButton(lable: 'How To Play', onPressed: (){
          showInstaction(context);
        }),
      ],
    );
  }

  void showInstaction(BuildContext context) {
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Instraction'),
      content: Text(gameRules),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Close'),)
      ],
    ));
  }
}

class diceButton extends StatelessWidget {
  final String lable ;
  final VoidCallback onPressed;

  const diceButton({super.key,required this.lable,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(lable,style: TextStyle(fontSize: 20,color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}


class ShakingButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const ShakingButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  _ShakingButtonState createState() => _ShakingButtonState();
}

class _ShakingButtonState extends State<ShakingButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              _animationController.forward();
              widget.onPressed();
            },
            child: Text(
              widget.label,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}




const gameRules ='''
* AT THE FIRST ROLL, IF THE DICE SUM IS 7 OR 11, YOU WIN!
* AT THE FIRST ROLL, IF THE DICE SUM IS 2, 3 OR 12, YOU LOST!!
* AT THE FIRST ROLL, IF THE DICE SUM IS 4, 5, 6, 8, 9, 10, THEN THIS DICE SUM WILL BE YOUR TARGET POINT, AND KEEP ROLLING
* IF THE DICE SUM MATCHES YOUR TARGET POINT, YOU WIN!
* IF THE DICE SUM IS 7, YOU LOST!!
''';

