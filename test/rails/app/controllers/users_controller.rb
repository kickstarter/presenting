class UsersController < ApplicationController
  def index
    @users = User.paginate(
      :page => params[:page],
      :per_page => 2,
      :conditions => Presenting::Search.new(:fields => {
        'first_name' => :equals,
        'last_name' => :begins_with,
        'email' => :not_null
      }).to_sql(params[:search], :field),
      :order => Presenting::Sorting.new(:fields => [
        :prefix,
        :first_name,
        :last_name,
        :email
      ]).to_sql(params[:sort])
    )
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save!
    
    redirect_to users_path
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def show
    @user = User.find(params[:id])
  end
end
