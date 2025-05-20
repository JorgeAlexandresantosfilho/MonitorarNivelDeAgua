class LogModel {
  final String tpacao;
  final String loginusuario;
  final String datacao;
  final String? idregistro;
  final String? dsregold;
  final String? dsregnew;
  final String? tpacaoregold;
  final String? tpacaoregnew;
  final String? nomeusuarioold;
  final String? nomeusuarionew;

  LogModel({
    required this.tpacao,
    required this.loginusuario,
    required this.datacao,
    this.idregistro,
    this.dsregold,
    this.dsregnew,
    this.tpacaoregold,
    this.tpacaoregnew,
    this.nomeusuarioold,
    this.nomeusuarionew,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      tpacao: json['tpacao'] ?? '',
      loginusuario: json['loginusuario'] ?? '',
      datacao: json['datacao'] ?? '',
      idregistro: json['idregistro'],
      dsregold: json['dsregold'],
      dsregnew: json['dsregnew'],
      tpacaoregold: json['tpacaoregold'],
      tpacaoregnew: json['tpacaoregnew'],
      nomeusuarioold: json['nomeusuarioold'],
      nomeusuarionew: json['nomeusuarionew'],
    );
  }
}
