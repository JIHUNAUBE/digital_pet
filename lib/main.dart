import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Pet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const DigitalPetPage(),
    );
  }
}

class DigitalPetPage extends StatefulWidget {
  const DigitalPetPage({super.key});

  @override
  State<DigitalPetPage> createState() => _DigitalPetPageState();
}

class _DigitalPetPageState extends State<DigitalPetPage> {
  // ----------------------------
  // TEAM 1 - CARE SYSTEM
  // ----------------------------

  double _happiness = 50;
  double _hunger = 50;

  bool _gameOver = false;
  bool _hasWon = false;

  Timer? _hungerTimer;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  // Hunger increases every 30 seconds.
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (_gameOver || _hasWon) {
          return;
        }

        setState(() {
          _hunger += 5;

          if (_hunger > 100) {
            _hunger = 100;
          }

          _checkGameStatus();
        });
      },
    );
  }

  // Feed the pet.
  void _feedPet() {
    if (_gameOver || _hasWon) {
      return;
    }

    setState(() {
      _hunger -= 15;
      _happiness += 5;

      if (_hunger < 0) {
        _hunger = 0;
      }

      if (_happiness > 100) {
        _happiness = 100;
      }

      _checkGameStatus();
    });
  }

  // Play with the pet.
  void _playPet() {
    if (_gameOver || _hasWon) {
      return;
    }

    setState(() {
      _happiness += 15;
      _hunger += 5;

      if (_happiness > 100) {
        _happiness = 100;
      }

      if (_hunger > 100) {
        _hunger = 100;
      }

      _checkGameStatus();
    });
  }

  // Reset the game.
  void _resetGame() {
    setState(() {
      _happiness = 50;
      _hunger = 50;

      _gameOver = false;
      _hasWon = false;
    });
  }

  // Check win and game over conditions.
  void _checkGameStatus() {
    if (_hunger >= 100 || _happiness <= 0) {
      _gameOver = true;
    }

    if (_happiness >= 100 && _hunger <= 30) {
      _hasWon = true;
    }
  }

  // ----------------------------
  // TEAM 2 - PET REACTION SYSTEM
  // ----------------------------

  String get _petMessage {
    if (_gameOver) {
      return 'I did my best... I am sorry...';
    }

    if (_hasWon) {
      return 'We did it! You really are amazing!';
    }

    if (_hunger > 80) {
      return 'Hmmm do you think it would be okay if I eat something?';
    }

    if (_happiness <= 30) {
      return 'Hey! Hey! Spend time with me!';
    }

    return "Hehe, I'm so happy to see you! You make me so happy!";
  }

  Color get _moodColor {
    if (_happiness > 70) {
      return Colors.green;
    }

    if (_happiness >= 30) {
      return Colors.amber;
    }

    return Colors.red;
  }

  double get _petScale {
    if (_happiness > 70) {
      return 1.06;
    }

    if (_happiness < 30) {
      return 0.94;
    }

    return 1.0;
  }

  // ----------------------------
  // USER INTERFACE
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.of(context).disableAnimations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Pet name
            const Text(
              'Pip',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------
            // PET
            // ----------------------------

            AnimatedScale(
              scale: _petScale,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,

              child: AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),

                width: 120,
                height: 120,

                decoration: BoxDecoration(
                  color: _moodColor.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _moodColor,
                    width: 4,
                  ),
                ),

                child: Icon(
                  Icons.pets,
                  size: 65,
                  color: _moodColor,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------
            // PET MESSAGE
            // ----------------------------

            AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 300),

              child: Text(
                _petMessage,
                key: ValueKey(_petMessage),
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ----------------------------
            // HAPPINESS
            // ----------------------------

            Text(
              'Happiness: ${_happiness.toInt()}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: 250,

              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: _happiness / 100,
                ),

                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 400),

                curve: Curves.easeOut,

                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------
            // HUNGER
            // ----------------------------

            Text(
              'Hunger: ${_hunger.toInt()}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: 250,

              child: LinearProgressIndicator(
                value: _hunger / 100,
              ),
            ),

            const SizedBox(height: 30),

            // ----------------------------
            // GAME STATUS
            // ----------------------------

            if (_gameOver)
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

            if (_hasWon)
              const Text(
                'YOU WIN!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            if (_gameOver || _hasWon)
              const SizedBox(height: 20),

            // ----------------------------
            // BUTTONS
            // ----------------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed:
                      (_gameOver || _hasWon)
                          ? null
                          : _feedPet,

                  child: const Text('Feed'),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  onPressed:
                      (_gameOver || _hasWon)
                          ? null
                          : _playPet,

                  child: const Text('Play'),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}