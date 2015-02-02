require 'sinatra'

class HoyosWelch < Sinatra::Base
    get '/' do
        'hey this works THE DEPLOY WORKED AAAAGGGAAAIIINNN'
    end

    run! if __FILE__ == $0
end
