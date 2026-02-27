import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_state_provider.dart';

class ParentPinScreen extends StatefulWidget {
  const ParentPinScreen({super.key});

  @override
  State<ParentPinScreen> createState() => _ParentPinScreenState();
}

class _ParentPinScreenState extends State<ParentPinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isSettingPin = false;
  bool _isConfirming = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppStateProvider>();
    _isSettingPin = !appState.hasParentPin();
  }

  void _onDigitPressed(String digit) {
    setState(() {
      _errorMessage = null;
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          _confirmPin += digit;
          if (_confirmPin.length == 4) {
            _verifyConfirmation();
          }
        }
      } else {
        if (_pin.length < 4) {
          _pin += digit;
          if (_pin.length == 4 && !_isSettingPin) {
            _verifyPin();
          }
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      _errorMessage = null;
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  void _onSubmit() {
    if (_isSettingPin && _pin.length == 4 && !_isConfirming) {
      setState(() {
        _isConfirming = true;
      });
    }
  }

  void _verifyConfirmation() {
    if (_pin == _confirmPin) {
      context.read<AppStateProvider>().saveParentPin(_pin);
      context.go('/parent/dashboard');
    } else {
      setState(() {
        _errorMessage = 'PINs do not match. Try again.';
        _confirmPin = '';
        _isConfirming = false;
        _pin = '';
      });
    }
  }

  void _verifyPin() {
    final appState = context.read<AppStateProvider>();
    final savedPin = appState.getParentPin();
    if (_pin == savedPin) {
      context.go('/parent/dashboard');
    } else {
      setState(() {
        _errorMessage = 'Wrong PIN. Try again.';
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String currentInput;

    if (_isSettingPin) {
      if (_isConfirming) {
        title = 'Confirm your PIN';
        currentInput = _confirmPin;
      } else {
        title = 'Set a 4-digit PIN';
        currentInput = _pin;
      }
    } else {
      title = 'Enter PIN';
      currentInput = _pin;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
        ),
        title: Text(
          'Parent Zone \u{1F512}',
          style: GoogleFonts.balooTamma2(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                '\u{1F512}',
                style: TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.balooTamma2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              if (_isSettingPin)
                Text(
                  'Only parents should know this PIN',
                  style: GoogleFonts.balooTamma2(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              const SizedBox(height: 24),
              // PIN circles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < currentInput.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            isFilled ? AppColors.primaryBlue : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      child: isFilled
                          ? const Center(
                              child: Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Error message
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: GoogleFonts.balooTamma2(
                    fontSize: 16,
                    color: AppColors.wrongRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              // Number pad
              _buildNumberPad(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        // Row 1: 1 2 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numButton('1'),
            _numButton('2'),
            _numButton('3'),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: 4 5 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numButton('4'),
            _numButton('5'),
            _numButton('6'),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3: 7 8 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numButton('7'),
            _numButton('8'),
            _numButton('9'),
          ],
        ),
        const SizedBox(height: 12),
        // Row 4: backspace 0 submit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(
              icon: Icons.backspace_rounded,
              onTap: _onBackspace,
              color: AppColors.wrongRed,
            ),
            _numButton('0'),
            _actionButton(
              icon: Icons.check_rounded,
              onTap: _onSubmit,
              color: AppColors.correctGreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _numButton(String digit) {
    return GestureDetector(
      onTap: () => _onDigitPressed(digit),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.balooTamma2(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(77), width: 2),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 32),
        ),
      ),
    );
  }
}
