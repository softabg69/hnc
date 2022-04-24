import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/platform/platform_bloc.dart';
import '../components/dialog.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatformBloc, PlatformState>(
      builder: (context, platform) {
        return GestureDetector(
          onTap: () {
            Dialogs.informacion(
                context,
                const Text('Info'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('appName: ${platform.appName}'),
                    Text('packageName: ${platform.packageName}'),
                    Text('version: ${platform.version}'),
                    Text('buildNumber: ${platform.buildNumber}'),
                    Text('buildSignature: ${platform.buildSignature}')
                  ],
                ));
          },
          child: Image.asset('assets/images/helpncare_logo.png'),
        );
      },
    );
  }
}
