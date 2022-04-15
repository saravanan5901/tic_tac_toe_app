import 'package:flutter/material.dart';
import 'package:tic_tac_toe_package/widgets/single_player.dart';
import 'package:tic_tac_toe_package/widgets/two_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            "Welcome to Tic Tac Toe!",
            style: TextStyle(fontSize: 20),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: const StadiumBorder(),
                  primary: Colors.green),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TwoPlayer()));
              },
              child: const Text(
                "Two player",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: const StadiumBorder(),
                  primary: Colors.green),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SinglePlayer()));
              },
              child: const Text(
                "Single player",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
