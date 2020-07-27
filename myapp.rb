require 'sinatra'
require 'bcrypt'
require 'digest'

BCrypt::Engine.cost = ENV.fetch('BCRYPT_COST', 10)

class PasswordValidator
  attr_reader :error_message

  def initialize(password, confirmation)
    @password = password
    @confirmation = confirmation
  end

  def valid?
    if password.length < 8
      @error_message = 'Password is too short'
      false
    elsif password != confirmation
      @error_message = 'Password does not match confirmation'
      false
    else
      true
    end
  end

  private

  attr_reader :password, :confirmation
end

get '/' do
  erb :index
end

post '/bcrypt/generate' do
  password = params['password'].to_s
  confirmation = params['password_confirmation'].to_s

  validator = PasswordValidator.new(password, confirmation)

  if validator.valid?
    hash = BCrypt::Password.create(password)
    erb :generate_success, locals: { hash: hash }
  else
    erb :generate_failed, locals: { message: validator.error_message }
  end
end

post '/md5/generate' do
  username = params['username'].to_s
  password = params['password'].to_s
  confirmation = params['password_confirmation'].to_s

  validator = PasswordValidator.new(password, confirmation)

  if validator.valid?
    hash = Digest::MD5.hexdigest(password + username)
    erb :generate_success, locals: { hash: 'md5' + hash }
  else
    erb :generate_failed, locals: { message: validator.error_message }
  end
end
