class UsersController < ApplicationController
  # For debugging
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def create
    begin
      username  = User.generateRandomUsername
      password = params[:password]
      if !User.is_valid_password?(password)
        status = 400
        raise "Password length must be less than #{User::MAX_LENGTH_PASSWORD} characters and greater than #{User::MIN_LENGTH_PASSWORD} characters."
      end

      User.createActive(username, password)

      response = {
          "username" => username
      }

      status = 200

    rescue => e
      Rails.logger.error("Failed to create user: #{e.message}")
      response =  { "error" => e.message }

      status = nil != status ? status : 500
    end

    render json: response, status: status
  end

  def login
    begin
      username  = params[:username]
      password = params[:password]

      if !User.is_valid_password?(password)
        status = 400
        raise "Password length must be less than #{User::MAX_LENGTH_PASSWORD} characters and greater than #{User::MIN_LENGTH_PASSWORD} characters."
      end

      if !User.is_valid_username?(username)
        status = 400
        raise "Username length must be #{User::USERNAME_LENGTH} characters long."
      end

      user = User.getActiveUser(username, password)

      # Check if user is empty, raise error if so
      if 0 == user.length
        status = 404
        raise "Wrong username or password"
      end

      response = {
          "TEMP" => "SUCCESS"
      }

      status = 200

    rescue => e
      Rails.logger.error("Failed to create user: #{e.message}")
      response =  { "error" => e.message }

      status = nil != status ? status : 500
    end

    render json: response, status: status
  end
end
