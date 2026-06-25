import 'package:consultorio/core/network/api_cliente.dart';
import 'package:consultorio/presentation/screens/citas_screen.dart';
import 'package:consultorio/presentation/screens/paciente_detalle_screen.dart';
import 'package:consultorio/presentation/screens/paciente_form_screen.dart';
import 'package:consultorio/presentation/screens/tratamientos_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Providers
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/paciente_provider.dart';
import 'presentation/providers/historia_provider.dart';
import 'presentation/providers/cita_provider.dart';
import 'presentation/providers/tratamiento_provider.dart';
import 'presentation/providers/odontograma_provider.dart';

// Pantallas
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/pacientes/lista_pacientes_screen.dart';
import 'presentation/screens/historia_form_screen.dart';
import 'presentation/screens/cita_form_screen.dart';
import 'presentation/screens/tratamiento_form_screen.dart';

void main() {
  ApiClient().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLogged = authProvider.isLoggedIn;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLogged && !isLoginRoute) return '/login';
    if (isLogged && isLoginRoute) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/pacientes', builder: (context, state) => const ListaPacientesScreen()),
    GoRoute(path: '/pacientes/nuevo', builder: (context, state) => const PacienteFormScreen()),
    GoRoute(
      path: '/pacientes/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PacienteDetalleScreen(pacienteId: id);
      },
      routes: [
        GoRoute(
          path: 'nueva-historia',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return HistoriaFormScreen(pacienteId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/citas/nueva',
      builder: (context, state) {
        final pacienteId = state.uri.queryParameters['paciente_id'] != null
            ? int.parse(state.uri.queryParameters['paciente_id']!)
            : null;
        return CitaFormScreen(pacienteId: pacienteId);
      },
    ),
    GoRoute(
      path: '/tratamientos/nuevo',
      builder: (context, state) {
        final pacienteId = state.uri.queryParameters['paciente_id'] != null
            ? int.parse(state.uri.queryParameters['paciente_id']!)
            : null;
        return TratamientoFormScreen(pacienteId: pacienteId);
      },
    ),
    // Agrega rutas para listar citas y tratamientos si es necesario
    GoRoute(path: '/citas', builder: (context, state) => const CitasScreen()),
    GoRoute(path: '/tratamientos', builder: (context, state) => const TratamientosScreen()),
  ],
);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
        ChangeNotifierProvider(create: (_) => HistoriaProvider()),
        ChangeNotifierProvider(create: (_) => CitaProvider()),
        ChangeNotifierProvider(create: (_) => TratamientoProvider()),
        ChangeNotifierProvider(create: (_) => OdontogramaProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Odontología',
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}