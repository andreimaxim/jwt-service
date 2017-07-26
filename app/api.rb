module Token
  class API < Sinatra::Base

    set :public_folder, File.expand_path('../../public', __FILE__)

    get '/' do
      payload = Payload.new

      @id = params.fetch(:u) { nil }
      @token = payload.token(@id)

      erb :index
    end
  end
end


