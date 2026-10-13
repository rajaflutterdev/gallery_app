import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constant/string_values.dart';
import 'features/gallery/bloc/gallery_bloc.dart';
import 'features/gallery/bloc/gallery_event.dart';
import 'features/gallery/data/repository/favorites_repository.dart';
import 'features/gallery/data/repository/image_api_service.dart';
import 'features/splash/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesRepository();
    final imageApiService = ImageApiService();
    return MultiBlocProvider(
      providers: [
        BlocProvider<GalleryBloc>(create: (context) => GalleryBloc(imageApiService: imageApiService, favorites: favorites)..add(GalleryStarted()),),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          scaffoldBackgroundColor: const Color(0xFFF8F7FC),
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        ),
        home: SplashView(),
      ),
    );
  }
}
