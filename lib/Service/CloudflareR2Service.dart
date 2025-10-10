import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'r2_config.dart' as cfg;

/// Minimal AWS SigV4 presign implementation for Cloudflare R2 (S3-compatible).
/// WARNING: embedding keys in app is unsafe. You requested to place them here.
class CloudflareR2Service {
  // HMAC-SHA256 helper
  static List<int> _hmacSha256(List<int> key, List<int> msg) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(msg).bytes;
  }

  static String _sha256Hex(String input) =>
      sha256.convert(utf8.encode(input)).toString();

  // derive signing key
  static List<int> _getSigningKey(
    String secret,
    String dateStamp,
    String region,
    String service,
  ) {
    final kDate = _hmacSha256(
      utf8.encode('AWS4$secret'),
      utf8.encode(dateStamp),
    );
    final kRegion = _hmacSha256(kDate, utf8.encode(region));
    final kService = _hmacSha256(kRegion, utf8.encode(service));
    final kSigning = _hmacSha256(kService, utf8.encode('aws4_request'));
    return kSigning;
  }

  /// Generate a presigned GET URL for object `key` in the configured R2 bucket.
  static Future<Uri> presignedGetUrl(String key, {int expiresIn = 300}) async {
    final method = 'GET';
    final service = 's3';
    final region = 'auto';

    final now = DateTime.now().toUtc();
    final amzDate =
        now
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')
            .first +
        'Z';
    final dateStamp = amzDate.substring(0, 8);

    final host = Uri.parse(cfg.R2_ENDPOINT).host;
    final canonicalUri = '/${cfg.R2_BUCKET}/$key';

    final credential =
        '${cfg.R2_ACCESS_KEY_ID}/$dateStamp/$region/$service/aws4_request';

    final queryParams = {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': credential,
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': expiresIn.toString(),
      'X-Amz-SignedHeaders': 'host',
    };

    final canonicalQuery = (queryParams.keys.toList()..sort())
        .map((k) => '$k=${Uri.encodeQueryComponent(queryParams[k]!)}')
        .join('&');

    final canonicalHeaders = 'host:$host\n';
    final signedHeaders = 'host';
    final payloadHash = 'UNSIGNED-PAYLOAD';

    final canonicalRequest =
        '$method\n$canonicalUri\n$canonicalQuery\n$canonicalHeaders\n$signedHeaders\n$payloadHash';

    final canonicalRequestHash = _sha256Hex(canonicalRequest);

    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign =
        'AWS4-HMAC-SHA256\n$amzDate\n$credentialScope\n$canonicalRequestHash';

    final signingKey = _getSigningKey(
      cfg.R2_SECRET_ACCESS_KEY,
      dateStamp,
      region,
      service,
    );
    final signature = _hmacSha256(
      signingKey,
      utf8.encode(stringToSign),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    final finalQuery = '$canonicalQuery&X-Amz-Signature=$signature';
    final url = '${cfg.R2_ENDPOINT}$canonicalUri?$finalQuery';
    return Uri.parse(url);
  }

  /// List objects in the bucket (simple ListObjectsV2). Returns list of maps {key, url}.
  static Future<List<Map<String, String>>> listObjects() async {
    final method = 'GET';
    final service = 's3';
    final region = 'auto';

    final now = DateTime.now().toUtc();
    final amzDate =
        now
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')
            .first +
        'Z';
    final dateStamp = amzDate.substring(0, 8);

    final host = Uri.parse(cfg.R2_ENDPOINT).host;
    final canonicalUri = '/${cfg.R2_BUCKET}';

    final credential =
        '${cfg.R2_ACCESS_KEY_ID}/$dateStamp/$region/$service/aws4_request';

    final queryParams = {
      'list-type': '2',
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': credential,
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': '120',
      'X-Amz-SignedHeaders': 'host',
    };

    final canonicalQuery = (queryParams.keys.toList()..sort())
        .map((k) => '$k=${Uri.encodeQueryComponent(queryParams[k]!)}')
        .join('&');
    final canonicalHeaders = 'host:$host\n';
    final signedHeaders = 'host';
    final payloadHash = 'UNSIGNED-PAYLOAD';

    final canonicalRequest =
        '$method\n$canonicalUri\n$canonicalQuery\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    final canonicalRequestHash = _sha256Hex(canonicalRequest);
    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign =
        'AWS4-HMAC-SHA256\n$amzDate\n$credentialScope\n$canonicalRequestHash';

    final signingKey = _getSigningKey(
      cfg.R2_SECRET_ACCESS_KEY,
      dateStamp,
      region,
      service,
    );
    final signature = _hmacSha256(
      signingKey,
      utf8.encode(stringToSign),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    final finalQuery = '$canonicalQuery&X-Amz-Signature=$signature';
    final url = '${cfg.R2_ENDPOINT}$canonicalUri?$finalQuery';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200)
      throw Exception('Failed to list objects: ${res.statusCode}');

    final body = res.body;
    final regex = RegExp(r'<Key>(.*?)<\/Key>', dotAll: true);
    final result = <Map<String, String>>[];
    for (final m in regex.allMatches(body)) {
      final key = m.group(1)!;
      final presigned = await presignedGetUrl(key, expiresIn: 3600);
      result.add({'key': key, 'url': presigned.toString()});
    }
    return result;
  }

  static Future<Uint8List> downloadBytes(String key) async {
    final url = await presignedGetUrl(key, expiresIn: 60);
    final res = await http.get(url);
    if (res.statusCode != 200)
      throw Exception('Download failed: ${res.statusCode}');
    return res.bodyBytes;
  }
}
