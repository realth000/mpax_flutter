import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: playerHeight),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: playerHeight,
                maxHeight: playerHeight),
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
                              child: Container(
                                color: Colors.red,
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
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  ref
                                      .watch(appStateProvider)
                                      .currentMediaArtist,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: playerStateIconMap[
                                ref.watch(appStateProvider).playerState]!,
                          ),
                          IconButton(
                            onPressed: () {},
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
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 150,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.red,
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
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          ref.watch(appStateProvider).currentMediaArtist,
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
                    onPressed: () {
                      // TODO: Skip to previous.
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Play or pause.
                    },
                    icon: playerStateIconMap[
                        ref.watch(appStateProvider).playerState]!,
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Skip to next.
                    },
                    icon: const Icon(Icons.skip_next),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Stop.
                    },
                    icon: const Icon(Icons.stop),
                  ),
                  Expanded(
                    child: Slider(
                      value: 0.0,
                      onChanged: (value) {
                        // TODO: Change current position.
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
