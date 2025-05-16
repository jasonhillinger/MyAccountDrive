class UsersController < ApplicationController
  # For debugging
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def create
    begin
      username  = User.generateRandomUsername
      password = params[:password]

      if password.length > User::MAX_LENGTH_PASSWORD
        status = 400
        raise "Password length must be less than #{User::MAX_LENGTH_PASSWORD} characters."
      end

      password = Obfuscator.obfuscate(password)

      User.create("username" => username, "password" => password, "status" => User::STATUS_ACTIVE)
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
  end
end
