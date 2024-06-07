import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import '../utils/update_manager.dart';

OverlayEntry updateDialog() {
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext context) {
      return UpdateDialog(entry: entry);
    }
  );

  return entry;
}


class UpdateDialog extends StatefulWidget {
  final OverlayEntry entry;

  UpdateDialog({required this.entry});

  @override
  State<UpdateDialog> createState() => _UpdateDialog(entry: entry);
}


class _UpdateDialog extends State<UpdateDialog> with TickerProviderStateMixin {
  OverlayEntry? entry;
  late AlertDialog dialog;
  String title = 'Mise à jour disponible';
  String content = 'Une nouvelle version de l\'application est disponible. Voulez-vous la télécharger ?';

  _UpdateDialog({required this.entry});

  @override
  Widget build(BuildContext context) {
    dialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: const Text('Non'),
          onPressed: () {
            entry?.remove();
          },
        ),
        TextButton(
          child: const Text('Oui'),
          onPressed: () {
            var stream = installUpdate();
            stream.then((stream) => {
              stream.listen(
                (OtaEvent event) {
                  title = "Downloading...";
                  content = "${event.value}%";
                  setState(() {});
                  if (event.status != OtaStatus.DOWNLOADING) {
                    entry?.remove();
                  }
                }
              )
            });
          },
        ),
      ],
    );

    return dialog;
  }
    
  @override
  void initState() {
    super.initState();
  }
}