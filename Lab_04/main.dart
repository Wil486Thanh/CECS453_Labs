import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affirmations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _selectedYear;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Modify Data'),
              onPressed: () async {
                final selectedYear = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ModifyDataScreen()),
                );
                setState(() {
                  _selectedYear = selectedYear;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Selected Pizza: $_selectedYear')
          ],
        ),
      ),
    );
  }
}

class ModifyDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify Data")
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Go back"),
        ),
      ),
    );
  }
}

class MortgageCalculator {
  double amount;
  double rate;
  int years;

  // the assert call at the bottom validates the values
  MortgageCalculator({
    required this.amount,
    required this.rate,
    required this.years,
  }) : assert(years >= 0 && amount >= 0 && rate >= 0);

  int get months {
    return this.years * 12;
  }
  
  double get monthRate {
    return this.rate / 12;
  }

  double get monthlyPayment {
    double periodRate = pow(1+this.monthRate, this.months) as double;
    double finalValue = this.amount * ((this.monthRate*periodRate)/(periodRate-1));
   
    return finalValue;
  }
  
  String get monthlyPaymentFormatted {
    return '\$${this.monthlyPayment.toStringAsFixed(2)}';
  }
  
  double get totalPayment {
    return this.monthlyPayment * 12 * this.years;
  }
  
  String get totalPaymentFormatted {
    return '\$${this.totalPayment.toStringAsFixed(2)}';
  }
}
