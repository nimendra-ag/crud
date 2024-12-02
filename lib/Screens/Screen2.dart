import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Reading book-pana.png'),
        const SizedBox(height: 40),
        const Text("Share Your Favorites", style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text("Upload and share your cherished books, connecting with readers who share your interests.", style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300
          ),
          textAlign: TextAlign.center,
          ),     
        )

      ],
    );;
  }
}