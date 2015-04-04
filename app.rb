require 'sinatra'
require 'sinatra/assetpack'
require 'less'
require 'data_mapper'
require 'json'


DataMapper.setup(:default, "mysql://root:seattle@localhost/hoyoswelch")

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
DataMapper.finalize

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
        attending = session[:attending]
        session.clear
        erb :welcome, :layout => :base, :locals => {
            :attending => attending
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
        attending_guests = Guest.all(:attending => true)
        not_attending_guests = Guest.all(:attending => false)

        erb :guests, :locals => {
            :attending_guests => attending_guests,
            :not_attending_guests => not_attending_guests,
            :num_attending => attending_guests.inject(0) { |result, guest| result + guest.num_guests },
        }
    end

    get '/locations' do
        secret = params[:secret]
        content_type :json
        if secret == 'eert432dff'
            locations =Guest.all.map do |guest|
                guest.location if !guest.location.empty?
            end.compact

            locations.to_json
        else
            halt 403
        end
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
        session[:show_flash] = true
        redirect to('/')
    end

    run! if __FILE__ == $0
end
