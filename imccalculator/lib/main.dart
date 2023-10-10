import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(IMCCalculatorApp());
}

class IMCCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  double peso = 0.0;
  double altura = 0.0;
  List<String> historico = [];
  @override
  void initState() {
    super.initState();
    // Recupere o valor da altura do SharedPreferences
    _getAlturaFromSharedPreferences();
  }

  // Método para recuperar o valor da altura do SharedPreferences
  _getAlturaFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedAltura = prefs.getDouble('altura') ?? 0.0;
    setState(() {
      altura = savedAltura;
    });
  }

  void calcularIMC() async {
    if (peso > 0 && altura > 0) {
      double imc = peso / (altura * altura);
      String estadoPeso;

      // ... Resto do seu código para calcular o IMC ...

      String resultado = "IMC: ${imc.toStringAsFixed(2)} - $estadoPeso";

      setState(() {
        historico.add(resultado);
      });

      // Salve o valor da altura no SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('altura', altura);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: ListView.builder(
        itemCount: historico.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(historico[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Informe seu peso e altura:'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Peso (kg)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        peso = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Altura (m)'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: altura
                              .toString()), // Preenche a caixa de texto com o valor da altura
                      onChanged: (value) {
                        altura = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      calcularIMC();
                      Navigator.of(context).pop();
                    },
                    child: Text('Calcular'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
