// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _passwordController = TextEditingController();

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.medical_services, size: 80, color: Colors.blue),
//               const SizedBox(height: 20),
//               const Text(
//                 'Consultorio Odontológico',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Contraseña',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 onSubmitted: (_) => _login(context, authProvider),
//               ),
//               const SizedBox(height: 20),
//               if (authProvider.error != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Text(
//                     authProvider.error!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: authProvider.isLoading
//                       ? null
//                       : () => _login(context, authProvider),
//                   child: authProvider.isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Ingresar'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _login(BuildContext context, AuthProvider authProvider) async {
//     final success = await authProvider.login(_passwordController.text);
//     if (success && context.mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso Odontológico')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services, size: 80, color: Colors.blue),
            const SizedBox(height: 40),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Contraseña maestra',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (authProvider.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: () => _login(context, authProvider),
                icon: const Icon(Icons.login),
                label: const Text('Ingresar'),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
            if (authProvider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(authProvider.error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context, AuthProvider provider) async {
    final success = await provider.login(_passwordController.text);
    if (success && context.mounted) {
      context.go('/home');
    }
  }
}