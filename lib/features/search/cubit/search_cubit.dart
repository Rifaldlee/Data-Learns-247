import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/implementation/search_repository_impl.dart';
import 'package:data_learns_247/features/search/data/models/search_model.dart';
import 'package:data_learns_247/features/search/domains/use_cases/search_use_case.dart';
import 'package:data_learns_247/core/repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository = SearchRepositoryImpl();

  SearchCubit() : super(SearchInitial());

  Future<void> fetchSearchResult(String query) async {
    try {
      emit(SearchLoading());

      SearchResult? searchResult = await GetSearchData(query, _searchRepository).call();

      if (searchResult != null && ((searchResult.articles!.isNotEmpty) || (searchResult.courses!.isNotEmpty))) {
        emit(SearchCompleted(searchResult));
      } else {
        emit(SearchEmpty());
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}