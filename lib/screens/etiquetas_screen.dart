import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:web_etiquetas/helpers/globals.dart';
import 'package:flutter/material.dart';
import 'package:web_etiquetas/components/loader_component.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:web_etiquetas/helpers/api_helper.dart';
import 'package:web_etiquetas/models/etiqueta.dart';
import 'package:web_etiquetas/models/response.dart';
import 'package:intl/intl.dart';

class EtiquetasScreen extends StatefulWidget {
  const EtiquetasScreen({Key? key}) : super(key: key);

  @override
  _EtiquetasScreenState createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen> {
  List<Etiqueta> _movim = [];
  List<Etiqueta> _filter = [];
  List<Etiqueta> _datos = [];
  late String _fecini = '';
  late String _fecfin = '';
  bool _showLoader = false;
  String firstDate = '';
  String currentDate = '';
  int facturado = 0;
  int etiquetado = 0;
  bool _checkerror = false;
  late final DateTime _now = DateTime.now();
  final format = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadPreferences(context));
    _movim = _filter = _datos;
  }

  loadPreferences(context) {
    Timer.periodic(const Duration(minutes: 30), (timer) {
      //code to run on every 30 segundos
      _getEtiquetas();
    });
    if (_fecini == '' && _fecfin == '') {
      String ya = (_now.year.toString());
      String ma = (("0${_now.month}").toString())
          .substring((("0${_now.month}").toString()).length - 2);
      String di = ("01");
      String df = (("0${_now.day}").toString())
          .substring((("0${_now.day}").toString()).length - 2);
      setState(() {
        _fecini = ("$di/$ma/$ya").toString();
        _fecfin = ("$df/$ma/$ya").toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Control de Etiquetas'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _showLogo(),
                const SizedBox(
                  height: 10,
                ),
                _showTexBoxes(),
                const SizedBox(
                  height: 10,
                ),
                _showButtons(),
                const SizedBox(
                  height: 10,
                ),
                _getTitle(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Container(child: _getListView())
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(text: 'Cargando Datos... espere..')
              : Container(),
        ],
      ),
    );
  }

  Widget _showLogo() {
    return const Image(
      image: AssetImage('assets/logo.png'),
      width: 120,
      height: 120,
    );
  }

  Widget _showTexBoxes() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            // optional flex property if flex is 1 because the default flex is 1
            flex: 1,
            child: TextField(
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: "##/##/####",
                  filter: {
                    "#": RegExp(r'\d+|-|/'),
                  },
                )
              ],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: "ddmmaaaa",
                  labelText: 'Fecha Inicial',
                  labelStyle: TextStyle(color: Colors.black)),
              controller: TextEditingController()..text = _fecini,
              onChanged: (value) {
                _fecini = value;
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            // optional flex property if flex is 1 because the default flex is 1
            flex: 1,
            child: TextField(
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: "##/##/####",
                  filter: {
                    "#": RegExp(r'\d+|-|/'),
                  },
                )
              ],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: "ddmmaaaa",
                  labelText: 'Fecha Final',
                  labelStyle: TextStyle(color: Colors.black)),
              controller: TextEditingController()..text = _fecfin,
              onChanged: (value) {
                _fecfin = value;
              },
            ),
          ),
          // optional flex property if flex is 1 because the default flex is 1
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton.icon(
              onPressed: () {
                _getEtiquetas();
              },
              icon: const Icon(Icons.find_in_page_rounded),
              label: const Text("Buscar Datos"),
              style: ElevatedButton.styleFrom(primary: Global.lightBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showFacturadoButton(),
          const SizedBox(
            width: 20,
          ),
          _showCheckButton(),
          const SizedBox(
            width: 20,
          ),
          _showEtiquetadoButton(),
        ],
      ),
    );
  }

  Widget _showFacturadoButton() {
    return SizedBox(
      height: 50, //height of button
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Global.lightBlue;
          }),
        ),
        onPressed: () => {},
        //child: Text('Cantidada facturada - $facturado'),
        child: Text('Cantidada facturada - ${formatDecimal(facturado)}'),
      ),
    );
  }

  Widget _showCheckButton() {
    return SizedBox(
      height: 50,
      width: 400,
      child: CheckboxListTile(
        title: const Text('Click para ver Solo Lineas con Diferencias =>'),
        value: _checkerror,
        onChanged: (value) {
          setState(() {
            _checkerror = value!;
            _refreshMov(_checkerror);
          });
        },
      ),
    );
  }

  Future<void> _refreshMov(bool param) async {
    _filter = _datos;
    setState(() {
      if (param) {
        _movim = _filter.where((e) => e.conerror == 'S').toList();
      } else {
        _movim = _filter.where((e) => e.conerror != ' ').toList();
      }
    });
  }

  Widget _showEtiquetadoButton() {
    return SizedBox(
      height: 50, //height of button
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return (facturado == etiquetado)
                ? Global.lightBlue
                : const Color.fromARGB(255, 211, 151, 172);
          }),
        ),
        onPressed: () {},
        child: Text('Cantidada etiquetada - ${formatDecimal(etiquetado)}'),
      ),
    );
  }

  Future<void> _getEtiquetas() async {
    setState(() {
      _checkerror = false;
      _showLoader = true;
    });

    String fi = (_fecini.substring(6, 10) +
        _fecini.substring(3, 5) +
        _fecini.substring(0, 2));
    String ff = (_fecfin.substring(6, 10) +
        _fecfin.substring(3, 5) +
        _fecfin.substring(0, 2));

    Response2 response2 = await ApiHelper.getEtiqueta(fi, ff);

    setState(() {
      _showLoader = false;
    });

    if (!response2.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response2.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    // Suma lo facturado y etiquetado del array json
    int i = 0;
    int x = 0;
    int y = 0;
    for (i = 0; i < response2.result.length; i++) {
      //Solo suma las no anulados
      (response2.result[i].eSTADO.toString() == '1')
          ? x += response2.result[i].cantidad as int
          : x += 0;
      y += response2.result[i].etiqueta as int;
      // Bandera de fila con error
      if (response2.result[i].cantidad != response2.result[i].etiqueta &&
          response2.result[i].eSTADO.toString() == '1') {
        response2.result[i].conerror = 'S';
      } else {
        response2.result[i].conerror = 'N';
      }
    }

    setState(() {
      _movim = response2.result;
      _datos = response2.result;
      facturado = x;
      etiquetado = y;
    });
  }

  Widget _getTitle() {
    return Row(children: const <Widget>[
      SizedBox(
          width: 100,
          child: Text('Fecha',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 380,
          child: Text('Cliente',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 90,
          child: Text('Timbrado',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 100,
          child: Text('Pto.Exp.',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 90,
          child: Text('Nº Factura',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 90,
          child: Text('Facturado',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 100,
          child: Text('Solicitud',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 100,
          child: Text('Etiquetado',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 100,
          child: Text('Impreso',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
      SizedBox(
          width: 95,
          child: Text('Anulado?',
              style: TextStyle(
                height: 3.0,
                fontSize: 15.2,
                fontWeight: FontWeight.bold,
              ))),
    ]);
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getEtiquetas,
      child: ListView(
        shrinkWrap: true,
        children: _movim.map((e) {
          return Card(
            color: e.eSTADO == 2
                ? const Color.fromARGB(255, 193, 199, 76)
                : (e.cantidad != e.etiqueta && e.eSTADO == 1)
                    ? const Color.fromARGB(255, 211, 151, 172)
                    : const Color.fromARGB(255, 192, 197, 199),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80, child: Text(e.fACTURAFECHA.toString())),
                    SizedBox(width: 400, child: Text(e.cliente.toString())),
                    SizedBox(width: 100, child: Text(e.tIMBRADOF.toString())),
                    SizedBox(width: 100, child: Text(e.ptoExpID.toString())),
                    SizedBox(width: 100, child: Text(e.nROFACTURA.toString())),
                    SizedBox(width: 100, child: Text(e.cantidad.toString())),
                    SizedBox(width: 100, child: Text(e.solicitud.toString())),
                    SizedBox(width: 100, child: Text(e.etiqueta.toString())),
                    SizedBox(width: 30, child: Text(e.impreso.toString())),
                    Text((e.eSTADO! != 1) ? "Anulado" : ""),
                    //SizedBox(width: 10, child: Text(e.conerror.toString())),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String formatDecimal(int number) {
    if (number > -1000 && number < 1000) return number.toString();

    final String digits = number.abs().toString();
    final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) result.write(',');
    }
    return result.toString();
  }
}

class ExampleMask {
  final TextEditingController textController = TextEditingController();
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final TextInputType textInputType;

  ExampleMask(
      {required this.formatter,
      this.validator,
      required this.hint,
      required this.textInputType});
}
