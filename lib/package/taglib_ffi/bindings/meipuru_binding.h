#ifndef MEIPURU_BINDING_H
#define MEIPURU_BINDING_H


#ifdef __cplusplus
extern "C" {
#endif

#ifdef MEIPURU_LIB
#if (defined(_WIN32) || defined(_WIN64))
#define MEIPURU_EXPORT __declspec(dllexport)
#elif defined(__GNUC__)
#define MEIPURU_EXPORT __attribute__((visibility("default")))
#else
#define MEIPURU_EXPORT
#endif
#else
#define MEIPURU_EXPORT
#endif

typedef struct {
    char *filePath;
    char *fileName;
    char *title;
    char *artist;
    char *albumTitle;
    char *albumArtist;
    unsigned int year;
    unsigned int track;
    int albumTotalTrack;
    char *genre;
    char *comment;
    int bitRate;
    int sampleRate;
    int channels;
    int length;
} MeipuruTag;


typedef struct {
    char *filePath;
    char *fileName;
    char *title;
    char *artist;
    char *albumTitle;
    char *albumArtist;
    unsigned int year;
    unsigned int track;
    int albumTotalTrack;
    char *genre;
    char *comment;
    int bitRate;
    int sampleRate;
    int channels;
    int length;
    char *lyrics;
    unsigned long lyricsLength;
    char *albumCover;
    unsigned int albumCoverLength;
} MeipuruID3v2Tag;

MEIPURU_EXPORT MeipuruTag *MeipuruReadTag(const char *filePath);

MEIPURU_EXPORT MeipuruID3v2Tag *MeipuruReadID3v2Tag(const char *filePath);

MEIPURU_EXPORT void MeipuruFreeTag(MeipuruTag *tag);

MEIPURU_EXPORT void MeipuruFreeID3v2Tag(MeipuruID3v2Tag *id3V2Tag);

#ifdef __cplusplus
}
#endif

#endif//MEIPURU_BINDING_H
