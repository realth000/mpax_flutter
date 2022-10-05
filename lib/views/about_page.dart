import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final version = DefaultAssetBundle.of(context).loadString('assets/data/version');
    return Scaffold(
      appBar: MPaxAppBar(
        title: 'About'.tr,
      ),
      drawer: const MPaxDrawer(),
      body: _AboutPageBodyWidget(),
      bottomNavigationBar: const MPaxPlayerWidget(),
    );
  }
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
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
                      title: Text('MPax is a simple and easy-to-use music '
                              'player powered by Flutter'
                          .tr),
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
                      trailing: const Icon(Icons.launch),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(_githubPageString),
                          mode: LaunchMode.externalApplication,
                        );
                      },
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
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                      child: TitleText(
                        title: 'Build info'.tr,
                        level: 0,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: Text('Build platform'.tr),
                      trailing: Chip(
                        avatar: platformIcon,
                        label: Text(platformString),
                        padding: const EdgeInsets.all(0),
                        side: BorderSide.none,
                        labelPadding: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.construction),
                      title: Text('Build version'.tr),
                      trailing: FutureBuilder(
                        future: DefaultAssetBundle.of(context)
                            .loadString('assets/data/version'),
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data == null) {
                            return Text('Unknown'.tr);
                          }
                          return Text(snapshot.data!);
                        },
                      ),
                    ),
                    ListTile(
                      leading: const FlutterLogo(
                        style: FlutterLogoStyle.markOnly,
                      ),
                      title: Text('Flutter version'.tr),
                      trailing: FutureBuilder(
                        future: DefaultAssetBundle.of(context)
                            .loadString('assets/data/flutter_version'),
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data == null) {
                            return Text('Unknown'.tr);
                          }
                          return Text(snapshot.data!);
                        },
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
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                      child: TitleText(
                        title: 'License'.tr,
                        level: 0,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.collections_bookmark),
                      title: Text('MPax is licensed under MIT license'.tr),
                      trailing: const Icon(Icons.launch),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(_licensePageString),
                          mode: LaunchMode.externalApplication,
                        );
                      },
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
