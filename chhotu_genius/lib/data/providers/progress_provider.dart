import 'package:flutter/foundation.dart';
import '../local/local_storage_service.dart';
import '../services/api_service.dart';
import '../services/progress_sync_service.dart';

class ProgressProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  final ProgressSyncService _syncService;
  final ApiService _apiService;

  // module -> lesson -> score (stars 0-3)
  Map<String, Map<String, int>> _progress = {};

  ProgressProvider(this._storageService, this._syncService, this._apiService) {
    _loadFromStorage();
  }

  Map<String, Map<String, int>> get progress => _progress;

  void _loadFromStorage() {
    _progress = _storageService.getProgress();
    notifyListeners();
  }

  Future<void> recordProgress(String module, String lesson, int score) async {
    _progress.putIfAbsent(module, () => {});
    final currentScore = _progress[module]![lesson] ?? 0;
    // Only update if new score is higher
    if (score > currentScore) {
      _progress[module]![lesson] = score;
    }
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }

  /// Sync a specific progress entry to the server (if logged in and childId is available)
  Future<void> syncProgressToServer({
    required String childId,
    required String lessonId,
    required int score,
    required int stars,
    bool completed = false,
  }) async {
    if (!_apiService.isLoggedIn || childId.isEmpty || lessonId.isEmpty) return;
    // Fire and forget - don't block UI
    _syncService.saveProgress(
      childId: childId,
      lessonId: lessonId,
      score: score,
      stars: stars,
      completed: completed,
    );
  }

  Map<String, int> getModuleProgress(String module) {
    return _progress[module] ?? {};
  }

  int getTotalStars() {
    int total = 0;
    for (final module in _progress.values) {
      for (final score in module.values) {
        total += score;
      }
    }
    return total;
  }

  int getCompletedLessonsCount() {
    int count = 0;
    for (final module in _progress.values) {
      for (final score in module.values) {
        if (score > 0) count++;
      }
    }
    return count;
  }

  double getModuleProgressPercent(String module, int totalLessons) {
    if (totalLessons == 0) return 0;
    final moduleProgress = _progress[module] ?? {};
    final completedLessons =
        moduleProgress.values.where((score) => score > 0).length;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }

  int getModuleStars(String module) {
    final moduleProgress = _progress[module] ?? {};
    int stars = 0;
    for (final score in moduleProgress.values) {
      stars += score;
    }
    return stars;
  }
}
