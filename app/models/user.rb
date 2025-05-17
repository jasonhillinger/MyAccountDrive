Airrecord.api_key = Rails.application.credentials.dig(:airtable, :api_key)

class User < Airrecord::Table
  attr_reader :username, :status

  self.base_key = Rails.application.credentials.dig(:airtable, :base_key_users)
  self.table_name = "users"

  USERNAME_LENGTH = 32

  MAX_LENGTH_PASSWORD = 100
  MIN_LENGTH_PASSWORD = 10

  STATUS_ACTIVE = "ACTIVE"
  STATUS_INACTIVE = "INACTIVE"
  STATUS_DEACTIVATED = "DEACTIVATED"

    def initialize(dbOject)
      user = dbOject.fields[0]
      @username = user["username"]
      @status   = user["status"]
    end

    def self.generateRandomUsername
      seed = self.all.count
      random = Random.new(seed)

      byteVal = self::USERNAME_LENGTH / 2
      random.bytes(byteVal).unpack1("H*")
    end

    def self.is_valid_password?(password)
      !password.nil? and password.length < self::MAX_LENGTH_PASSWORD and password.length > self::MIN_LENGTH_PASSWORD
    end

    def self.is_valid_username?(username)
      !username.nil? and self::USERNAME_LENGTH == username.length
    end

    def self.createActive(username, password)
      password = Obfuscator.encrypt(password)
      User.create("username" => username, "password" => password, "status" => User::STATUS_ACTIVE)
    end

    def self.getActiveUser(username, password)
      password = Obfuscator.encrypt(password)
      User.all(filter: "AND({username} = '#{username}', {password} = '#{password}', {status} = '#{self::STATUS_ACTIVE}')")
    end
end
