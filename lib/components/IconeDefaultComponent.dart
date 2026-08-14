import '../types/IconesDefault.dart';

class IconeDefaultComponent extends StatelessWidget {
  final IconesDefault? iconeDefault;
  final IconData? icone;
  final Color? cor;
  final double tamanho;

  const IconeDefaultComponent({
    super.key,
    this.iconeDefault,
    this.icone,
    this.cor,
    this.tamanho = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = icone;
    if (iconeDefault != null) {
      iconData = iconeDefault!.iconData;
    }

    if (iconData == null) return const SizedBox.shrink();

    return Icon(
      iconData,
      size: tamanho,
      color: cor ?? IconTheme.of(context).color,
    );
  }
}
