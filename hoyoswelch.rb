require 'sinatra'

class HoyosWelch < Sinatra::Base
    get '/' do
        erb :base
    end

    run! if __FILE__ == $0
end
