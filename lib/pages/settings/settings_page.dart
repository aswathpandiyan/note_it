import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class SettingsList {
  String title;
  String value;
  SettingsList({required this.title, required this.value});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //late PackageInfo packageInfo = await PackageInfo.fromPlatform();

  List<SettingsList> list = [
    SettingsList(title: "App name", value: "NoteIt"),
    SettingsList(title: "Version", value: "1.0"),
    SettingsList(
        title: "Source code",
        value: "https://github.com/aswathpandiyan/note_it")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final item = list[index];
            return ListTile(
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Text(
                item.value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
