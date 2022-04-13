import 'dart:math';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtToken {
  static String GenerarToken(
      String email, String pwd, String origen, String issuer) {
    const String key = "4j67La/29bDmFE32ds";

    final claimSet = JwtClaim(
      issuer: issuer,
      subject: 'kleak',
      audience: <String>['helpncare.coeptalis.com'],
      jwtId: _randomString(32),
      otherClaims: <String, dynamic>{
        'email': email,
        'pass': pwd,
        'origen': origen
      },
      maxAge: const Duration(minutes: 60),
    );
    return issueJwtHS256(claimSet, key);
  }

  static String _randomString(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rnd = Random(DateTime.now().millisecondsSinceEpoch);
    final buf = StringBuffer();

    for (var x = 0; x < length; x++) {
      buf.write(chars[rnd.nextInt(chars.length)]);
    }
    return buf.toString();
  }
}
