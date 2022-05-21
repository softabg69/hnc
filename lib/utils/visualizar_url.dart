import 'package:url_launcher/url_launcher.dart';

import '../components/log.dart';

lanzaURL(String url) async {
  try {
    final Uri httpsUrl = Uri.parse(url);
    if (url.isNotEmpty) {
      await launchUrl(httpsUrl);
    }
  } catch (e) {
    Log.registra('Error al lanzar url: $e');
  }
}
