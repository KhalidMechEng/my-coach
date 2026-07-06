import 'package:flutter/foundation.dart' show kIsWeb;

/// On the web, third-party exercise images are blocked by CORS, so route them
/// through the wsrv.nl image proxy (adds `Access-Control-Allow-Origin: *`;
/// `n=-1` keeps GIF animation). On mobile the original URL is used directly.
String webSafeImageUrl(String url) {
  if (!kIsWeb) return url;
  return 'https://wsrv.nl/?url=${Uri.encodeComponent(url)}&n=-1';
}
