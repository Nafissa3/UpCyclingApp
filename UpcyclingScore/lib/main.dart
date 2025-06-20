import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'result_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFFF7F6),
        body: MyHomePage(),
        //body: ResultPage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 455,
          left: (MediaQuery.of(context).size.width - 360) / 2,
          child: SizedBox(
            width: 360,
            height: 90,
            child: const Center(
              child: Text(
                "Scannez votre emballage",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 191,
          left: (MediaQuery.of(context).size.width - 349) / 2,
          child: SizedBox(
            width: 349,
            height: 45,
            child: const Center(
              child: Text(
                "Votre assistant écoresponsable pour recycler & réutiliser intelligemment",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 122,
          left: (MediaQuery.of(context).size.width - 247) / 2,
          child: SizedBox(
            width: 247,
            height: 247,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),

        Positioned(
          top: 369,
          left: (MediaQuery.of(context).size.width - 76) / 2,
          child: SizedBox(
            width: 76,
            height: 74,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );
              },
              child: Image.asset('assets/images/bouton.png'),
            ),
          ),
        ),


      ],
    );
  }
}