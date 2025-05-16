class UsersController < ApplicationController
  # For debugging
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def create
    begin
      username  = User.generateRandomUsername
      password = params[:password]

      User.create("username" => username, "password" => password, "status" => "ACTIVE")
      response = {
          "username" => username
      }

      status = 200

    rescue StandardError => e
      Rails.logger.error("Failed to create user: #{e.message}")
      response =  { "error" => e.message }
      status = 500
    end

    render json: response, status: status
  end

  def login
  end
end
