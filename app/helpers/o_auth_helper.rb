module OAuthHelper
  AUTH_BASE_URL = "http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/oauth/authorize".freeze

  # ENV 優先。無ければ credentials。
  def oauth_client_id
    ENV["OAUTH_CLIENT_ID"] || Rails.application.credentials.dig(:oauth, :client_id)
  end

  def oauth_client_secret
    ENV["OAUTH_CLIENT_SECRET"] || Rails.application.credentials.dig(:oauth, :client_secret)
  end

  # 認可URLを組み立てる
  def oauth_authorize_url
    client_id = oauth_client_id
    raise "OAuthのclient_idが未設定です" if client_id.blank?

    query = {
      client_id: client_id,
      response_type: "code",
      redirect_uri: oauth_callback_url,
      scope: "write_tweet"
    }.to_query

    "#{AUTH_BASE_URL}?#{query}"
  end

  # 連携状態
  def oauth_connected?
    session[:oauth_access_token].present?
  end

  # トークンの一部だけ表示
  def masked_oauth_token
    t = session[:oauth_access_token].to_s
    return "" if t.blank?
    return t if t.length <= 8
    "#{t[0,4]}...#{t[-4,4]}"
  end
end
