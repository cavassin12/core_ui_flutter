import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';

/// Barra de progresso linear, equivalente ao `.progress` do Bootstrap:
/// progresso determinado (percentual conhecido) ou indeterminado (animação
/// contínua, quando [valor] é `null` — útil para carregamentos sem
/// percentual conhecido), com rótulo textual opcional.
///
/// Estende `PlatformWidget`, mas usa a mesma implementação em todas as
/// plataformas (é baseado no `LinearProgressIndicator` nativo do Flutter,
/// que já cobre a animação indeterminada sem necessidade de customização
/// por plataforma).
///
/// Uso básico:
/// ```dart
/// ProgressBarDefault(valor: 0.65, exibirPercentual: true)
///
/// // Indeterminado (percentual desconhecido)
/// ProgressBarDefault(rotulo: 'Enviando arquivo...')
/// ```
class ProgressBarDefault extends PlatformWidget {
  /// Progresso atual, de `0.0` a `1.0`. `null` = indeterminado (animação
  /// contínua, sem percentual).
  final double? valor;

  /// Altura da barra.
  final double altura;

  /// Cor preenchida da barra. Usa `context.design.corPrimaria` quando
  /// omitida.
  final Color? cor;

  /// Cor de fundo (trilha) da barra. Usa `context.design.corBorda` quando
  /// omitida.
  final Color? corFundo;

  /// Raio das bordas da barra. Usa `context.design.raioBorda` quando
  /// omitido.
  final double? raioBorda;

  /// Texto exibido acima da barra. Tem prioridade sobre [exibirPercentual].
  final String? rotulo;

  /// Exibe o percentual (`'65%'`) acima da barra, calculado a partir de
  /// [valor]. Ignorado quando [rotulo] é informado, ou quando [valor] é
  /// `null` (indeterminado não tem percentual a exibir).
  final bool exibirPercentual;

  const ProgressBarDefault({
    super.key,
    this.valor,
    this.altura = 16.0,
    this.cor,
    this.corFundo,
    this.raioBorda,
    this.rotulo,
    this.exibirPercentual = false,
  }) : assert(
         valor == null || (valor >= 0.0 && valor <= 1.0),
         'valor deve estar entre 0.0 e 1.0, ou null para indeterminado',
       );

  Widget _build(BuildContext context) {
    final design = context.design;
    final corBarra = cor ?? design.corPrimaria;
    final corTrilha = corFundo ?? design.corBorda;
    final raio = raioBorda ?? design.raioBorda;

    final rotuloTexto =
        rotulo ?? (exibirPercentual && valor != null ? '${(valor! * 100).round()}%' : null);

    final barra = ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: SizedBox(
        height: altura,
        child: LinearProgressIndicator(
          value: valor,
          minHeight: altura,
          backgroundColor: corTrilha,
          valueColor: AlwaysStoppedAnimation<Color>(corBarra),
        ),
      ),
    );

    if (rotuloTexto == null) return barra;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            rotuloTexto,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        barra,
      ],
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}
