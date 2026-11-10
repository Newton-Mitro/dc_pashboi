import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/responsive_content.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class _MockThemeSelectorBloc
    extends MockBloc<ThemeSelectorEvent, ThemeSelectorState>
    implements ThemeSelectorBloc {}

void main() {
  testWidgets('renders selected theme background behind page content', (
    tester,
  ) async {
    final themeBloc = _MockThemeSelectorBloc();
    whenListen(
      themeBloc,
      const Stream<ThemeSelectorState>.empty(),
      initialState: BlueOceanTheme(),
    );
    addTearDown(themeBloc.close);

    await tester.pumpWidget(
      BlocProvider<ThemeSelectorBloc>.value(
        value: themeBloc,
        child: const MaterialApp(
          home: Scaffold(body: PageContainer(child: Text('Page content'))),
        ),
      ),
    );

    final backgroundImage = tester.widget<Image>(find.byType(Image).first);
    expect(
      (backgroundImage.image as AssetImage).assetName,
      'assets/images/bg/blue_ocean.png',
    );
    expect(find.text('Page content'), findsOneWidget);
    expect(find.byType(ResponsiveContent), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
