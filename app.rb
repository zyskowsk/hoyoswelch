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
    property :num_guests, Integer
    property :attending,  Boolean
    property :advice,     Text
    property :created_at, DateTime

    has n, :plus_ones
    has n, :songs
end

class PlusOne
    include DataMapper::Resource
    property :id,   Serial
    property :name, String

    belongs_to :guest
end

class Song
    include DataMapper::Resource
    property :id,   Serial
    property :name, String

    belongs_to :guest
end

DataMapper.auto_migrate!

class App < Sinatra::Base
    set :root, File.dirname(__FILE__)

    register Sinatra::AssetPack

    assets {
        serve '/css',       from: 'media/less'
        serve '/images',    from: 'media/images'
        serve '/js',        from: 'media/js'

        css :app, [
            '/css/base.css'
        ]

        js :app, [
            '/js/app.js'
        ]

        css_compression :less
        js_compression  :jsmin
    }


    get '/' do
        erb :base
    end

    get '/guests' do
        erb :guests, :locals => {:guests => Guest.all}
    end

    post '/submit' do
        @guest = Guest.create(
            :name => params['name'],
            :attending => params['attending'],
            :num_guests => params['num_guests'],
            :advice => params['advice'],
            :created_at => Time.now
        )

        if params['plus_ones']
            params['plus_ones'].each do |name|
                PlusOne.create(
                    :name => name,
                    :guest => @guest
                )
            end
        end

        if params['songs']
            params['songs'].each do |name|
                Song.create(
                    :name => name,
                    :guest => @guest
                )
            end
        end

        erb :thank_you, :locals => {:name => params['name']}
    end

    run! if __FILE__ == $0
end
