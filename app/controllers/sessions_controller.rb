class SessionsController < ApplicationController

  def new
  end

  def create
    # sessionフォームのemailでDbを検索
    @user = User.find_by(email: params[:session][:email].downcase)
    # sessionフォームのパスワードとDbのパスワードが正しいか検証
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        # ログインを記憶する
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end