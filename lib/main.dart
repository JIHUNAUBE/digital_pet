import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
String get _petMessage {
  if (_gameOver) return 'I need a rest.';
  if (_hasWon) return 'Best day ever!';
  if (_hunger > 80) return "I'm starving!";
  if (_happiness <= 30) return 'Play with me?';
  if (_energy < 20) return 'So sleepy...';
  return "Hi, I'm $_petName!";
}

double get _petScale => _happiness > 70 ? 1.06 : _happiness < 30 ? 0.94 : 1.0;

Color get _moodColor {
  if (_happiness > 70) return Colors.green;
  if (_happiness >= 30) return Colors.yellow;
  return Colors.red;
}

// In build(BuildContext context):
final reduceMotion = MediaQuery.of(context).disableAnimations;

AnimatedScale(
  scale: _petScale,
  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
  curve: Curves.easeOutBack,
  child: ColorFiltered(
    colorFilter: ColorFilter.mode(_moodColor, BlendMode.modulate),
    child: Image.asset('assets/pet.png'),
  ),
)

AnimatedSwitcher(
  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 300),
  child: Text(_petMessage, key: ValueKey(_petMessage)),
)

TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: _happiness / 100),
  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 400),
  curve: Curves.easeOut,
  builder: (context, value, _) => LinearProgressIndicator(value: value),
)