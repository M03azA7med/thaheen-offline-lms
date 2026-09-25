class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}

class AssetException implements Exception {
  final String message;
  AssetException([this.message = 'Asset error occurred']);
}

class VideoException implements Exception {
  final String message;
  VideoException([this.message = 'Video player error occurred']);
}
