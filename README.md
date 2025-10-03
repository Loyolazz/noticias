# Notícias - Plataforma de conteúdo bilíngue

Aplicação Rails construída para o teste técnico descrito, permitindo gerenciamento de notícias e vídeos com tradução em português e espanhol. O projeto oferece autenticação simples, sistema de amizade entre usuários, moderação de comentários, avaliações, busca full-text e área administrativa completa.

## Stack utilizada

- **Ruby 3.3 / Rails 8**
- **PostgreSQL** como banco principal
- **Hotwire (Turbo + Stimulus)** já disponível na stack Rails 8
- Gems adicionais:
  - [`bcrypt`](https://github.com/bcrypt-ruby/bcrypt-ruby) para autenticação com `has_secure_password`
  - [`friendly_id`](https://github.com/norman/friendly_id) para slugs amigáveis nas rotas
  - [`pg_search`](https://github.com/Casecommons/pg_search) para busca full-text nas notícias

## Configuração do ambiente

1. Instale dependências Ruby com `bundle install`.
2. Configure as variáveis de ambiente do banco (se necessário):
   ```bash
   export POSTGRES_HOST=localhost
   export POSTGRES_USER=postgres
   export POSTGRES_PASSWORD=postgres
   ```
3. Crie e migre o banco:
   ```bash
   bin/rails db:create db:migrate
   ```
4. Rode o servidor:
   ```bash
   bin/rails server
   ```
5. A aplicação fica disponível em `http://localhost:3000/pt` (português) ou `http://localhost:3000/es` (espanhol).

## Usuários e autenticação

- Registro e login feitos por senha (BCrypt) com seleção de idioma preferido.
- Usuários podem enviar convites de amizade (auto relacionamento via `Friendship`).
- Administradores são definidos pela coluna `admin` e podem banir/desbanir usuários na área administrativa.
- Usuários banidos são impedidos de autenticar ou continuar navegando.

## Conteúdos (Notícias e Vídeos)

- Modelos `News` e `Video` possuem campos duplicados para PT/ES (`title_pt`, `body_es`, etc.).
- Para facilitar o uso criamos um **plugin próprio** em `lib/plugins/localized_content.rb`. Ele adiciona o método `localizes` aos modelos e permite acessar o conteúdo por idioma (`news.title(:es)`).
- Utiliza-se `Taggable` (concern) para tags com idioma, permitindo reuso entre notícias e vídeos.
- URLs amigáveis com FriendlyId (`/pt/news/titulo-da-noticia`).
- Busca em notícias feita com `pg_search` (tsearch no PostgreSQL).

## Comentários e avaliações

- `Comment` é polimórfico (news/videos) com status de moderação (`pending`, `approved`, `rejected`).
- Administradores acessam `/admin/comments` para aprovar ou rejeitar.
- Comentários, tags e notas são separados por idioma; apenas comentários aprovados do idioma atual aparecem na interface pública.
- `Rating` garante uma nota por usuário para cada item.

## Área administrativa

Rotas sob `/admin` (só para administradores) com CRUD completo de:

- Notícias (incluindo seleção de tags)
- Vídeos
- Tags
- Moderação de comentários
- Gestão de usuários (banimento/desbanimento)

## Internacionalização

- Idiomas disponíveis: português (`pt`) e espanhol (`es`).
- Rotas utilizam escopo `/:locale`, e o layout oferece troca rápida de idioma.
- Textos da interface centralizados em `config/locales/pt.yml` e `config/locales/es.yml`.

## Estrutura de diretórios

- `app/models/concerns/taggable.rb` e `rateable.rb` concentram lógicas compartilhadas.
- `lib/plugins/localized_content.rb` define o plugin de conteúdo localizado.
- Controllers sob `app/controllers/admin` lidam com a área administrativa.
- Views seguem convenções Rails, com formulários padrão `form_with`.

## Testes e verificação

- Execute `bin/rails test` para rodar a suíte padrão.
- Ferramentas adicionais instaladas: `rubocop-rails-omakase` e `brakeman` (execução opcional via `bundle exec rubocop` / `bundle exec brakeman`).

## Próximos passos sugeridos

- Adicionar testes de sistema cobrindo fluxo de moderação e internacionalização.
- Ajustar estilos com um framework (Bootstrap/Tailwind) caso necessário.
- Melhorar o sistema de amizade com convites e notificações.
