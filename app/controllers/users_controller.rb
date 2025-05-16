class UsersController < ApplicationController
  def create
    begin
      username = "test1"
      password = "password123"

      User.create("username" => username, "password" => password, "status" => "ACTIVE")
      response = {
          "username" => username,
          "password" => password
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
