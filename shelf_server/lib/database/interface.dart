abstract interface class DataStorage {
  Future<void> init();
  Future<bool> create(int score);
  Future<List<Map<String, dynamic>>> read(String id);
  Future<bool> update(String id, int score);
  Future<bool> delete(String id);
}
