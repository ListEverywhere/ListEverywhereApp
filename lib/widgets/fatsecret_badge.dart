import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FatSecretBadge extends StatelessWidget {
  const FatSecretBadge({super.key});

  final _url = 'https://platform.fatsecret.com';

  Future<void> launch() async {
    if (!await launchUrl(Uri.parse(_url))) {
      print('failed to launch url');
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: launch,
      child: Image.network(
        'https://platform.fatsecret.com/api/static/images/powered_by_fatsecret_2x.png',
        height: 20,
      ),
    );
  }
}
