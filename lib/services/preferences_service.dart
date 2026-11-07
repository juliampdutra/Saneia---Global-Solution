import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hideOnboardingKey = 'hide_onboarding';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  /// Retorna true se o usuário marcou "Não mostrar novamente".
  Future<bool> shouldHideOnboarding() async {
    return await _preferences.getBool(_hideOnboardingKey) ?? false;
  }

  Future<void> saveHideOnboarding(bool value) async {
    await _preferences.setBool(_hideOnboardingKey, value);
  }
}
