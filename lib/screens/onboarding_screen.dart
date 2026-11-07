import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import '../theme/app_colors.dart';
import '../widgets/onboarding_item.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final PreferencesService _preferencesService = PreferencesService();

  int _currentPage = 0;
  bool _dontShowAgain = false;

  static const List<OnboardingItem> _pages = [
    OnboardingItem(
      imagePath: 'assets/images/logo.png',
      title: 'Bem-vindo à Saneia',
      description:
          'Esgoto a céu aberto, vazamento, falta d\'água ou bueiro entupido? '
          'Aqui você reporta problemas de saneamento da sua rua.',
    ),
    OnboardingItem(
      icon: Icons.add_location_alt,
      title: 'Reporte em segundos',
      description:
          'Escolha a categoria, o bairro e descreva o problema. '
          'Seu relato fica visível para a vizinhança e para o gestor.',
    ),
    OnboardingItem(
      icon: Icons.groups,
      title: 'A vizinhança confirma',
      description:
          'Toque em "Também vejo isso" nos relatos próximos. Quanto mais '
          'grave e confirmado, maior a prioridade para ser resolvido.',
    ),
    OnboardingItem(
      icon: Icons.track_changes,
      title: 'Acompanhe o status',
      description: 'Veja se o seu relato está aberto, em análise ou resolvido.',
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  void _next() {
    if (_isLastPage) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    // Salva a opção "Não mostrar novamente" escolhida pelo usuário.
    await _preferencesService.saveHideOnboarding(_dontShowAgain);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _dontShowAgain,
              onChanged: (value) {
                setState(() {
                  _dontShowAgain = value ?? false;
                });
              },
              title: const Text('Não mostrar novamente'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentPage == 0 ? null : _back,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _next,
                    icon: Icon(_isLastPage ? Icons.check : Icons.arrow_forward),
                    label: Text(_isLastPage ? 'Começar' : 'Avançar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
