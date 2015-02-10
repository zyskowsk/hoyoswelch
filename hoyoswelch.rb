require 'sinatra'
require 'sinatra/assetpack'
require 'less'

class HoyosWelch < Sinatra::Base
    set :root, File.dirname(__FILE__)

    register Sinatra::AssetPack

    assets {
        serve '/css',   from: 'public/css'

        css :application, '/css/base.less', [
            '/css/base.css'
        ]

        css_compression :less
        prequild true
    }


    get '/' do
        erb :base
    end

    run! if __FILE__ == $0
end
