import 'package:flutter/material.dart';

@immutable
class UnaColumna extends StatelessWidget {
  const UnaColumna({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        child: child,
      ),
    );
  }
}
