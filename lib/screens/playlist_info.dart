import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistInfoPage extends ConsumerStatefulWidget {
  const PlaylistInfoPage({super.key});

  @override
  ConsumerState<PlaylistInfoPage> createState() => _PlaylistInfoPageState();
}

class _PlaylistInfoPageState extends ConsumerState<PlaylistInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(delegate: MyHeaderDelegate()),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
              ListTile(
                title: const Text('Playlist Name'),
                subtitle: const Text('Playlist Description'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Text('header');
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  double get maxExtent => 264;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
