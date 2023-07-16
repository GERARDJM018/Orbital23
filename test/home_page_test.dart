import 'package:flutter_test/flutter_test.dart';
import 'package:zenith/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:zenith/mock.dart';


main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('add action', (){

    final HomePage homeA = HomePage(MockFirebaseAuth(signedIn: true), FakeFirebaseFirestore());



  });

}