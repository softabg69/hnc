import 'package:hnc/repository/service/hnc_service.dart';

class HncRepository {
  const HncRepository({
    required this.service,
  });

  final HncService service;

  Future<void> authenticate(String user, String pwd) async {
    print("auth: $user, $pwd");
    Future.delayed(const Duration(seconds: 8));
    print("looged in");
  }
}
