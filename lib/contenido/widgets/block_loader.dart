import 'package:flutter/material.dart';

class BlockLoader extends StatelessWidget {
  const BlockLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
