import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/error.jpeg',
              width: 100,
            ),
          ),
          const Text('Algo ha ido mal...'),
          const Text('Disculpa las molestias.'),
          const Text('Hemos tomado nota del error para corregirlo.'),
        ],
      ),
    );
  }
}
