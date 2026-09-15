import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/flashcards/data/datasources/local_flashcards_datasource.dart';
import '../../features/flashcards/data/repositories/flashcards_repository_impl.dart';
import '../../features/flashcards/domain/repositories/flashcards_repository.dart';
import '../../features/flashcards/presentation/bloc/flashcards_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();

  getIt.registerLazySingleton<LocalFlashcardsDataSource>(
    () => LocalFlashcardsDataSource(),
  );

  getIt.registerLazySingleton<FlashcardsRepository>(
    () => FlashcardsRepositoryImpl(
      dataSource: getIt<LocalFlashcardsDataSource>(),
    ),
  );

  getIt.registerFactory(
    () => FlashcardsBloc(
      repository: getIt<FlashcardsRepository>(),
    ),
  );
}
