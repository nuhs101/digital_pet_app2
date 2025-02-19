import 'package:flutter/material.dart';

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
  final TextEditingController nameController =
      TextEditingController(); // Controller for name input

  Color get petColor {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String get petMood {
    if (happinessLevel > 70) {
      return 'Happy 😊'; // Mood when happiness is high
    } else if (happinessLevel >= 30) {
      return 'Neutral 😐'; // Mood when happiness is moderate
    } else {
      return 'Unhappy 😞'; // Mood when happiness is low
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(
        0,
        100,
      ); // Decrease energy when playing
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(
        0,
        100,
      ); // Increase energy when feeding
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    setState(() {
      if (hungerLevel < 30) {
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
      } else {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
      }
    });
  }

  void _updateHunger() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
      }
    });
  }

  void _setPetName() {
    setState(() {
      petName =
          nameController.text.isNotEmpty
              ? nameController.text
              : "Your Pet"; // Set custom name
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
            // Display pet's image with color based on happiness level
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: petColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 16.0),
            // Display input for pet name when it’s still default
            if (petName == "Your Pet")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController, // Controller for text input
                      decoration: InputDecoration(labelText: 'Enter Pet Name'),
                    ),
                    ElevatedButton(
                      onPressed: _setPetName, // Confirm name button
                      child: Text('Confirm Name'),
                    ),
                  ],
                ),
              ),
            // Display pet's name if it's set
            if (petName != "Your Pet")
              Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            // Display mood indicator
            Text(
              'Mood: $petMood', // Show the mood with emoji
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            // Display happiness and hunger levels
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            // Display energy level with progress bar
            Text(
              'Energy Level: $energyLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            LinearProgressIndicator(
              value: energyLevel / 100, // Represents energy as a progress bar
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 32.0),
            // Buttons to play and feed the pet
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: _feedPet, child: Text('Feed Your Pet')),
          ],
        ),
      ),
    );
  }
}
