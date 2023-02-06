import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

import 'common/data/provider/chat_firebase_provider.dart';
import 'common/data/provider/message_firebase_provider.dart';
import 'common/data/provider/storage_firebase_provider.dart';
import 'common/data/provider/tag_firebase_provider.dart';
import 'common/data/repository/chat_repository.dart';
import 'common/data/repository/tag_repository.dart';
import 'common/features/settings/settings.dart';
import 'common/features/theme/theme.dart';
import 'features/locale/data/locale_repository_api.dart';
import 'features/locale/locale.dart';
import 'features/text_tags/text_tags.dart';
import 'routes.dart';

class JournalApp extends StatelessWidget {
  const JournalApp({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang/'];

    return _InitProviders(
      userId: userId,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Journal',
            theme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: state.isDarkMode ? Colors.white : Colors.black,
                    displayColor:
                        state.isDarkMode ? Colors.white60 : Colors.black54,
                    fontSizeFactor: context
                        .watch<SettingsCubit>()
                        .state
                        .fontScaleFactor
                        .scaleFactor,
                  ),
              useMaterial3: true,
              colorSchemeSeed: state.color,
              brightness: state.isDarkMode ? Brightness.dark : Brightness.light,
            ),
            locale: context.watch<LocaleCubit>().state.locale,
            routerConfig: Navigation.router,
            localizationsDelegates: _localizationDelegates,
            supportedLocales: LocaleRepositoryApi.supportedLocales,
            localeResolutionCallback: _localeResolution,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Iterable<LocalizationsDelegate<dynamic>> get _localizationDelegates => [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ];

  Locale? _localeResolution(Locale? locale, Iterable<Locale> supportedLocales) {
    return supportedLocales.contains(locale)
        ? locale
        : const Locale('en', 'US');
  }
}

class _InitProviders extends StatelessWidget {
  const _InitProviders({
    super.key,
    required this.child,
    required this.userId,
  });

  final Widget child;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => StorageFirebaseProvider(
            userId: userId,
          ),
        ),
        RepositoryProvider(
          create: (context) => ChatFirebaseProvider(
            userId: userId,
          ),
        ),
        RepositoryProvider(
          create: (context) => MessageFirebaseProvider(
            userId: userId,
          ),
        ),
        RepositoryProvider(
          create: (context) => TagFirebaseProvider(
            userId: userId,
          ),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(
            chatProvider: context.read<ChatFirebaseProvider>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TagRepository(
            tagProvider: context.read<TagFirebaseProvider>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TextTagRepository(
            textTagFirebaseProvider: TextTagFirebaseProvider(
              userId: userId,
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
