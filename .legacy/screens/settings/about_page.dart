import 'package:flutter/material.dart';
import 'package:mpax_flutter/utils/platform.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  String _platformString() {
    if (isWindows) {
      return 'Windows';
    } else if (isLinux) {
      return 'Linux';
    } else if (isMacOS) {
      return 'MacOS';
    } else if (isAndroid) {
      return 'Android';
    } else if (isIOS) {
      return 'IOS';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  'Build info',
                  style: _titleStyle,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.build),
                title: const Text('Platform'),
                trailing: Text(_platformString()),
              ),
              const ListTile(
                leading: Icon(Icons.construction),
                title: Text('Version'),
                trailing: Text(
                  String.fromEnvironment(
                    'MPAX_VERSION',
                    defaultValue: 'unknown',
                  ),
                ),
              ),
              const ListTile(
                leading: FlutterLogo(),
                title: Text('Flutter Version'),
                trailing: Text(
                  String.fromEnvironment(
                    'FLUTTER_VERSION',
                    defaultValue: 'unknown',
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.commit),
                title: Text('Revision'),
                trailing: Text(
                  String.fromEnvironment(
                    'GIT_COMMIT_ID',
                    defaultValue: 'unknown',
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.commit),
                title: Text('Git Commit Time'),
                trailing: Text(
                  String.fromEnvironment(
                    'GIT_COMMIT_TIME',
                    defaultValue: 'unknown',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
