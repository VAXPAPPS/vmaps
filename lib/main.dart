import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:venom_config/venom_config.dart';

import 'core/colors/vaxp_colors.dart';
import 'data/repositories/map_repository_impl.dart';
import 'domain/repositories/map_repository.dart';
import 'application/map/map_bloc.dart';
import 'application/search/search_bloc.dart';
import 'application/route/route_bloc.dart';
import 'application/favorites/favorites_bloc.dart';
import 'presentation/pages/maps_page.dart';

Future<void> main() async {
  // Initialize Flutter bindings first to ensure the binary messenger is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Venom Config System
  await VenomConfig().init();

  // Initialize VaxpColors listeners
  VaxpColors.init();

  // Initialize window manager for desktop controls
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(900, 600),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Vaxp Maps',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const VaxpMapsApp());
}

class VaxpMapsApp extends StatelessWidget {
  const VaxpMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء المستودع (Dependency Injection)
    final MapRepository repository = MapRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (_) => MapBloc(repository: repository),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(repository: repository),
        ),
        BlocProvider<RouteBloc>(
          create: (_) => RouteBloc(repository: repository),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => FavoritesBloc(repository: repository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vaxp Maps',
        home: const MapsPage(),
      ),
    );
  }
}
