#ifndef MEIPURU_BINDING_H
#define MEIPURU_BINDING_H


#ifdef __cplusplus
extern "C" {
#endif

#ifdef MEIPURU_LIB
#if (defined(_WIN32) || defined(_WIN64))
#define MEIPURU_EXPORT __declspec(dllexport)
#else
#define MEIPURU_EXPORT __declspec(dllimport)
#endif // MSVC
#elif defined(__GNUC__)
#define MEIPURU_EXPORT __attribute__ ((visibility("default")))
#else
#define MEIPURU_EXPORT
#endif

typedef struct {
    const char *filePath;
    const char *fileName;
    const char *title;
    const char *artist;
    const char *albumTitle;
    const char *albumArtist;
    const unsigned int year;
    const unsigned int track;
    const int albumTotalTrack;
    const char *genre;
    const char *comment;
    const int bitRate;
    const int sampleRate;
    const int channels;
    const int length;
} MeipuruTag;


typedef struct {
    const char *filePath;
    const char *fileName;
    const char *title;
    const char *artist;
    const char *albumTitle;
    const char *albumArtist;
    const unsigned int year;
    const unsigned int track;
    const int albumTotalTrack;
    const char *genre;
    const char *comment;
    const int bitRate;
    const int sampleRate;
    const int channels;
    const int length;
    const char *lyrics;
    const unsigned long lyricsLength;
    const char *albumCover;
    const unsigned int albumCoverLength;
} MeipuruID3v2Tag;

MEIPURU_EXPORT MeipuruTag *MeipuruReadTag(const char *filePath);

MEIPURU_EXPORT MeipuruID3v2Tag *MeipuruReadID3v2Tag(const char *filePath);

MEIPURU_EXPORT void MeipuruFree(void *pointer);

#ifdef __cplusplus
}
#endif

#endif //MEIPURU_BINDING_H
