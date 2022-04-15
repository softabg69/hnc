import 'package:hnc/repository/service/hnc_service.dart';

class HncRepository {
  const HncRepository({
    required this.service,
  });

  final HncService service;

  Future<String> authenticate(String email, String pwd) async {
    print("autenticar: $email,$pwd");
    return await service.autenticar(email, pwd);
    //print("looged in");
  }

  Future<String> politica() async {
    //print("repository politica");
    return await service.politica();
  }
}
