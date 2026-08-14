enum TipoBotao {
  defaultType('btn btn-sm btn-default'),
  info('btn btn-sm btn-info'),
  aviso('btn btn-sm btn-warning'),
  erro('btn btn-sm btn-danger'),
  primary('btn btn-sm btn-primary'),
  sucesso('btn btn-sm btn-success'),
  xDefault('btn btn-default'),
  xInfo('btn btn-info'),
  xAviso('btn btn-warning'),
  xErro('btn btn-danger'),
  xPrimary('btn btn-primary'),
  xSucesso('btn btn-success');

  final String code;
  const TipoBotao(this.code);

  bool get isSmall => code.contains('btn-sm');
  bool get isDanger => code.contains('btn-danger');
  bool get isWarning => code.contains('btn-warning');
  bool get isSuccess => code.contains('btn-success');
  bool get isInfo => code.contains('btn-info');
  bool get isPrimary => code.contains('btn-primary');
}
