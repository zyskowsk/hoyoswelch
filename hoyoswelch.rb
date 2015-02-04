require 'sinatra'

class HoyosWelch < Sinatra::Base
    get '/' do
        'hey guys.'
    end

    run! if __FILE__ == $0
end
