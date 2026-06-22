import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/home/models/home_glucose_summary_view_model.dart';
import 'package:smart_xdrip/plugins/home/widgets/home_hero_glucose_card.dart';

void main() {
  const glucose = HomeGlucoseSummaryViewModel(
    value: '7.4',
    unit: 'mmol/L',
    trendArrow: '->',
    trendLabel: 'Flat',
    rateText: '+0.00 mmol/L',
    timestampText: 'Just now',
  );

  testWidgets('normal state keeps the current glucose prominent',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeHeroGlucoseCard(glucose: glucose),
        ),
      ),
    );

    expect(find.text('7.4'), findsOneWidget);
    expect(find.text('INSPECTING PAST - release for now'), findsOneWidget);

    final opacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity).first,
    );
    expect(opacity.opacity, 1);
  });

  testWidgets('inspecting state dims current value and shows past badge',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeHeroGlucoseCard(
            glucose: glucose,
            inspectingPast: true,
          ),
        ),
      ),
    );

    final opacities = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .map((widget) => widget.opacity)
        .toList();

    expect(opacities, contains(0.35));
    expect(opacities, contains(1));
    expect(find.text('INSPECTING PAST - release for now'), findsOneWidget);
  });

  testWidgets('inspection badge follows Chinese locale', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('zh'),
        supportedLocales: [Locale('en'), Locale('zh')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: HomeHeroGlucoseCard(
            glucose: glucose,
            inspectingPast: true,
          ),
        ),
      ),
    );

    expect(find.text('正在查看历史 - 松开后恢复'), findsOneWidget);
  });
}
