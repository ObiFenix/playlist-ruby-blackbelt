class UsersController < ApplicationController

  before_action :set_user, only: [:first_name, :last_name, :email, :password, :password_confirmation]

  # ===================
  # GET Request [.html]
  # Switch Controller for Log/Reg
  # =============================
  def switch
    if session[:form] === "login"
      session[:form] = "register"
    else
      session[:form] = "login"
    end
    redirect_to "/"
  end


  # ====================
  # POST Request [.html]
  # Handles User Login <users/login> form
  # =====================================
  def login
    @user = User.find_by_email(params[:email])
    if @user and @user.authenticate(params[:password])
      session["user_id"] = @user.id
      redirect_to songs_path
    else
      flash[:errors] = ["Invalid login information!"]
      redirect_to :back
    end
  end


  # ====================
  # POST Request [.html]
  # Handles User Registration <users/register> form
  # ===============================================
  def register
    @user = User.create(user_params)
    unless @user.valid?
      flash[:errors] = @user.errors.full_messages
      redirect_to :back
    else
      # @errors = flash@user.errors.full_messages
      session["user_id"] = @user.id
      redirect_to songs_path
    end
  end


  # =============================
  # GET Request - Renders [.html]
  # =============================
  def new
    @user = User.new
  end


  # =============================
  # GET Request - Renders [.html]
  # =============================
  def show
    @user = User.find(params[:id])
    #@playlist = @user.playlists
    @this_user = "#{@user.first_name} #{@user.last_name}"
  end


  # ============================
  # DELETE request for </logout>
  # >> This shall terminate session
  # ===============================
  def logout
    reset_session
    respond_to do |format|
      format.html { redirect_to "/users/sw", notice: "#{current_user.first_name} was successfully logged out." }
      format.json { head :no_content }
    end
  end


  # ==============
  # DELETE /user/1
  # DELETE /user/1.json
  # ===================
  def destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      # format.html { redirect_to '/', notice: 'User was successfully destroyed.' }
      format.html { redirect_to "/users/#{params[:user_id]}", notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Sanatizing/Validating Form Parameters...
    private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
