import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtToken {
  static String keyApple =
      "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgc4OiIOeJtmZPRl+5Lq+xiLbH5i7LIODdIJ3DWTE6dxugCgYIKoZIzj0DAQehRANCAATqNA1HA6Hv4CKxzN1cuFuSd9z5qY38DvAvoI1N1xFTCAjp4WQ8RispWDmezOIsGongu/iy9mYQcRNB+gAfznI3";
  //"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";
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
        'iat': DateTime.now().toUtc().toString(),
        'exp': exp.toUtc().toString(),
        'aud': 'https://appleid.apple.com',
        'sub': 'es.helpncare.app'
      }
    });
    final token = jwt.sign(SecretKey(keyApple), algorithm: JWTAlgorithm.ES256);
    return token;
  }
}
