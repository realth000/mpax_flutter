import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionCard extends ConsumerWidget {
  const SectionCard(this.title, this.children, {this.trailing, super.key});

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  if (trailing != null) trailing!
                ],
              ),
              ...children,
            ],
          ),
        ),
      );
}

class Section extends ConsumerWidget {
  const Section(this.title,
      {this.leading, this.trailing, this.subtitle, super.key});

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing,
      );
}
