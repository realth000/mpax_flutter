import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/player_provider.dart';
import 'package:mpax_flutter/utils/time.dart';
import 'package:mpax_flutter/widgets/play_state.dart';

const _albumCoverOffset = 5.0;

class AppMobilePlayer extends ConsumerStatefulWidget {
  const AppMobilePlayer({super.key});

  @override
  ConsumerState<AppMobilePlayer> createState() => AppMobilePlayerState();
}

class AppMobilePlayerState extends ConsumerState<AppMobilePlayer> {
  static const playerHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ref.watch(appStateProvider).horizontalPadding;
    final artwork = ref.watch(appStateProvider).currentMediaArtwork;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: playerHeight),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              minHeight: playerHeight,
              maxHeight: playerHeight,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Container(
                    // When M3 enabled, default NavigationBar background is
                    // "surface with elevation tint", according to flex_color_scheme playground,
                    // which is a calculated color.
                    //
                    // Calculate it following here:
                    // https://github.com/rydmike/flex_color_scheme/discussions/50#discussioncomment-2918565
                    // use applySurfaceTint get the actual color.
                    //
                    // Default elevation is 3.
                    color: ElevationOverlay.applySurfaceTint(
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surfaceTint,
                      Theme.of(context).navigationBarTheme.elevation ?? 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(_albumCoverOffset * 2),
                  ),
                  // child: Container(
                  //   color: ElevationOverlay.applySurfaceTint(
                  //     Theme.of(context).colorScheme.surface,
                  //     Theme.of(context).colorScheme.surfaceTint,
                  //     Theme.of(context).cardTheme.elevation ?? 1,
                  //   ),
                  // ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Card(
                      margin: EdgeInsets.zero,
                      semanticContainer: false,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: _albumCoverOffset,
                          ),
                          SizedBox(
                            width: playerHeight - 2 * _albumCoverOffset,
                            height: playerHeight - 2 * _albumCoverOffset,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(_albumCoverOffset * 2),
                              ),
                              child: artwork == null
                                  ? const SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Icon(Icons.music_note),
                                    )
                                  : Image.memory(
                                      artwork,
                                      width: 60,
                                      height: 60,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: _albumCoverOffset,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.watch(appStateProvider).currentMediaTitle,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  ref
                                      .watch(appStateProvider)
                                      .currentMediaArtist,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref.read(playerProvider).playOrPause();
                            },
                            icon: playerStateIconMap[
                                ref.watch(appStateProvider).playerState]!,
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref.read(playerProvider).switchPlayMode();
                            },
                            icon: playModeIconMap[
                                ref.watch(appStateProvider).playMode]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDesktopPlayer extends ConsumerStatefulWidget {
  const AppDesktopPlayer({super.key});

  @override
  ConsumerState<AppDesktopPlayer> createState() => AppDesktopPlayerState();
}

class AppDesktopPlayerState extends ConsumerState<AppDesktopPlayer> {
  @override
  Widget build(BuildContext context) {
    final artwork = ref.watch(appStateProvider).currentMediaArtwork;

    final Icon volumeIcon;
    final volume = ref.read(appStateProvider).playerVolume;
    if (volume == 0) {
      volumeIcon = const Icon(Icons.volume_mute);
    } else if (volume < 0.1) {
      volumeIcon = const Icon(Icons.volume_down);
    } else {
      volumeIcon = const Icon(Icons.volume_up);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 135,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        _albumCoverOffset,
                      ),
                    ),
                    child: artwork == null
                        ? const SizedBox(
                            width: 60,
                            height: 60,
                            child: Icon(Icons.music_note),
                          )
                        : Image.memory(
                            artwork,
                            width: 60,
                            height: 60,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.watch(appStateProvider).currentMediaTitle,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          ref.watch(appStateProvider).currentMediaArtist,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await ref.read(playerProvider).playPrevious();
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref.read(playerProvider).playOrPause();
                    },
                    icon: playerStateIconMap[
                        ref.watch(appStateProvider).playerState]!,
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref.read(playerProvider).playNext();
                    },
                    icon: const Icon(Icons.skip_next),
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref.read(playerProvider).stop();
                    },
                    icon: const Icon(Icons.stop),
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref.read(playerProvider).switchPlayMode();
                    },
                    icon:
                        playModeIconMap[ref.watch(appStateProvider).playMode]!,
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Text(
                    secondsToFormatString(
                        ref.watch(appStateProvider).playerPosition.toInt()),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Expanded(
                    child: Slider(
                      value: ref.watch(appStateProvider).playerPosition,
                      max: ref.watch(appStateProvider).playerDuration,
                      onChanged: (value) async {
                        await ref.read(playerProvider).seekToPosition(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      final currentVolume =
                          ref.read(appStateProvider).playerVolume;
                      if (currentVolume != 0) {
                        await ref.read(playerProvider).setVolume(0);
                      } else {
                        final lastVolume =
                            ref.read(appStateProvider).playerLastNotMuteVolume;
                        await ref.read(playerProvider).setVolume(lastVolume);
                      }
                    },
                    icon: volumeIcon,
                  ),
                  Slider(
                    value: ref.watch(appStateProvider).playerVolume,
                    onChanged: (value) async {
                      await ref.read(playerProvider).setVolume(value);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Text(
                    secondsToFormatString(
                        ref.watch(appStateProvider).playerDuration.toInt()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
