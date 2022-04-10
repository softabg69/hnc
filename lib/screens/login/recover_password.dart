import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/login/login_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final repo = context.read<HncRepository>();
    print(repo);
    return const Text('OK');
  }
}
