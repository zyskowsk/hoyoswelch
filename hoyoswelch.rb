require 'sinatra'
require 'sinatra/assetpack'

class HoyosWelch < Sinatra::Base
    set :root, File.dirname(__FILE__)
    register Sinatra::AssetPack

    assets do
        css_dir = 'less'
        serve '/css', from: css_dir

        css :base, '/css/base.css', [
            '/css/base.css'
        ]
    end


    get '/' do
        erb :base
    end

    run! if __FILE__ == $0
end
