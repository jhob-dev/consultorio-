import 'package:consultorio/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes a valid API base URL for mobile devices', () {
    expect(ApiConstants.baseUrl, isNotEmpty);
    expect(ApiConstants.baseUrl, contains('/api_odontologia'));
    expect(ApiConstants.baseUrl.startsWith('http://') || ApiConstants.baseUrl.startsWith('https://'), isTrue);
  });
}
