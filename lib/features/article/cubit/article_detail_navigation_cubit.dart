import 'package:bloc/bloc.dart';
import 'package:data_learns_247/features/article/data/models/article_history.dart';

part 'article_detail_navigation_state.dart';

class ArticleDetailNavigationCubit extends Cubit<ArticleDetailNavigationState> {
  ArticleDetailNavigationCubit() : super(ArticleDetailNavigationInitial(history: []));

  void addToHistory(String id, bool hasVideo) {
    final currentHistory = state.history;
    if (currentHistory.isEmpty || currentHistory.last.id != id) {
      final newHistory = List<ArticleHistoryItem>.from(currentHistory)
        ..add(ArticleHistoryItem(id: id, hasVideo: hasVideo));
      emit(ArticleDetailNavigationUpdated(history: newHistory));
    }
  }

  ArticleHistoryItem? getPreviousArticle() {
    final currentHistory = state.history;
    if (currentHistory.length > 1) {
      return currentHistory[currentHistory.length - 2];
    }
    return null;
  }

  void removeLastFromHistory() {
    final currentHistory = state.history;
    if (currentHistory.length > 1) {
      final newHistory = List<ArticleHistoryItem>.from(currentHistory)..removeLast();
      emit(ArticleDetailNavigationUpdated(history: newHistory));
    }
  }

  void clearHistory() {
    emit(ArticleDetailNavigationInitial(history: []));
  }
}

