class Obfuscator
  attr_reader :encryptor

  def initialize
    secret = Rails.application.credentials.dig(:obfuscator, :secret_key)
    @encryptor = ActiveSupport::MessageEncryptor.new(secret, cipher: "aes-256-gcm")
  end

  def self.obfuscate(input)
    new.encryptor.encrypt_and_sign(input)
  end

  def self.unobfuscate(input)
    new.encryptor.decrypt_and_verify(input)
  end

  # Deterministically encrypts
  def self.encrypt(input)
    secret = Rails.application.credentials.dig(:obfuscator, :secret_key)
    OpenSSL::HMAC.hexdigest("SHA256", secret, input.to_s)
  end
end
