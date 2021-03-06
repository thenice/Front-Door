class UsersController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :login]
  
  def login
    token_value = User.authenticate(params[:username], params[:password])
    token = Token.find_by_value(token_value)
    result =  token.present? ? {:token => token.value, :user_id => token.user.id} : {:errors => ["Bad login"]}
    respond_to do |format|
      format.html { render :text => result.to_json } 
      format.xml  { render :xml => result.to_xml } 
      format.json  { render :json => result.to_json } 
    end
  end
  
  def logged_in
    result = { :logged_in => @user.present? ? true : false }
    respond_to do |format|
      format.html { render :text => result.to_json }
      format.xml  { render :xml => result.to_xml }
      format.json  { render :json => result.to_json }
    end
  end
  
  # GET /users
  # GET /users.xml
  # this is really the show action
  def index
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => { :user => @user.to_public }.to_json }
      format.json { render :json => { :user => @user.to_public }.to_json }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
  end

  # GET /users/new
  # GET /users/new.xml
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(:username => params[:username],
      :password => params[:password],
      :password_confirmation => params[:password_confirmation])
      
    respond_to do |format|
      if @user.save
        @public_user = @user.to_public
        format.html { redirect_to(@public_user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @public_user, :status => :created, :location => @public_user }
        format.json  { render :json => @public_user, :status => :created, :location => @public_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json  { render :json =>  @user.errors }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
  
  private
  
  def authenticate
    begin
      token = Token.find_by_value(params[:token])
      token.active? ? (@user = token.user) : block_request
    rescue
      block_request
    end
  end
  
  def block_request
    render :text => "not authenticated"
  end
  
end
