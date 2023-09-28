import 'package:flutter/material.dart';

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

  void calcularIMC() {
    if (peso > 0 && altura > 0) {
      double imc = peso / (altura * altura);
      String estadoPeso;

      if (imc < 16) {
        estadoPeso = "Magreza grave";
      } else if (imc >= 16 && imc < 17) {
        estadoPeso = "Magreza moderada";
      } else if (imc >= 17 && imc < 18.5) {
        estadoPeso = "Magreza leve";
      } else if (imc >= 18.5 && imc < 25) {
        estadoPeso = "Saudável";
      } else if (imc >= 25 && imc < 30) {
        estadoPeso = "Sobrepeso";
      } else if (imc >= 30 && imc < 35) {
        estadoPeso = "Obesidade Grau I";
      } else if (imc >= 35 && imc < 40) {
        estadoPeso = "Obesidade Grau II";
      } else {
        estadoPeso = "Obesidade Grau III";
      }

      String resultado = "IMC: ${imc.toStringAsFixed(2)} - $estadoPeso";

      setState(() {
        historico.add(resultado);
      });
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
