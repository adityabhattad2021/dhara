import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'features/auth/data/datasources/firebase_auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DharaApp());
}

class DharaApp extends StatelessWidget {
  const DharaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhara - Where money flows',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => _createAuthBloc(),
        child: const AuthWrapper(),
      ),
    );
  }

  AuthBloc _createAuthBloc() {
    // Create Firebase instances
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    // Create data source
    final authDataSource = FirebaseAuthDataSourceImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );

    // Create repository
    final authRepository = AuthRepositoryImpl(authDataSource);

    // Create use cases
    final signInWithGoogle = SignInWithGoogle(authRepository);
    final signOut = SignOut(authRepository);
    final getCurrentUser = GetCurrentUser(authRepository);

    // Create and return BLoC
    return AuthBloc(
      signInWithGoogle: signInWithGoogle,
      signOut: signOut,
      getCurrentUser: getCurrentUser,
    );
  }
}
