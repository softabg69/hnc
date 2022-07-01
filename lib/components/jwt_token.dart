import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtToken {
  static String keyApple =
      "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgc4OiIOeJtmZPRl+5Lq+xiLbH5i7LIODdIJ3DWTE6dxugCgYIKoZIzj0DAQehRANCAATqNA1HA6Hv4CKxzN1cuFuSd9z5qY38DvAvoI1N1xFTCAjp4WQ8RispWDmezOIsGongu/iy9mYQcRNB+gAfznI3";
  static String generarToken(
      String email, String pwd, String origen, String issuer) {
    const String key = "4j67La/29bDmFE32ds";

    final claimSet = JwtClaim(
      issuer: issuer,
      subject: 'kleak',
      audience: <String>['es.helpncare.app'],
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

  static String clientSecretApple() {
    final exp = DateTime.now().add(const Duration(days: 210));
    final jwt = JWT({
      'alg': 'ES256',
      'kid': '6557J3JQ7R',
      'payload': {
        'iss': 'YU437LWTX5',
        'iat': DateTime.now().toUtc(),
        'exp': exp.toUtc(),
        'aud': 'https://appleid.apple.com',
        'sub': 'es.helpncare.app'
      }
    });
    final token = jwt.sign(SecretKey(keyApple), algorithm: JWTAlgorithm.ES256);
    return token;
  }
}
