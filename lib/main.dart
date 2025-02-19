import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  State<DigitalPetApp> createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet"; // Default pet name
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50; // New state variable for energy level
  final TextEditingController nameController = TextEditingController();
  Timer? _hungerTimer;
  Timer? _happinessTimer;
  Timer? _winTimer;
  String selectedActivity = "Play"; // Default activity
  bool gameOver = false;
  bool gameWon = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startHappinessTimer();
    _startWinTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _happinessTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        if (hungerLevel == 100) {
          happinessLevel = (happinessLevel - 20).clamp(0, 100);
        }
        _checkLossCondition();
      });
    });
  }

  void _startHappinessTimer() {
    _happinessTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        if (hungerLevel >= 70) {
          // If the pet is hungry, happiness decreases over time
          happinessLevel = (happinessLevel - 5).clamp(0, 100);
        } else if (hungerLevel < 70 && happinessLevel < 100) {
          // If the pet is not hungry, happiness increases slightly
          happinessLevel = (happinessLevel + 2).clamp(0, 100);
        }
        _checkLossCondition();
      });
    });
  }

  void _startWinTimer() {
    _winTimer = Timer.periodic(Duration(seconds: 180), (timer) {
      setState(() {
        if (happinessLevel > 80) {
          gameWon = true;
          _winTimer?.cancel();
        }
      });
    });
  }

  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        gameOver = true;
        _hungerTimer?.cancel();
        _happinessTimer?.cancel();
      });
    }
  }

  Color get petColor {
    if (happinessLevel > 70 && hungerLevel < 70) {
      return Colors.green;
    } else if (happinessLevel >= 30 && hungerLevel < 70) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String get petMood {
    if (hungerLevel >= 70) {
      return 'Hungry 😫'; // Pet is hungry, so mood is unhappy
    } else if (happinessLevel > 70) {
      return 'Happy 😊';
    } else if (happinessLevel >= 30) {
      return 'Neutral 😐';
    } else {
      return 'Unhappy 😞';
    }
  }

  void _performSelectedActivity() {
    setState(() {
      switch (selectedActivity) {
        case "Play":
          happinessLevel = (happinessLevel + 10).clamp(0, 100);
          energyLevel = (energyLevel - 10).clamp(0, 100);
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          break;
        case "Feed":
          hungerLevel = (hungerLevel - 10).clamp(0, 100);
          energyLevel = (energyLevel + 5).clamp(0, 100);
          break;
        case "Nap":
          energyLevel = (energyLevel + 20).clamp(0, 100);
          happinessLevel = (happinessLevel + 5).clamp(0, 100);
          break;
      }
      _checkLossCondition();
    });
  }

  void _setPetName() {
    setState(() {
      petName = nameController.text.isNotEmpty ? nameController.text : "Your Pet";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (gameOver)
              Column(
                children: [
                  Text(
                    'Game Over! 😢',
                    style: TextStyle(fontSize: 30, color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameOver = false;
                        happinessLevel = 50;
                        hungerLevel = 50;
                        energyLevel = 50;
                        _startHungerTimer();
                        _startHappinessTimer();
                      });
                    },
                    child: Text('Restart Game'),
                  ),
                ],
              )
            else if (gameWon)
              Column(
                children: [
                  Text(
                    'You Won! 🎉',
                    style: TextStyle(fontSize: 30, color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameWon = false;
                        happinessLevel = 50;
                        hungerLevel = 50;
                        energyLevel = 50;
                        _startHungerTimer();
                        _startHappinessTimer();
                      });
                    },
                    child: Text('Play Again'),
                  ),
                ],
              )
            else ...[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: petColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 16.0),
              if (petName == "Your Pet")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Enter Pet Name'),
                      ),
                      ElevatedButton(
                        onPressed: _setPetName,
                        child: Text('Confirm Name'),
                      ),
                    ],
                  ),
                ),
              if (petName != "Your Pet")
                Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text('Mood: $petMood', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
              LinearProgressIndicator(
                value: energyLevel / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: selectedActivity,
                items: ["Play", "Feed", "Nap"].map((String activity) {
                  return DropdownMenuItem<String>(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedActivity = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _performSelectedActivity,
                child: Text('Do Activity'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
