FROM ruby:2.6.10-bullseye

# Instala dependências do sistema e Node 18
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    git \
    curl \
    ca-certificates \
 && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instala Bundler 2.x (compatível com Rails 5.2)
RUN gem install bundler:2.4.0

# Bundler 2.x instala todas as gems, mesmo se Gemfile.lock foi gerado no Windows
RUN bundle install

# Copia restante do projeto
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
