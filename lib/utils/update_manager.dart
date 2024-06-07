import 'dart:async';
import 'dart:convert';

import 'package:ota_update/ota_update.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

Future<String> fetchLatestVersion() async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/atomic-junky/CatsukaApp/releases/latest'),
    headers: {'Accept': 'application/vnd.github+json'},
  );


  if (response.statusCode == 200) {
    final release = json.decode(response.body);
    return release['tag_name'].replaceFirst("v","");
  } else {
    throw Exception('Failed to load release');
  }
}

Future<bool> checkForUpdate() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String latestVersion = await fetchLatestVersion();
  String currentVersion = packageInfo.version;

  return latestVersion != currentVersion;
}

Future<Stream<OtaEvent>> installUpdate() async {
  String latestVersion = await fetchLatestVersion();

  return OtaUpdate()
      .execute(
        'https://github.com/atomic-junky/CatsukaApp/releases/download/v$latestVersion/app-arm64-v8a-release.apk',
      );
}