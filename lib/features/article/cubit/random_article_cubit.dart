import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/random_article_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/random_article_use_case.dart';

part 'random_article_state.dart';

class RandomArticleCubit extends Cubit<RandomArticleState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  RandomArticleCubit() : super(RandomArticleInitial());

  Future<void> fetchRandomArticle() async {
    try {
      emit(RandomArticleLoading());

      RandomArticle? randomArticle = await GetRandomArticle(_articleRepository).call();

      if (randomArticle != null) {
        emit(RandomArticleCompleted(randomArticle));
      } else {
        emit(const RandomArticleError('No random article found'));
      }
    } catch (e) {
      emit(RandomArticleError(e.toString()));
    }
  }
}