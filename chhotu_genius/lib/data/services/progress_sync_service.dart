import 'api_service.dart';

class ProgressSyncService {
  final ApiService _api;

  ProgressSyncService(this._api);

  /// Save progress for a single lesson
  Future<Map<String, dynamic>> saveProgress({
    required String childId,
    required String lessonId,
    required int score,
    required int stars,
    bool completed = false,
  }) async {
    return _api.post('/progress', {
      'childId': childId,
      'lessonId': lessonId,
      'score': score,
      'stars': stars,
      'completed': completed,
    });
  }

  /// Get all progress for a child
  Future<Map<String, dynamic>> getChildProgress(String childId) async {
    return _api.get('/progress/$childId');
  }

  /// Get progress for a specific module
  Future<Map<String, dynamic>> getModuleProgress(String childId, String moduleSlug) async {
    return _api.get('/progress/$childId/module/$moduleSlug');
  }

  /// Bulk sync local progress to server
  Future<Map<String, dynamic>> syncBatch(List<Map<String, dynamic>> entries) async {
    return _api.post('/progress/sync', {'entries': entries});
  }
}
