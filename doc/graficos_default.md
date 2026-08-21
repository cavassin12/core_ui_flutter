# Gráficos

O pacote oferece quatro gráficos adaptativos: `GraficoLinhaDefault`,
`GraficoBarrasDefault`, `GraficoRoscaDefault` e `GraficoIndicadorDefault`.
Todos usam os tokens de `CoreDesignSystemTheme`, possuem semântica acessível e
aceitam dados tipados, sem expor a biblioteca gráfica ao app consumidor.

```dart
final vendas = GraficoSerieDTO(
  nome: 'Vendas',
  pontos: [
    GraficoPontoDTO(x: 0, valor: 42, rotulo: 'Jan'),
    GraficoPontoDTO(x: 1, valor: 58, rotulo: 'Fev'),
  ],
);

GraficoLinhaDefault(
  titulo: 'Evolução mensal',
  series: [vendas],
  preencherArea: true,
  aoSelecionar: (selecao) => debugPrint('${selecao.rotulo}: ${selecao.valor}'),
);
```

## Barras

Reutiliza `GraficoSerieDTO`. Use `modo: GraficoBarrasModo.empilhado` para
composição de totais e `orientacao: GraficoBarrasOrientacao.horizontal` quando
os rótulos forem longos.

## Rosca e pizza

Recebe uma lista de `GraficoFatiaDTO`. Por padrão renderiza uma rosca; defina
`formatoRosca: false` para pizza. `textoCentral` e `detalheCentral` resumem o
total no centro.

## Indicador

Recebe `valor`, `minimo` e `maximo`. As faixas opcionais são declaradas com
`GraficoFaixaDTO(inicio: ..., fim: ..., cor: ...)`. Valores fora do intervalo
são visualmente limitados, mas o formatador continua recebendo o valor real.

Todos os gráficos oferecem `titulo`, `subtitulo`, `altura` e estado vazio. Os
gráficos de linha, barras e rosca também aceitam paleta customizada, posição da
legenda e callback `aoSelecionar`.
