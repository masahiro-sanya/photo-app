class SessionsController < ApplicationController
  # ログイン画面
  def new
    @errors = []
  end

  # ログイン処理
  def create
    user_id = params.dig(:session, :user_id).to_s
    password = params.dig(:session, :password).to_s

    errors = []
    errors << "ユーザーIDを入力してください" if user_id.strip.empty?
    errors << "パスワードを入力してください" if password.strip.empty?

    if errors.any?
      @errors = errors
      flash.now[:alert] = @errors.join("\n")
      return render :new, status: :unprocessable_entity
    end

    # user_id で検索して検証
    user = User.find_by(user_id: user_id)
    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to photos_path, notice: "ログインしました"
    else
      @errors = ["ユーザーIDまたはパスワードが正しくありません"]
      flash.now[:alert] = @errors.first
      render :new, status: :unprocessable_entity
    end
  end

  # ログアウト
  def destroy
    reset_session
    redirect_to login_path, notice: "ログアウトしました"
  end

  private

  # ストロングパラメータ
  def session_params
    params.require(:session).permit(:user_id, :password)
  end
end
