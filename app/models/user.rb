Airrecord.api_key = Rails.application.credentials.dig(:airtable, :api_key)

class User < Airrecord::Table
  self.base_key = Rails.application.credentials.dig(:airtable, :base_key_users)
  self.table_name = "users"

    def self.generateRandomUsername
      seed = self.all.count
      random = Random.new(seed)

      random.bytes(16).unpack1("H*")
    end
end
