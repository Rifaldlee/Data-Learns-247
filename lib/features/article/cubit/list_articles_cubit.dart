import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/list_articles_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/list_articles_use_case.dart';

part 'list_articles_state.dart';

class ListArticlesCubit extends Cubit<ListArticlesState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  ListArticlesCubit() : super(ListArticlesInitial());

  Future<void> fetchListArticles() async {
    try {
      emit(ListArticlesLoading());

      List<ListArticles>? listArticle = await GetListArticles(_articleRepository).call();

      if (listArticle!.isEmpty) {
        emit(const ListArticlesError('No data available'));
      } else {
        emit(ListArticlesCompleted(listArticle));
      }
    } catch (e) {
      emit(ListArticlesError(e.toString()));
    }
  }
}