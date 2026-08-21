/// Porte de `toUtcLocal`/`toUtcLocalDateTime` (core/functions/toUtcLocal.ts) — usadas por
/// [TableGrid] para exibir `TypeColunm.dataBR`/`TypeColunm.dataHoraBR`.
library;

/// Aceita tanto data pura (`2026-07-31`) quanto datetime zonado
/// (`2026-07-31T14:32:00-03:00[America/Sao_Paulo]`) — em ambos os casos os 10 primeiros
/// caracteres já são a data no fuso correto, então extrai só o prefixo em vez de reconstruir
/// um DateTime (evita acerto de fuso do dispositivo e, se a string vier com hora/zona,
/// produziria uma data errada).
String toUtcLocal(String? dateString) {
  if (dateString == null || dateString.trim().isEmpty) return '';

  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})',
  ).firstMatch(dateString.trim());
  if (match == null) return '';

  final year = match.group(1)!;
  final month = match.group(2)!;
  final day = match.group(3)!;
  return '$day/$month/$year';
}

/// O backend pode enviar ISO zonado com o identificador IANA entre colchetes
/// (`[America/Sao_Paulo]`) — `DateTime.parse` entende o offset numérico, mas não essa parte,
/// por isso é removida antes do parse. O resultado é convertido para o fuso local do
/// dispositivo (`.toLocal()`), espelhando o comportamento do `new Date(...)` do JavaScript.
String toUtcLocalDateTime(String? dateString) {
  if (dateString == null) return '';

  final raw = dateString.trim();
  if (raw.isEmpty) return '';

  final normalized = raw
      .replaceAll(RegExp(r'\[[^\]]+\]$'), '')
      .replaceFirst(' ', 'T');

  DateTime date;
  try {
    date = DateTime.parse(normalized).toLocal();
  } catch (_) {
    return '';
  }

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  final hours = date.hour.toString().padLeft(2, '0');
  final minutes = date.minute.toString().padLeft(2, '0');

  return '$day/$month/$year $hours:$minutes';
}
