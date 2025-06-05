import 'package:flutter_test/flutter_test.dart';
import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:stonwallet/src/core/utils/test/test_widget_controller.dart';
import 'package:stonwallet/src/feature/home/widget/home_screen.dart';
import 'package:stonwallet/src/feature/initialization/model/dependencies_container.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders correctly', (widgetTester) async {
      final controller = TestWidgetController(widgetTester);

      await controller.pumpWidget(
        const HomePage(),
        dependencies: const HomePageDependenciesContainer(),
      );

      expect(find.text('Welcome to Sizzle Starter!'), findsOneWidget);
    });
  });
}

/// {@template home_screen_dependencies_container}
/// Example of how to create a dependencies container for testing purposes.
///
/// If the dependency is dynamic, like mocks, you can pass them as parameters
/// to the constructor.
/// {@endtemplate}
base class HomePageDependenciesContainer extends TestDependenciesContainer {
  /// {@macro home_screen_dependencies_container}
  const HomePageDependenciesContainer();

  @override
  Logger get logger => const NoOpLogger();
}
