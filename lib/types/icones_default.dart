import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

export 'package:lucide_icons_flutter/lucide_icons.dart';

enum IconesDefault {
  ativar('check'),
  desativar('x'),
  plus('plus'),
  pluscircle('circle-plus'),
  minus('minus'),
  user('user'),
  gear('settings'),
  times('x'),
  cancelar('x'),
  dashboard('layout-dashboard'),
  menu('menu'),
  ajustar('sliders-horizontal'),
  historico('history'),
  aviso('triangle-alert'),
  erro('circle-alert'),
  salvar('save'),
  editar('file-pen-line'),
  excluir('trash-2'),
  visualizar('eye'),
  refresh('refresh-cw'),
  imprimir('printer'),
  download('download'),
  upload('upload'),
  home('house'),
  search('search'),
  filter('filter'),
  pause('pause'),
  play('play'),
  stop('square'),
  voltar('arrow-left'),
  entrar('log-in'),
  sair('log-out'),
  folder('folder'),
  folderOpen('folder-open'),
  file('file'),
  money('banknote'),
  star('star'),
  envelope('mail'),
  copy('copy'),
  confirmar('circle-check'),
  assistenteClinico('bot'),
  enviar('send'),
  calendario('calendar-days');

  final String code;
  const IconesDefault(this.code);
}

enum IconesLucide {
  calendario('calendar-days'),
  dashboard('layout-dashboard'),
  menu('menu'),
  sair('log-out');

  final String code;
  const IconesLucide(this.code);
}

String normalizarIdentificadorLucide(String identificador) {
  return identificador
      .trim()
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}-${m[2]}')
      .replaceAllMapped(RegExp(r'([a-zA-Z])(\d)'), (m) => '${m[1]}-${m[2]}')
      .replaceAll(RegExp(r'[\s_]+'), '-')
      .toLowerCase();
}

/// Converte Strings Hexadecimal ('#FFFFFF', '#FFF', '0xFFFFFFFF') ou Color para `Color` do Flutter
Color? parseIconColor(dynamic corInput, BuildContext context) {
  if (corInput is Color) return corInput;
  if (corInput is! String) return null;

  String cor = corInput.trim();
  if (cor.isEmpty || cor == 'currentColor') {
    return IconTheme.of(context).color;
  }

  // Remove o caractere '#'
  cor = cor.replaceAll('#', '');

  // Trata formato Hex curto '#FFF' -> 'FFFFFF'
  if (cor.length == 3) {
    cor = cor.split('').map((c) => '$c$c').join();
  }

  // Adiciona Alpha FF se não for passado
  if (cor.length == 6) {
    cor = 'FF$cor';
  }

  final val = int.tryParse(cor, radix: 16);
  return val != null ? Color(val) : null;
}

/// Converte dynamic (String, int, double) para o valor do tamanho do ícone
double parseIconSize(dynamic tamanho) {
  if (tamanho is double) return tamanho;
  if (tamanho is int) return tamanho.toDouble();
  if (tamanho is String) {
    return double.tryParse(tamanho) ?? 12.0;
  }
  return 12.0;
}

// =============================================================================
// MAPA DE ÍCONES LUCIDE
// =============================================================================

final Map<String, IconData> iconesLucideMap = {
  'arrow-down': LucideIcons.arrowDown,
  'arrow-left': LucideIcons.arrowLeft,
  'arrow-left-right': LucideIcons.arrowLeftRight,
  'arrow-right': LucideIcons.arrowRight,
  'arrow-up': LucideIcons.arrowUp,
  'ban': LucideIcons.ban,
  'banknote': LucideIcons.banknote,
  'bed-double': LucideIcons.bedDouble,
  'book-open': LucideIcons.bookOpen,
  'bot': LucideIcons.bot,
  'boxes': LucideIcons.boxes,
  'building-2': LucideIcons.building2,
  'cake': LucideIcons.cake,
  'calendar-check': LucideIcons.calendarCheck,
  'calendar-clock': LucideIcons.calendarClock,
  'calendar-days': LucideIcons.calendarDays,
  'calendar-plus': LucideIcons.calendarPlus,
  'chart-candlestick': LucideIcons.candlestickChart,
  'chart-column-big': LucideIcons.barChart3,
  'check': LucideIcons.check,
  'chevron-down': LucideIcons.chevronDown,
  'chevron-left': LucideIcons.chevronLeft,
  'chevron-right': LucideIcons.chevronRight,
  'chevron-up': LucideIcons.chevronUp,
  'circle-alert': LucideIcons.alertCircle,
  'circle-check': LucideIcons.checkCircle2,
  'circle-dollar-sign': LucideIcons.dollarSign,
  'circle-plus': LucideIcons.plusCircle,
  'circle-x': LucideIcons.xCircle,
  'clipboard-check': LucideIcons.clipboardCheck,
  'clipboard-list': LucideIcons.clipboardList,
  'clock': LucideIcons.clock,
  'copy': LucideIcons.copy,
  'credit-card': LucideIcons.creditCard,
  'database': LucideIcons.database,
  'dollar-sign': LucideIcons.dollarSign,
  'door-open': LucideIcons.doorOpen,
  'download': LucideIcons.download,
  'eye': LucideIcons.eye,
  'eye-off': LucideIcons.eyeOff,
  'file': LucideIcons.file,
  'file-archive': LucideIcons.fileArchive,
  'file-audio': LucideIcons.fileAudio,
  'file-chart-column': LucideIcons.fileBarChart,
  'file-heart': LucideIcons.fileHeart,
  'file-image': LucideIcons.fileImage,
  'file-pen-line': LucideIcons.fileEdit,
  'file-signature': LucideIcons.fileSignature,
  'file-spreadsheet': LucideIcons.fileSpreadsheet,
  'file-text': LucideIcons.fileText,
  'file-video': LucideIcons.fileVideo,
  'flag': LucideIcons.flag,
  'filter': LucideIcons.filter,
  'folder': LucideIcons.folder,
  'folder-open': LucideIcons.folderOpen,
  'graduation-cap': LucideIcons.graduationCap,
  // 'handshake': LucideIcons.handshake,
  'history': LucideIcons.history,
  // 'hospital': LucideIcons.hospital,
  'house': LucideIcons.home,
  'id-card': LucideIcons.contact2,
  'info': LucideIcons.info,
  'landmark': LucideIcons.landmark,
  'layout-dashboard': LucideIcons.layoutDashboard,
  'list': LucideIcons.list,
  'list-checks': LucideIcons.listChecks,
  'loader-circle': LucideIcons.loader2,
  'lock': LucideIcons.lock,
  'log-in': LucideIcons.logIn,
  'log-out': LucideIcons.logOut,
  'mail': LucideIcons.mail,
  'megaphone': LucideIcons.megaphone,
  'menu': LucideIcons.menu,
  'message-circle': LucideIcons.messageCircle,
  'mic': LucideIcons.mic,
  'minus': LucideIcons.minus,
  // 'notebook-pen': LucideIcons.notebookPen,
  'package': LucideIcons.package,
  'package-plus': LucideIcons.packagePlus,
  'paperclip': LucideIcons.paperclip,
  'palette': LucideIcons.palette,
  'pause': LucideIcons.pause,
  'pencil': LucideIcons.pencil,
  'percent': LucideIcons.percent,
  'phone': LucideIcons.phone,
  'pill': LucideIcons.pill,
  'play': LucideIcons.play,
  'plug': LucideIcons.plug,
  'plus': LucideIcons.plus,
  'presentation': LucideIcons.presentation,
  'printer': LucideIcons.printer,
  'receipt-text': LucideIcons.receipt,
  'refresh-cw': LucideIcons.refreshCw,
  'reply': LucideIcons.reply,
  'rotate-cw': LucideIcons.rotateCw,
  'ruler': LucideIcons.ruler,
  'save': LucideIcons.save,
  'search': LucideIcons.search,
  'send': LucideIcons.send,
  'settings': LucideIcons.settings,
  'shopping-cart': LucideIcons.shoppingCart,
  'sliders-horizontal': LucideIcons.sliders,
  'sticky-note': LucideIcons.stickyNote,
  'square': LucideIcons.square,
  'star': LucideIcons.star,
  'stethoscope': LucideIcons.stethoscope,
  'store': LucideIcons.store,
  'tag': LucideIcons.tag,
  'tags': LucideIcons.tags,
  'test-tubes': LucideIcons.testTubes,
  'thumbs-down': LucideIcons.thumbsDown,
  'thumbs-up': LucideIcons.thumbsUp,
  'ticket': LucideIcons.ticket,
  'trash-2': LucideIcons.trash2,
  'trending-up': LucideIcons.trendingUp,
  'triangle-alert': LucideIcons.alertTriangle,
  'undo-2': LucideIcons.undo2,
  'upload': LucideIcons.upload,
  'user': LucideIcons.user,
  'user-cog': LucideIcons.userCog,
  'user-plus': LucideIcons.userPlus,
  // 'user-round': LucideIcons.userRound,
  'user-x': LucideIcons.userX,
  'users': LucideIcons.users,
  'venus-and-mars': LucideIcons.binary,
  'wallet': LucideIcons.wallet,
  'wallet-cards': LucideIcons.wallet,
  'wrench': LucideIcons.wrench,
  'x': LucideIcons.x,
};
