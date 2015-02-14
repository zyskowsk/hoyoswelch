require 'sinatra'
require 'sinatra/assetpack'
require 'less'
require 'data_mapper'
require 'json'


MYSQL_PW=''
if ENV['TEST_ENV'] == 'prod'
    MYSQL_PW = ':seattle';
end

DataMapper.setup(:default, "mysql://root#{MYSQL_PW}@localhost/hoyoswelch")

class Guest
    include DataMapper::Resource
    property :id,         Serial
    property :name,       String
    property :created_at, DateTime
end
DataMapper.auto_migrate!

class App < Sinatra::Base
    set :root, File.dirname(__FILE__)

    register Sinatra::AssetPack

    assets {
        serve '/css',   from: 'media/less'
        serve '/images', from: 'media/images'

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
