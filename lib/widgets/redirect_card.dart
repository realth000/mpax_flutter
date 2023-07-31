import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RedirectCard extends ConsumerWidget {
  const RedirectCard(
    this.icon,
    this.title,
    this.destination, {
    this.extraObject,
    super.key,
  });

  final Icon icon;
  final String title;
  final String destination;
  final Object? extraObject;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
        child: ListTile(
          leading: icon,
          title: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.go(destination, extra: extraObject);
          },
          shape: const BorderDirectional(),
        ),
      );
}
