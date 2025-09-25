class PhotosController < ApplicationController
  # ログイン必須
  before_action :require_login

  # 一覧（自分の写真・新しい順）
  def index
    @photos = current_user.photos.with_attached_image.order(created_at: :desc)
  end

  # アップロードフォーム
  def new
    @photo = current_user.photos.new
  end

  # 写真を保存（タイトル・画像必須）
  def create
    @photo = current_user.photos.new(photo_params)
    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました"
    else
      flash.now[:alert] = @photo.errors.full_messages.join("\n")
      render :new, status: :unprocessable_entity
    end
  end

  # ツイート投稿（連携が必要）
  def tweet
    photo = current_user.photos.with_attached_image.find(params[:id])
    token = session[:oauth_access_token].to_s
    unless token.present?
      return redirect_to photos_path, alert: "OAuth連携が未完了です。先に連携してください。"
    end

    unless photo.image.attached?
      return redirect_to photos_path, alert: "画像が見つかりません。"
    end

    # 画像のURL（Active Storage）
    image_url = url_for(photo.image)

    begin
      require "net/http"
      require "json"
      uri = URI.parse("http://unifa-recruit-my-tweet-app.ap-northeast-1.elasticbeanstalk.com/api/tweets")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{token}"
      req.body = { text: photo.title, url: image_url }.to_json
      res = http.request(req)

      if res.code.to_i == 201
        redirect_to photos_path, notice: "ツイートを投稿しました"
      else
        redirect_to photos_path, alert: "ツイートに失敗しました (#{res.code})"
      end
    rescue => e
      redirect_to photos_path, alert: "ツイートに失敗しました: #{e.message}"
    end
  end

  private

  # 未ログインならログイン画面へ
  def require_login
    unless current_user
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  # 許可パラメータ
  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
