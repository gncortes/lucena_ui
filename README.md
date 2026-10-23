# lucena_ui

Componentes de interface compartilhados do [Lucena](https://github.com/gncortes/lucena) (app) e do painel de administração: tema, tokens de design, tabuleiro e cartões. Licença AGPL-3.0.

## Regras do pacote
- UI pura: sem cubit, repositório, Drift, Stockfish, voz, áudio, webview nem `dart:io`. Compila na web.
- Sem texto fixo e sem ARB: quem usa passa os textos por parâmetro.
- Um único import público: `package:lucena_ui/lucena_ui.dart`.
- Faltou algo? Abra PR aqui; não copie widget para o app nem para o painel.

## Uso (enquanto não há tag)
```yaml
dependencies:
  lucena_ui:
    git:
      url: https://github.com/gncortes/lucena_ui.git
      ref: tarefa/extracao-componentes
```
Desenvolvimento local: `pubspec_overrides.yaml` (fora do git) com
```yaml
dependency_overrides:
  lucena_ui:
    path: ../lucena_ui
```

## Verificação
`flutter analyze`, `flutter test` e `flutter build web` em `example/`.
