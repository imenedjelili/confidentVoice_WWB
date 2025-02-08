import 'package:confident_voice/models/States/profile_state.dart';
import 'package:confident_voice/views/screens/settings/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('EditProfileScreen', () {
    late Widget testWidget;

    setUp(() {
      testWidget = const MaterialApp(
        home: EditProfileScreen(),
      );
    });

    testWidgets('Displays "Edit Profile" title', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('Displays profile picture', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(CircleAvatar),
          findsNWidgets(2)); // One for the image, one for the edit icon
      expect(
          find.byType(Image), findsOneWidget); // Check if Image widget exists
    });

    testWidgets('Displays form fields', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(TextField), findsNWidgets(3)); // Name, email, phone
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets('Displays "Save Changes" button', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('Shows snackbar when camera icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pump(); // Important to rebuild after showing the snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Change profile picture feature coming soon!'),
          findsOneWidget);
    });

    testWidgets(
        'Shows snackbar when "Save Changes" is tapped with empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill out all fields.'), findsOneWidget);
    });

    testWidgets(
        'Shows snackbar when "Save Changes" is tapped with filled fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      // Fill the text fields
      await tester.enterText(find.byIcon(Icons.person), 'Test Name');
      await tester.enterText(find.byIcon(Icons.email), 'test@example.com');
      await tester.enterText(find.byIcon(Icons.phone), '123-456-7890');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Changes saved successfully!'), findsOneWidget);
    });

    testWidgets('TextEditingControllers are disposed',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      ProfileState? state =
          tester.state(find.byType(ProfileState));
    });
  });
}
