#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end
require "sinatra/base"
require "better_errors"
require './model/customer.rb'

class CustomerApp < Sinatra::Base
        enable :sessions
        register Sinatra::Flash
        set :views, 'views/'
        set :public_folder, 'public/'

        use BetterErrors::Middleware
        BetterErrors.application_root = File.expand_path("..", __FILE__)

        redis = Redis.new

        get "/" do 
            
            keylist = redis.keys 'invoice:*'
            @invoices = keylist = redis.sort( 'invoicelist', :by =>["email"], :get => ['*->video', '*->email'])

            @greeting = redis.get "appgreeting"
            @videos = redis.lrange "vidlist" ,0 ,-1

            erb :customerindex, :layout => :applayout
        end

        get "/create/?" do 
            erb :"createcustomer", :layout => :applayout
        end

        post "/create/?" do
            #we would do some validation here
            email = params[:email]  
            name = params[:name]
            password = params[:password]
            happy = 'yes'
            
            Customer.createcustomer(email, password, name, happy)
            redirect '/' 
        end

end