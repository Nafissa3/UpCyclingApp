import 'dart:io';
import 'package:flutter/material.dart';
import 'scan_page.dart';
import 'main.dart';

class ResultPage extends StatelessWidget {
  final File photoFile;
  final Map<String, dynamic> resultData; // Pour les données reçues du backend

  const ResultPage({
    super.key,
    required this.photoFile,
    required this.resultData,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final String score = resultData['final_score']?.toString() ?? 'Non disponible';
    final List<dynamic> materials = resultData['materials'] ?? [];
    final List<dynamic> suggestions = resultData['suggestions'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF4EFEF),
      body: Stack(
        children: [
          // Barre verte
          Positioned(
            top: 43,
            left: 0,
            right: 0,
            child: Container(
              height: 72,
              color: const Color(0xFF5AC46C),
            ),
          ),

          // Texte de titre
          Positioned(
            top: 57,
            left: 116,
            child: const SizedBox(
              width: 237,
              height: 44,
              child: Text(
                'Scan du produit',
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontWeight: FontWeight.bold,
                  fontSize: 29,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Bouton retour
          Positioned(
            top: 57,
            left: 20,
            width: 45,
            height: 44,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/images/flecheretour2.png'),
            ),
          ),

          // Carré blanc avec rectangle dedans
          Positioned(
            top: 123,
            left: (screenWidth - 350) / 2,
            child: SizedBox(
              width: 350,
              height: 604,
              child: Stack(
                children: [
                  Image.asset('assets/images/carreblanc.png'),

                  // Ici on affiche la photo avec arrondi
                  Positioned(
                    top: 22,
                    left: 18,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        photoFile,
                        width: 77.89,
                        height: 113,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //rectangle gris
                  Positioned(
                    top: 32,
                    right: 13,
                    child: SizedBox(
                      width: 223,
                      height: 94,
                      child: Stack(
                        children: [
                          Image.asset('assets/images/rectangle.png'),
                          Positioned(
                            top: 17,
                            left: 26,
                            child: SizedBox(
                              width: 200,
                              height: 28,
                              child: Text(
                                'Upcycling-score :',
                                style: const TextStyle(
                                  fontFamily: 'InriaSerif',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 26,
                            child: Text(
                              score, // Assure-toi que la variable `score` est bien définie plus haut
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'InriaSerif',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  //boite texte "materiaux detectes"
                  Positioned(
                      top : 198,
                      left: 13,
                      child: SizedBox(
                        width: 250,
                        height: 28,
                        child: Text(
                          'Matériau(x) détecté(s)',
                          style: TextStyle(
                            fontFamily: 'InriaSerif',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                  ),

                  Positioned(
                    top: 225,
                    left: 3,
                    child: Container(
                      width: 344,
                      height: 1,
                      color: const Color(0xFF5AC46C),
                    ),
                  ),

                  Positioned(
                      top : 374,
                      left: 13,
                      child: SizedBox(
                        width: 250,
                        height: 28,
                        child: Text(
                          'Suggestions d’upcycling :',
                          style: TextStyle(
                            fontFamily: 'InriaSerif',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                  ),
                  Positioned(
                    top: 402,
                    left: 3,
                    child: Container(
                      width: 344,
                      height: 1,
                      color: const Color(0xFF5AC46C),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Barre de navigation en bas
          Positioned(
            bottom: 0,
            left: (screenWidth - 390) / 2,
            child: Container(
              width: 390,
              height: 63,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 92,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Image.asset(
                        'assets/images/homeicon.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 92,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/scan');
                      },
                      child: Image.asset(
                        'assets/images/scanicon.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
