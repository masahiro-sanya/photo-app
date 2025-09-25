require "net/http"
require "uri"
require "json"

class OAuthController < ApplicationController
  before_action :require_login

  # 認可コード受け取り → トークン交換
  def callback
    if params[:error].present?
      return redirect_to photos_path, alert: "OAuthエラー: #{params[:error_description] || params[:error]}"
    end

    code = params[:code].to_s
    return redirect_to photos_path, alert: "認可コードが受け取れませんでした" if code.blank?

    # 認可コード→アクセストークン（RFC6749 C〜E）
    token_url = URI.parse("http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/token")
    client_id = helpers.oauth_client_id
    client_secret = helpers.oauth_client_secret
    if client_id.blank? || client_secret.blank?
      return redirect_to photos_path, alert: "OAuthのクライアントID/シークレットが未設定です"
    end

    body = URI.encode_www_form(
      code: code,
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: oauth_callback_url,
      grant_type: "authorization_code"
    )

    begin
      http = Net::HTTP.new(token_url.host, token_url.port)
      http.use_ssl = token_url.scheme == "https"
      req = Net::HTTP::Post.new(token_url.request_uri)
      req["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = body
      res = http.request(req)

      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse(res.body)
        access_token = json["access_token"].to_s
        if access_token.present?
          session[:oauth_access_token] = access_token
          return redirect_to photos_path, notice: "OAuth連携が完了しました"
        else
          return redirect_to photos_path, alert: "アクセストークンを取得できませんでした"
        end
      else
        return redirect_to photos_path, alert: "トークンエンドポイントが失敗しました (#{res.code})"
      end
    rescue => e
      return redirect_to photos_path, alert: "トークン取得中にエラーが発生しました: #{e.message}"
    end
  end

  private

  def require_login
    unless current_user
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end
