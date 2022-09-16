import 'package:just_audio/just_audio.dart';
import 'package:mpax_flutter/models/play_content.model.dart';

class PlaylistModel {
  PlaylistModel(this.name, this.tableName, this.contentList);

  String name;
  String tableName;
  List<PlayContent> contentList;
  ConcatenatingAudioSource sourceList =
      ConcatenatingAudioSource(children: <AudioSource>[]);

  void clearContent() {
    contentList.clear();
  }

  Future<void> generatePlaylist() async {
    List<AudioSource> l = <AudioSource>[];
    for (var content in contentList) {
      AudioSource c = AudioSource.uri(Uri.parse(content.contentPath));
      l.add(c);
    }
    sourceList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: l,
    );
    print('AAAAA ${sourceList.children.length}');
  }
}
