class ApiConstants {
  // Puedes sobrescribir la URL al ejecutar la app:
  // flutter run --dart-define=API_BASE_URL=http://192.168.1.50:8080/api_odontologia
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.100.11:8080/api_odontologia',
  );

  static const String login = '/login';
  static const String logout = '/logout';
  static const String pacientes = '/pacientes';
  static const String paciente = '/paciente'; // Se le agrega /{id}
  static const String pacienteCompleto = '/paciente'; // /{id}/completo
  static const String historias = '/historias';
  static const String citas = '/citas';
  static const String tratamientos = '/tratamientos';
  static const String odontogramas = '/odontogramas';
}