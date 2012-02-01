class Challah::SessionsController < ApplicationController
  before_filter :destroy_session, :except => :create
  
  unloadable
  
  # GET /login
  def new
    @session = Challah::Session.new(request)
  end
  
  # POST /login
  def create
    @session = Challah::Session.new(request, params[:session])
    @session.ip = request.remote_ip
    
    if @session.save
      redirect_to return_to_path(@session.default_path)
    else
      redirect_to login_path, :alert => I18n.translate('challah.sessions.create.failed_login')
    end
  end
  
  # GET /logout
  def destroy
    redirect_to login_path
  end
  
  protected
    def destroy_session
      current_user_session.destroy
    end
  
    def return_to_path(default_path = '/')
      result = session[:return_to]      
      result = nil if result and result == "http://#{request.domain}/"
      result || default_path
    end
end