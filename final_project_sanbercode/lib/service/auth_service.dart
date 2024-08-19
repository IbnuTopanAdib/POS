import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_sanbercode/model/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  User? _user;

  User? get user => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> register(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        final userProfile = UserProfile(
          uid: _user!.uid,
          email: email,
          ppURL: null,
          name: name,
          phoneNumber: phoneNumber,
        );
        await createUserProfile(userProfile: userProfile);

        await _firebaseAuth.signOut();

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    try {
      await _userCollection.doc(userProfile.uid).set(userProfile.toJson());
    } catch (e) {
      print(e);
    }
  }

  Stream<UserProfile?> getUserProfileStream() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return _userCollection.doc(user.uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserProfile.fromJson(snapshot.data()! as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } else {
      return Stream.value(null);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }
}
