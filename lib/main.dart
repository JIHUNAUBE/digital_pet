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
          seedColor: Colors.blue,
        ),
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
  // -------------------------
  // PET STATE
  // -------------------------

  String _petName = 'Pip';

  int _happiness = 50;
  int _hunger = 50;

  bool _gameOver = false;
  bool _hasWon = false;

  Timer? _hungerTimer;
  Timer? _highMoodTimer;

  // -------------------------
  // INITIALIZE
  // -------------------------

  @override
  void initState() {
    super.initState();

    _startHungerTimer();
  }

  // -------------------------
  // KEEP VALUES 0 - 100
  // -------------------------

  int _clampMeter(int value) {
    return value.clamp(0, 100).toInt();
  }

  // -------------------------
  // FEED PET
  // -------------------------

  void _feedPet() {
    if (_gameOver || _hasWon) return;

    final nextHunger = _clampMeter(_hunger - 10);

    final happinessChange =
        nextHunger < 30 ? -20 : 10;

    final nextHappiness =
        _clampMeter(_happiness + happinessChange);

    setState(() {
      _hunger = nextHunger;
      _happiness = nextHappiness;
    });

    _updateOutcome();
  }

  // -------------------------
  // PLAY WITH PET
  // -------------------------

  void _playPet() {
    if (_gameOver || _hasWon) return;

    setState(() {
      _happiness = _clampMeter(_happiness + 10);
      _hunger = _clampMeter(_hunger + 5);
    });

    _updateOutcome();
  }

  // -------------------------
  // HUNGER TIMER
  // -------------------------

  void _startHungerTimer() {
    _hungerTimer?.cancel();

    _hungerTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || _gameOver || _hasWon) {
        timer.cancel();
        return;
      }

      setState(() {
        // PDF rule:
        // 95 -> 100 does NOT reduce happiness.
        // The NEXT tick while already at 100
        // reduces happiness by 20.
        if (_hunger + 5 > 100) {
          _hunger = 100;
          _happiness =
              _clampMeter(_happiness - 20);
        } else {
          _hunger += 5;
        }
      });

      _updateOutcome();
    });
  }

  // -------------------------
  // WIN / GAME OVER
  // -------------------------

  void _updateOutcome() {
    if (_gameOver || _hasWon) return;

    // GAME OVER
    if (_hunger == 100 && _happiness <= 10) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;

      _hungerTimer?.cancel();

      setState(() {
        _gameOver = true;
      });

      return;
    }

    // Happiness 80 or below:
    // cancel the win timer.
    if (_happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    // Happiness is above 80.
    // Start timer only if one is not already running.
    _highMoodTimer ??=
        Timer(const Duration(minutes: 3), () {
      _highMoodTimer = null;

      if (!mounted ||
          _gameOver ||
          _happiness <= 80) {
        return;
      }

      setState(() {
        _hasWon = true;
      });

      _hungerTimer?.cancel();
    });
  }

  // -------------------------
  // RESET GAME
  // -------------------------

  void _resetGame() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _highMoodTimer = null;

    setState(() {
      _happiness = 50;
      _hunger = 50;

      _gameOver = false;
      _hasWon = false;
    });

    _startHungerTimer();
  }

  // -------------------------
  // CLEAN UP TIMERS
  // -------------------------

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();

    super.dispose();
  }

  // -------------------------
  // SCREEN
  // -------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // PET NAME
            Text(
              _petName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // HAPPINESS
            Text(
              'Happiness: $_happiness',
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),

            // HUNGER
            Text(
              'Hunger: $_hunger',
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 30),

            // RESULT MESSAGE
            if (_hasWon)
              const Text(
                'You Win!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            if (_gameOver)
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

            const SizedBox(height: 30),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
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