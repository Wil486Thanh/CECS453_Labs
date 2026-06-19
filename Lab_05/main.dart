import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) =>
        MortgageCalculator(amount: 100000, rate: 0.035, years: 30),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: MainScreen(),
    );
  }
}

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> rates = [
      for (double x = 0.02; x <= 0.15; x += 0.0025) x,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Set Interest Rate")),
      body: Center(
        child: ListView.builder(
          padding: .all(8),
          itemCount: rates.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimatedContainer(
              height: 50,
              duration: const Duration(seconds: 2),
              child: Material(
                child: InkWell(
                  child: Text(rates[index].toStringAsFixed(4)),
                  onTap: () {
                    Navigator.of(context).pop(rates[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
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
    MortgageCalculator calc = context.watch<MortgageCalculator>();

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
                              return AlertDialog(
                                content: Text(
                                  "Confirmed Terms and Conditions!",
                                ),
                              );
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
                Navigator.push(
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
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  double _rateValue = 0.035;

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _yearController.dispose();
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
                      child: TextButton(
                        onPressed: () async {
                          final rateValue = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RateScreen(),
                            ),
                          );
                          setState(() {
                            {
                              _rateValue = rateValue;
                            }
                          });
                        },
                        child: Text(_rateValue.toStringAsFixed(4)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("DONE"),
              onPressed: () {
                // apply changes to the calculator
                MortgageCalculator calc = context.read<MortgageCalculator>();
                calc.amount = double.tryParse(_amountController.text) ?? 0.0;
                calc.rate = _rateValue;
                calc.years = int.tryParse(_yearController.text) ?? 0;

                // return to previous screen
                Navigator.pop(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => MainScreen(),
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

class MortgageCalculator extends ChangeNotifier {
  double _amount;
  double _rate;
  int _years;

  // the assert call at the bottom validates the values
  MortgageCalculator({
    required this._amount,
    required this._rate,
    required this._years,
  }) : assert(_amount >= 0 && _rate >= 0 && _years >= 0); 
  

  // notify listeners when changing the value
  void set amount(double newValue) {
    _amount = newValue;
    notifyListeners();
  }

  void set rate(double newValue) {
    _rate = newValue;
    notifyListeners();
  }

  void set years(int newValue) {
    _years = newValue;
    notifyListeners();
  }
  
  double get amount => _amount;
  double get rate => _rate;
  int get years => _years;

  String get amountFormatted {
    return '\$${this._amount.toStringAsFixed(2)}';
  }

  String get rateFormatted {
    return '${(this._rate * 100).toStringAsFixed(2)}%';
  }

  int get months {
    return this._years * 12;
  }

  double get monthRate {
    return this._rate / 12;
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
    return this.monthlyPayment * 12 * this._years;
  }

  String get totalPaymentFormatted {
    return '\$${this.totalPayment.toStringAsFixed(2)}';
  }
}
