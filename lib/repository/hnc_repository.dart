import 'package:hnc/repository/service/hnc_service.dart';

class HncRepository {
  const HncRepository({
    required this.service,
  });

  final HncService service;

  Future<void> authenticate(String user, String pwd) async {
    await Future.delayed(const Duration(seconds: 2));
    //print("looged in");
  }

  Future<String> politica() async {
    //print("repository politica");
    return await service.politica();
  }
}
