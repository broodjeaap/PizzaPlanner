Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}