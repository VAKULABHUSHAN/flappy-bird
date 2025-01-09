import 'package:flutter/material.dart';


class barrier extends StatelessWidget {


  final size;

  barrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(width: 10,color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
