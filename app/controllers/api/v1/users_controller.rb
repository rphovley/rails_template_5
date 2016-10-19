class Api::V1::UsersController < Api::BaseController
  access all: [:create], user: {except: [:create]}
  
  # GET /api/v1/user/1 https://graph.facebook.com/me/?access_token=[user_access_token] 
  api :GET, "/v1/user", "User information."
  example '
    {
    "id": 5,
    "email": "dvader@force_underestimated.com",
    "created_at": "2016-06-02T19:10:54.000Z",
    "updated_at": "2016-06-03T15:04:17.000Z",
    "roles": [
      "user",
      "user"
    ],
    "facebook_user_id": null,
    "first_name": "Darth",
    "last_name": "Vader",
    "age": 46,
    "phone": "8778988888",
    "description": "No, I am your father."
  }'
  def show
    render json: @user, status: :ok
  end

  # POST /api/v1/user
  api :POST, "/v1/user", "Create User"
  param :first_name, String, required: true
  param :last_name, String, required: true
  param :email, String, required: true
  param :password, String, required: true
  param :password_confirmation, String, required: true
  param :age, String, required: true
  param :phone, String, required: true
  param :description, String, required: true
  param :image_uri, String, required: false

  def create
    @user = User.new(user_params)
    if @user.save
      params[:email] && found_user && found_user.valid_password?(auth_params[:password])
      connection = found_user.api_connections.create
      render json: {auth_token: connection.token, email: @found_user.email, id: @found_user.id, 
        first_name: @found_user.first_name, last_name: @found_user.last_name, age: @found_user.age, 
        phone: @found_user.phone, description: @found_user.description, image_uri: @found_user.image_uri}, status: :created
    else
      render json: @user.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/user/1
  api :PUT, "/v1/user", "Update User Profile, current_password is required to update the user's password"
  param :current_password, String, required: false
  param :password, String, required: false
  param :password_confirmation, String, required: false
  param :first_name, String, required: false
  param :last_name, String, required: false
  param :email, String, required: false
  param :age, String, required: false
  param :phone, String, required: false
  param :description, String, required: false
  param :image_uri, String, required: false
  def update
    if @user.update(user_params)
        render json: @user, status: :accepted
    else
      render error: @user, status: :unprocessable_entity
    end
  end

  private
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :current_password, :age, :phone, :description,:image_uri, :password_confirmation)
  end

  def auth_params
    params.permit(:email, :password)
  end

  def found_user
    @found_user ||= (User.find_by(email: auth_params[:email]))
  end

end

