# FROMでdocker hubからruby:2.5.1イメージをインストール
FROM ruby:2.5.1

# -qq ：エラー以外は表示しない
# postgresql-client：PostgreSQLデータベースのクライアントアプリケーションである「psql」をインストール
RUN apt-get update -qq && \
apt-get install -y postgresql-client

# yarnパッケージ管理ツールをインストール
RUN apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
apt-get install nodejs

RUN apt-get install -y vim

# 作業ディレクトリの変更
WORKDIR /taskleaf
# ホスト側のGemfileをコンテナ側のディレクトリにコピー
COPY Gemfile /taskleaf/Gemfile
COPY Gemfile.lock /taskleaf/Gemfile.lock
# Gemfileからパッケージをインストール
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000