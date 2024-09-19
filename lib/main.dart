import 'dart:async'; // For the Timer
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;

  Timer? _hungerTimer;
  Timer? _winTimer;
  final TextEditingController _nameController = TextEditingController();
  bool _winConditionMet = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    _nameController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        if (hungerLevel == 100) {
          happinessLevel = (happinessLevel - 20).clamp(0, 100);
        }
        _checkLossCondition();
      });
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
    _checkWinCondition();
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
    _checkLossCondition();
  }

  void _checkWinCondition() {
    if (happinessLevel > 80) {
      _winTimer?.cancel();
      _winTimer = Timer(Duration(seconds: 5), () {
        setState(() {
          _winConditionMet = true;
        });
        _showMessage('You Win! Your pet is very happy.');
      });
    } else {
      _winTimer?.cancel();
    }
  }

  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      _showMessage('Game Over! Your pet is too hungry and unhappy.');
      _resetGame();
    }
  }

  void _setName() {
    setState(() {
      petName = _nameController.text;
    });
  }

  void _resetGame() {
    setState(() {
      hungerLevel = 50;
      happinessLevel = 50;
      _winConditionMet = false;
    });
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral
    } else {
      return Colors.red;
    }
  }

  String _getPetMood() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😟";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Name: $petName',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Enter Pet Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _setName,
                child: Text('Set Pet Name'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 32.0),
              Container(
                width: 100,
                height: 100,
                color: _getPetColor(),
                child: Center(
                  child: Text(
                    _getPetMood(),
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
