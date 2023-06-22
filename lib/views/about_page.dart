import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mobile/components/mobile_underfoot.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_player_widget.dart';
import '../widgets/util_widgets.dart';

/// About page in drawer.
class AboutPage extends StatelessWidget {
  /// Constructor.
  const AboutPage({super.key});

  /// TODO: Migrate to desktop.
  get body => _AboutPageBodyWidget();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'About'.tr,
        ),
        drawer: const MPaxDrawer(),
        body: _AboutPageBodyWidget(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}

class _AboutPageBodyWidget extends StatelessWidget {
  static const _githubPageString = 'https://github.com/realth000/mpax_flutter';
  static const _licensePageString =
      'https://github.com/realth000/mpax_flutter/blob/master/LICENSE';

  @override
  Widget build(BuildContext context) {
    late final String platformString;
    late final Icon platformIcon;
    if (GetPlatform.isAndroid) {
      platformString = 'Android';
      platformIcon = const Icon(Icons.android);
    } else if (GetPlatform.isWindows) {
      platformString = 'Windows';
      platformIcon = const Icon(Icons.desktop_windows);
    } else if (GetPlatform.isLinux) {
      platformString = 'Linux';
      platformIcon = const Icon(Icons.computer);
    } else {
      platformString = 'Unknown'.tr;
      platformIcon = const Icon(Icons.error);
    }
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: TitleText(
                        title: 'About MPax'.tr,
                        level: 0,
                      ),
                    ),
                    ListTile(
                      leading: ListTileLeading(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child:
                              Image.asset('assets/images/mpax_flutter_192.png'),
                        ),
                      ),
                      title: Text(
                        'MPax is a simple and easy-to-use music '
                                'player powered by Flutter'
                            .tr,
                      ),
                    ),
                    ListTile(
                      leading: const ListTileLeading(
                        child: Icon(Icons.code),
                      ),
                      title: Text('Github homepage'.tr),
                      subtitle: const Text(
                        'realth000/mpax_flutter',
                        maxLines: 1,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.launch),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(_githubPageString),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const ListTileLeading(
                        child: Icon(Icons.waving_hand),
                      ),
                      title: Text('Welcome to help MPax be better!'.tr),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: TitleText(
                        title: 'Build info'.tr,
                        level: 0,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: Text('Build platform'.tr),
                      trailing: Text(platformString),
                    ),
                    ListTile(
                      leading: const Icon(Icons.construction),
                      title: Text('Build version'.tr),
                      trailing: const Text(
                        String.fromEnvironment(
                          'MPAX_VERSION',
                          defaultValue: 'unknown',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const FlutterLogo(),
                      title: Text('Flutter version'.tr),
                      trailing: const Text(
                        String.fromEnvironment(
                          'FLUTTER_VERSION',
                          defaultValue: 'unknown',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.commit),
                      title: Text('Git commit ID'.tr),
                      trailing: const Text(
                        String.fromEnvironment(
                          'GIT_COMMIT_ID',
                          defaultValue: 'unknown',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.commit),
                      title: Text('Git commit time'.tr),
                      trailing: const Text(
                        String.fromEnvironment(
                          'GIT_COMMIT_TIME',
                          defaultValue: 'unknown',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: TitleText(
                        title: 'License'.tr,
                        level: 0,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.collections_bookmark),
                      title: Text('MPax is licensed under MIT license'.tr),
                      trailing: IconButton(
                        icon: const Icon(Icons.launch),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(_licensePageString),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
