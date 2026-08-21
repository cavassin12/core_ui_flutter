import 'dart:async';

import 'package:core_ui_flutter/code_design_system_theme.dart';
import 'package:core_ui_flutter/components/button_default.dart';
import 'package:core_ui_flutter/components/card_default.dart';
import 'package:core_ui_flutter/components/input_default.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:flutter/material.dart';

import 'core_auth_grapheus_credentials.dart';
import 'core_auth_grapheus_model.dart';

typedef CoreAuthGrapheusLogin =
    FutureOr<void> Function(CoreAuthGrapheusCredentials credentials);

/// Página de autenticação reutilizável do Grapheus.
///
/// A comunicação permanece desacoplada da UI. O projeto consumidor conecta o
/// [aoEntrar] ao seu `ApiService`, repository ou controller.
class CoreAuthGrapheus extends PlatformWidget {
  final CoreAuthGrapheusModel modelo;
  final CoreAuthGrapheusLogin? aoEntrar;
  final VoidCallback? aoEsquecerSenha;
  final VoidCallback? aoCriarConta;
  final Widget? marca;
  final Widget? painelVisual;
  final String titulo;
  final String? subtitulo;
  final String textoBotao;
  final String textoGoogle;
  final Color? corDestaque;

  const CoreAuthGrapheus({
    super.key,
    required this.modelo,
    this.aoEntrar,
    this.aoEsquecerSenha,
    this.aoCriarConta,
    this.marca,
    this.painelVisual,
    this.titulo = 'Acessar o sistema',
    this.subtitulo,
    this.textoBotao = 'Entrar',
    this.textoGoogle = 'Continuar com Google',
    this.corDestaque,
  });

  @override
  Widget createAndroidWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: true);

  @override
  Widget createIosWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: true);

  @override
  Widget createWebWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: false);

  @override
  Widget createWindowsWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: false);

  @override
  Widget createMacosWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: false);

  @override
  Widget createLinuxWidget(BuildContext context) =>
      _CoreAuthGrapheusView(configuracao: this, mobile: false);
}

class _CoreAuthGrapheusView extends StatefulWidget {
  final CoreAuthGrapheus configuracao;
  final bool mobile;

  const _CoreAuthGrapheusView({
    required this.configuracao,
    required this.mobile,
  });

  @override
  State<_CoreAuthGrapheusView> createState() => _CoreAuthGrapheusViewState();
}

class _CoreAuthGrapheusViewState extends State<_CoreAuthGrapheusView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _lembrar = false;
  bool _processando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate() ||
        widget.configuracao.aoEntrar == null) {
      return;
    }
    setState(() => _processando = true);
    try {
      await widget.configuracao.aoEntrar!(
        CoreAuthGrapheusCredentials(
          email: _emailController.text.trim(),
          senha: _senhaController.text,
        ),
      );
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final conteudo = widget.mobile
        ? _buildMobile(context)
        : _buildDesktop(context);
    return Scaffold(
      backgroundColor: context.design.corFundo,
      body: SafeArea(child: conteudo),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: switch (widget.configuracao.modelo) {
                CoreAuthGrapheusModel.painelVisual => _mobilePainelVisual(
                  context,
                ),
                CoreAuthGrapheusModel.painelDestaque => _mobilePainelDestaque(
                  context,
                ),
                CoreAuthGrapheusModel.cardCentral => _cardCentral(
                  context,
                  mobile: true,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: switch (widget.configuracao.modelo) {
          CoreAuthGrapheusModel.painelVisual => _desktopPainelVisual(context),
          CoreAuthGrapheusModel.painelDestaque => _desktopPainelDestaque(
            context,
          ),
          CoreAuthGrapheusModel.cardCentral => _cardCentral(
            context,
            mobile: false,
          ),
        },
      ),
    );
  }

  Widget _mobilePainelVisual(BuildContext context) {
    return CardDefault(
      elevacao: 8,
      larguraBorda: 0,
      imagemTopo: SizedBox(height: 150, child: _painelVisual(context)),
      corpo: _formulario(context, alinhamentoCentral: true),
      espacamentoCorpo: const EdgeInsets.all(24),
    );
  }

  Widget _desktopPainelVisual(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1120, minHeight: 620),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                context.design.raioBordaGrande,
              ),
              child: _painelVisual(context),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 6,
            child: Center(
              child: CardDefault(
                largura: 440,
                elevacao: 10,
                larguraBorda: 0,
                corpo: _formulario(context, alinhamentoCentral: true),
                espacamentoCorpo: const EdgeInsets.all(36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobilePainelDestaque(BuildContext context) {
    final destaque =
        widget.configuracao.corDestaque ?? context.design.corPrimaria;
    return CardDefault(
      elevacao: 8,
      larguraBorda: 0,
      corpo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            color: destaque,
            child: _boasVindas(context, Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _formulario(context),
          ),
        ],
      ),
      espacamentoCorpo: EdgeInsets.zero,
    );
  }

  Widget _desktopPainelDestaque(BuildContext context) {
    final destaque =
        widget.configuracao.corDestaque ?? context.design.corPrimaria;
    return CardDefault(
      largura: 820,
      elevacao: 8,
      larguraBorda: 0,
      espacamentoCorpo: EdgeInsets.zero,
      corpo: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: _formulario(context),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: destaque,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: _boasVindas(context, Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardCentral(BuildContext context, {required bool mobile}) {
    return CardDefault(
      largura: mobile ? null : 500,
      elevacao: 8,
      larguraBorda: 0,
      corpo: _formulario(
        context,
        alinhamentoCentral: true,
        exibirCadastro: true,
      ),
      espacamentoCorpo: EdgeInsets.symmetric(
        horizontal: mobile ? 24 : 54,
        vertical: mobile ? 30 : 48,
      ),
    );
  }

  Widget _formulario(
    BuildContext context, {
    bool alinhamentoCentral = false,
    bool exibirCadastro = false,
  }) {
    final config = widget.configuracao;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: alinhamentoCentral
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            ?config.marca,
            Text(
              config.titulo,
              textAlign: alinhamentoCentral
                  ? TextAlign.center
                  : TextAlign.start,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (config.subtitulo != null) ...[
              const SizedBox(height: 8),
              Text(
                config.subtitulo!,
                textAlign: alinhamentoCentral ? TextAlign.center : null,
              ),
            ],
            const SizedBox(height: 28),
            InputDefault(
              label: 'E-mail',
              type: 'email',
              autocomplete: 'email',
              placeholder: 'seu@email.com',
              controller: _emailController,
              disabled: _processando,
            ),
            const SizedBox(height: 16),
            InputDefault(
              label: 'Senha',
              type: 'password',
              autocomplete: 'current-password',
              placeholder: 'Digite sua senha',
              controller: _senhaController,
              disabled: _processando,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _lembrar,
                  onChanged: _processando
                      ? null
                      : (value) => setState(() => _lembrar = value ?? false),
                ),
                const Text('Lembrar-me'),
                const Spacer(),
                TextButton(
                  onPressed: config.aoEsquecerSenha,
                  child: const Text('Esqueci a senha'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ButtonDefault(
              texto: _processando ? 'Entrando...' : config.textoBotao,
              largura: double.infinity,
              altura: 46,
              disabled: _processando || config.aoEntrar == null,
              acaoExecutar: _entrar,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'ou',
                    style: TextStyle(color: context.design.corTextoSecundario),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            ButtonDefault(
              texto: config.textoGoogle,
              largura: double.infinity,
              altura: 46,
            ),
            if (exibirCadastro && config.aoCriarConta != null) ...[
              const SizedBox(height: 18),
              TextButton(
                onPressed: config.aoCriarConta,
                child: const Text('Não possui uma conta? Criar conta'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _painelVisual(BuildContext context) {
    if (widget.configuracao.painelVisual != null) {
      return SizedBox.expand(child: widget.configuracao.painelVisual);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.design.corPrimaria, context.design.corSecundaria],
        ),
      ),
      child: Center(
        child:
            widget.configuracao.marca ??
            const Icon(Icons.lock_outline, color: Colors.white, size: 72),
      ),
    );
  }

  Widget _boasVindas(BuildContext context, Color corTexto) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bem-vindo',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: corTexto,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.configuracao.subtitulo ?? 'Entre para continuar',
          textAlign: TextAlign.center,
          style: TextStyle(color: corTexto.withValues(alpha: .85)),
        ),
      ],
    );
  }
}
