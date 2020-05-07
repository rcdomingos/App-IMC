import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo IMC',
      debugShowCheckedModeBanner: false, //remover o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Cálculo IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _ctrPeso = new TextEditingController();
  var _ctrAltura = new TextEditingController();
  String _retorno = '';
  String _retornoHelp = '';
  Color _corTexto = Colors.green;
  //Criar um chave unica para elemtno
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: limparCampos)
        ],
        title: Center(child: Text(widget.title)),
      ),
      //corpo do app
      body: ListView(
        children: <Widget>[
          Form(
              //todo Form deve tes um KEY
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Center(
                      child: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 120,
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50, top: 20, right: 50, bottom: 20),
                    child: TextFormField(
                      controller: _ctrPeso,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Peso (Kg)',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe seu Peso';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50, top: 20, right: 50, bottom: 20),
                    child: TextFormField(
                      controller: _ctrAltura,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe sua Altura';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50, top: 20, right: 50, bottom: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black,
                        //     blurRadius: 5.0, // soften the shadow
                        //     spreadRadius: 2.0, //extend the shadow
                        //     offset: Offset(
                        //       2.0, // Move to right 10  horizontally
                        //       2.0, // Move to bottom 5 Vertically
                        //     ),
                        //   )
                        // ],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            calcularIMC();
                          }
                        },
                        child: Text('CÁLCULAR'),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _retorno,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _corTexto),
                    ),
                  ),
                  Center(
                    child: Text(
                      _retornoHelp,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ), //setar separadamente os espaços
                ],
              ))
        ],
      ),
    );
  }

  //METODOS UTILIZADOS
  //metodo para limpar os campos e resetar o estado do app
  limparCampos() {
    setState(() {
      _formKey.currentState.reset();
      _ctrPeso = new TextEditingController();
      _ctrAltura = new TextEditingController();
      _retorno = '';
      _retornoHelp = '';
    });
  }

  //Metodo para Calcular o IMC
  calcularIMC() {
    //formula: IMC=PESO / (ALTURA * ALTURA)
    var peso = double.parse(_ctrPeso.text.replaceAll('.', ''));
    var altura = double.parse(_ctrAltura.text.replaceAll('.', '')) / 100;
    var resultado = peso / (altura * altura);

    setState(() {
      //_retorno = resultado.toStringAsFixed(1);

      if (resultado > 0 && resultado < 15) {
        _retorno = 'ABAIXO DO PESO I';
        _corTexto = Colors.red;
        _retornoHelp =
            'Anorexia, Bulimia, Osteoporose e auto consumo de massa Muscular';
      } else if (resultado >= 15 && resultado < 18.5) {
        _retorno = 'ABAIXO DO PESO';
        _corTexto = Colors.yellow;
        _retornoHelp =
            'Transtorno digestivo, debilidade, fadiga crônica, Stress';
      } else if (resultado >= 18.5 && resultado <= 24.9) {
        _retorno = 'PESO NORMAL';
        _corTexto = Colors.green;
        _retornoHelp =
            'Em bom estado geral, vai viver bastante se continuar assim';
      } else if (resultado >= 25 && resultado <= 29.9) {
        _retorno = 'ACIMA DO PESO';
        _corTexto = Colors.yellow;
        _retornoHelp = 'Fadiga, problemas digestivo, etc... procure um medico';
      } else if (resultado >= 30 && resultado <= 39.9) {
        _retorno = 'OBESIDADE I';
        _corTexto = Colors.orange;
        _retornoHelp = 'Diabetes, enfarto, corre para o medico';
      } else if (resultado >= 40) {
        _retorno = 'OBSEDIDADE II';
        _corTexto = Colors.red;
        _retornoHelp = 'ja assistiu kilos mortais ?';
      } else {
        _retorno = '';
      }
    });
  }
}

// INDICES DO RESULTADO
// < 18.5 MAGRO
// >= 18.5 E <= 24.9 NORMAL
// >= 25 E <= 29.9 SOBREPESO
// >= 30 E <= 39.9  OBSEDIDADE
// >= 40 OBSIDADE GRAVE
