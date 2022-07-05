class Etiqueta {
  String? cliente;
  int? eSTADO;
  String? fACTURAFECHA;
  String? impreso;
  int? nROFACTURA;
  String? ptoExpID;
  String? tIMBRADOF;
  int? cantidad;
  int? etiqueta;
  int? solicitud;
  String? conerror;

  Etiqueta(
      {this.cliente,
      this.eSTADO,
      this.fACTURAFECHA,
      this.impreso,
      this.nROFACTURA,
      this.ptoExpID,
      this.tIMBRADOF,
      this.cantidad,
      this.etiqueta,
      this.solicitud,
      this.conerror});

  Etiqueta.fromJson(Map<String, dynamic> json) {
    cliente = json['Cliente'];
    eSTADO = json['ESTADO'];
    fACTURAFECHA = json['FACTURA_FECHA'];
    impreso = json['Impreso'];
    nROFACTURA = json['NRO_FACTURA'];
    ptoExpID = json['Pto_ExpID'];
    tIMBRADOF = json['TIMBRADO_F'];
    cantidad = json['cantidad'];
    etiqueta = json['etiqueta'];
    solicitud = json['solicitud'];
    conerror = json['conerror'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cliente'] = cliente;
    data['ESTADO'] = eSTADO;
    data['FACTURA_FECHA'] = fACTURAFECHA;
    data['Impreso'] = impreso;
    data['NRO_FACTURA'] = nROFACTURA;
    data['Pto_ExpID'] = ptoExpID;
    data['TIMBRADO_F'] = tIMBRADOF;
    data['cantidad'] = cantidad;
    data['etiqueta'] = etiqueta;
    data['solicitud'] = solicitud;
    data['conerror'] = conerror;
    return data;
  }
}
