require 'sinatra'

class HoyosWelch < Sinatra::Base
    set :root, File.dirname(__FILE__)

    get '/' do
        erb :base
    end

    run! if __FILE__ == $0
end
