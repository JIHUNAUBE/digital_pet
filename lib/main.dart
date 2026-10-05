import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary values so the app can run.
    const bool gameOver = false;
    const bool hasWon = false;
    const double hunger = 50;
    const double happiness = 50;
    const double energy = 50;
    const String petName = 'Pet';

    String petMessage;
    if (gameOver) {
      petMessage = 'I need a rest.';
    } else if (hasWon) {
      petMessage = 'Best day ever!';
    } else if (hunger > 80) {
      petMessage = "I'm starving!";
    } else if (happiness <= 30) {
      petMessage = 'Play with me?';
    } else if (energy < 20) {
      petMessage = 'So sleepy...';
    } else {
      petMessage = "Hi, I'm $petName!";
    }

    final petScale =
        happiness > 70 ? 1.06 : happiness < 30 ? 0.94 : 1.0;

    final moodColor = happiness > 70
        ? Colors.green
        : happiness >= 30
            ? Colors.yellow
            : Colors.red;

    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Digital Pet'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment:
MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: petScale,
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(moodColor, BlendMode.modulate),
                  child: Image.asset('assets/pet.png'),
                ),
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                child: Text(
                  petMessage,
                  key: ValueKey(petMessage),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 250,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: happiness / 100,
                  ),
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, _) =>
                      LinearProgressIndicator(value: value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}