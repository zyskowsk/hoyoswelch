require 'sinatra'

class HoyosWelch < Sinatra::Base
    get '/' do
        'Did. It.'
    end

    run! if __FILE__ == $0
end
