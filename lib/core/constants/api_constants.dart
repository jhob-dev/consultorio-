class ApiConstants {
  // Cambia esta URL según tu servidor
  static const String baseUrl = 'http://10.0.2.2/api_odontologia';
  
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