require 'sinatra'
require 'sinatra/assetpack'
require 'less'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'json'

DataMapper.setup(:default, 'mysql://root:seattle@localhost/hoyoswelch')
class Guest
    include DataMapper::Resource
    property :id,         Serial
    property :name,       String
    property :created_at, DateTime
end
DataMapper.auto_migrate!

class HoyosWelch < Sinatra::Base
    set :root, File.dirname(__FILE__)

    register Sinatra::AssetPack

    assets {
        serve '/css',   from: 'less'

        css :application, [
            '/css/base.css'
        ]

        css_compression :less
    }


    get '/' do
        erb :base
    end

    get '/guests' do
        erb :guests, :locals => {:guests => Guest.all}
    end

    post '/thank-you' do
        name = params['name']

        @guest = Guest.create(
            :name => "#{name}",
            :created_at => Time.now
        )

        erb :thank_you, :locals => {:name => name}
    end

    run! if __FILE__ == $0
end
