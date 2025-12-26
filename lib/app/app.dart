import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:okazyon_mobile/core/providers/locale_provider.dart';
import 'package:okazyon_mobile/core/providers/theme_provider.dart';
import 'package:okazyon_mobile/core/theme/theme.dart' as app_theme;
import 'package:okazyon_mobile/features/onboarding/presentation/screens/splash_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // final locale = ref.watch(localeProvider);
    // final isRtl = locale?.languageCode == 'ar';

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard iPhone design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Okazyon',
          theme: app_theme.AppTheme.lightTheme,
          darkTheme: app_theme.AppTheme.darkTheme,
          themeMode: themeMode,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          builder: (context, child) {
            final isRTL = context.locale.languageCode == 'ar';
            final baseTheme =
                isRTL
                    ? Theme.of(context).copyWith(
                      textTheme: GoogleFonts.almaraiTextTheme(
                        Theme.of(context).textTheme,
                      ),
                    )
                    : Theme.of(context).copyWith(
                      textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme,
                      ),
                    );
            return Theme(data: baseTheme, child: child!);
          },
          home: const SplashScreen(),
        );
      },
      child: const SplashScreen(),
    );
  }
}
