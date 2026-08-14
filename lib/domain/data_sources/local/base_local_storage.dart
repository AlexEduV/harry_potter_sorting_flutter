abstract class BaseLocalStorage<T> {
  Future<List<T>> getAll();
  Future<void> delete(int id);
}
