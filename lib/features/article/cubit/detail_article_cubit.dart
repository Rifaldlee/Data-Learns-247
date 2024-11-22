import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/article_repository.dart';
import 'package:data_learns_247/core/repository/implementation/article_repository_impl.dart';
import 'package:data_learns_247/features/article/data/models/detail_article_model.dart';
import 'package:data_learns_247/features/article/domains/use_cases/detail_article_use_case.dart';

part 'detail_article_state.dart';

class DetailArticleCubit extends Cubit<DetailArticleState> {
  final ArticleRepository _articleRepository = ArticleRepositoryImpl();

  DetailArticleCubit() : super(DetailArticleInitial());

  Future<void> fetchDetailArticle(String id) async {
    try {
      emit(DetailArticleLoading());

      Article? detailArticle = await GetDetailArticle(id, _articleRepository).call();

      if (detailArticle != null) {
        emit(DetailArticleCompleted(detailArticle));
      } else {
        emit(const DetailArticleError('No data available'));
      }
    } catch (e) {
      emit(DetailArticleError(e.toString()));
    }
  }
}
