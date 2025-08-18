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
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/expenses/data/database/app_database.dart';
import 'features/expenses/data/datasources/expense_local_data_source.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/usecases/add_expense.dart';
import 'features/expenses/domain/usecases/get_expenses.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize database
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  
  runApp(DharaApp(database: database));
}

class DharaApp extends StatelessWidget {
  final AppDatabase database;
  
  const DharaApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => _createAuthBloc(),
        ),
        BlocProvider<ExpenseBloc>(
          create: (context) => _createExpenseBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Dhara - Where money flows',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AppRoutes.dashboard,
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
    final authBloc = AuthBloc(
      signInWithGoogle: signInWithGoogle,
      signOut: signOut,
      getCurrentUser: getCurrentUser,
    );

    // Trigger initial authentication check
    authBloc.add(const AuthStarted());
    
    return authBloc;
  }

  ExpenseBloc _createExpenseBloc() {
    // Create data source
    final expenseDao = database.expenseDao;
    final expenseDataSource = ExpenseLocalDataSourceImpl(expenseDao: expenseDao);

    // Create repository
    final expenseRepository = ExpenseRepositoryImpl(localDataSource: expenseDataSource);

    // Create use cases
    final addExpense = AddExpense(expenseRepository);
    final getExpenses = GetExpenses(expenseRepository);

    // Create and return BLoC
    return ExpenseBloc(
      addExpense: addExpense,
      getExpenses: getExpenses,
    );
  }
}
