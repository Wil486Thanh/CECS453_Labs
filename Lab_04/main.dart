import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: ModifyDataScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    MortgageCalculator calc =
        ModalRoute.of(context)!.settings.arguments as MortgageCalculator;

    return Scaffold(
      appBar: AppBar(title: const Text("Main Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text("Amount: "),
                    const SizedBox(height: 25),
                    Text("Rate: "),
                    const SizedBox(height: 25),
                    Text("Years: "),
                    const SizedBox(height: 25),
                    Text("Monthly Payment: "),
                    const SizedBox(height: 25),
                    Text("Total Payment: "),
                    const SizedBox(height: 25),
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: Text("Confirmed Terms and Conditions!"));
                            },
                          );
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .end,
                  children: [
                    Text(calc.amountFormatted),
                    const SizedBox(height: 25),
                    Text(calc.rateFormatted),
                    const SizedBox(height: 25),
                    Text(calc.years.toString()),
                    const SizedBox(height: 25),
                    Text(calc.monthlyPaymentFormatted),
                    const SizedBox(height: 25),
                    Text(calc.totalPaymentFormatted),
                    const SizedBox(height: 30),
                    Text("Terms and Conditions"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              child: const Text('MODIFY DATA'),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ModifyDataScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ModifyDataScreen extends StatefulWidget {
  const ModifyDataScreen({super.key});

  @override
  State<ModifyDataScreen> createState() => _ModifyDataScreenState();
}

class _ModifyDataScreenState extends State<ModifyDataScreen> {
  MortgageCalculator calc = MortgageCalculator(
    amount: 100000,
    rate: 0.035,
    years: 30,
  );

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modify Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Text("Amount: "),
                    const SizedBox(height: 40),
                    const Text("Rate: "),
                    const SizedBox(height: 40),
                    const Text("Years: "),
                  ],
                ),
                Column(
                  crossAxisAlignment: .end,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextField(
                        controller: _rateController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text("CHANGE ME!!!!!!!!: "),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("DONE"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => MainScreen(),
                    settings: RouteSettings(
                      arguments: calc = MortgageCalculator(
                        amount:
                            (double.tryParse(_amountController.text) ?? 0.0),
                        rate: (double.tryParse(_rateController.text) ?? 0.0),
                        years: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MortgageCalculator {
  final double amount;
  final double rate;
  final int years;

  // the assert call at the bottom validates the values
  const MortgageCalculator({
    required this.amount,
    required this.rate,
    required this.years,
  }) : assert(years >= 0 && amount >= 0 && rate >= 0);

  String get amountFormatted {
    return '\$${this.amount.toStringAsFixed(2)}';
  }

  String get rateFormatted {
    return '${(this.rate * 100).toStringAsFixed(2)}%';
  }

  int get months {
    return this.years * 12;
  }

  double get monthRate {
    return this.rate / 12;
  }

  double get monthlyPayment {
    double periodRate = pow(1 + this.monthRate, this.months) as double;
    double finalValue =
        this.amount * ((this.monthRate * periodRate) / (periodRate - 1));

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
