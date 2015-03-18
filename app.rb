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
    property :songs,      Text
    property :guest_name, Text
    property :advice,     Text
    property :location,   String
    property :created_at, DateTime
end
DataMapper.auto_migrate!

class App < Sinatra::Base
    enable :sessions
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
        erb :welcome, :layout => :base, :locals => {
            :attending => session[:attending]
        }
    end

    get '/wedding' do
        erb :wedding, :layout => :base
    end

    get '/rsvp' do
        erb :rsvp, :layout => :base
    end

    get '/registry' do
        erb :registry, :layout => :base
    end

    get '/guests' do
        erb :guests, :locals => {:guests => Guest.all}
    end

    get '/locations' do
        content_type :json
        Guest.all.map do |guest|
            guest.location
        end.to_json
    end

    post '/submit' do
        attending = params[:attending]
        @guest = Guest.create(
            :name       => params[:name],
            :attending  => attending,
            :num_guests => params[:num_guests],
            :guest_name => params[:guest_name],
            :songs      => params[:songs],
            :advice     => params[:advice],
            :location   => params[:location],
            :created_at => Time.now
        )

        session[:attending] = attending
        redirect to('/')
    end

    run! if __FILE__ == $0
end
