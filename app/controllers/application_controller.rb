class ApplicationController < ActionController::Base
  # モダンブラウザのみ許可
  allow_browser versions: :modern

  # ビューでも使う
  helper_method :current_user

  private

  # 現在のユーザー（あれば）
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
