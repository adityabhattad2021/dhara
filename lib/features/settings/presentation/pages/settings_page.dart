import 'package:dhara/features/auth/presentation/bloc/auth_event.dart';
import 'package:dhara/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/main_navigation.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Logout'),
          )
        ],
      )
    );

    if(result == true && context.mounted){
      context.read<AuthBloc>().add(const AuthSignOutRequested());
    }
  }

  @override
  Widget build(BuildContext context){
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state){
        if(state is AuthError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logut failed: ${state.message}'),
              backgroundColor: Colors.red,
            )
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const SizedBox(height: 40,),
            const Icon(Icons.settings,size: 80,color: Colors.orange,),
            const SizedBox(height: 24,),
            const Text(
              'Settings',
              style: TextStyle(fontSize:24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Profile manangment and app preferences',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16,color:Colors.grey),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette,color: Colors.orange,),
                    title: const Text('Theme'),
                    subtitle: const Text('Light Mode'),
                    trailing: const Icon(Icons.arrow_forward_ios,size: 16,),
                    onTap: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Theme switching coming soon!'))
                      );
                    },
                  ),
                  const Divider(),
                  BlocBuilder<AuthBloc,AuthState>(
                    builder:(context,state){
                      final isLoading = state is AuthLoading;

                      return ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: isLoading ? Colors.grey : Colors.red,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: isLoading ? Colors.grey : Colors.red,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: const Text('Sign out of your account'),
                        trailing:  isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2,),
                          ) : const Icon(Icons.arrow_forward_ios,size: 16,color: Colors.red,),
                        onTap: isLoading ? null : () => _showLogoutDialog(context),
                      );
                    }
                  )
                ]
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
        bottomNavigationBar: const MainNavigation(),
      ),
    );
  }
}
