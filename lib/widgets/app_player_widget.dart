import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/widgets/play_state.dart';

class AppMobilePlayer extends ConsumerStatefulWidget {
  const AppMobilePlayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppMobilePlayerState();
}

class AppMobilePlayerState extends ConsumerState<AppMobilePlayer> {
  static const playerHeight = 70.0;
  static const albumCoverOffset = 5.0;

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
                    Radius.circular(albumCoverOffset * 2),
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
                            width: albumCoverOffset,
                          ),
                          SizedBox(
                            width: playerHeight - 2 * albumCoverOffset,
                            height: playerHeight - 2 * albumCoverOffset,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(albumCoverOffset * 2),
                              ),
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: albumCoverOffset,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.watch(appStateProvider).currentMediaTitle,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  ref
                                      .watch(appStateProvider)
                                      .currentMediaArtist,
                                  style: TextStyle(
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
