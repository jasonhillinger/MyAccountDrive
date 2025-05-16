Airrecord.api_key = Rails.application.credentials.dig(:airtable, :api_key)

class User < Airrecord::Table
  self.base_key = Rails.application.credentials.dig(:airtable, :base_key_users)
  self.table_name = "users"

  MAX_LENGTH_PASSWORD = 100

  STATUS_ACTIVE = "ACTIVE"
  STATUS_INACTIVE = "INACTIVE"
  STATUS_DEACTIVATED = "DEACTIVATED"

    def self.generateRandomUsername
      seed = self.all.count
      random = Random.new(seed)

      random.bytes(16).unpack1("H*")
    end
end
