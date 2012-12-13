#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end
require "sinatra/base"
require "better_errors"
require './model/customer.rb'
require './model/invoice.rb'

class RedisAdminApp < Sinatra::Base
        enable :sessions
        register Sinatra::Flash
        set :views, 'views/'
        set :public_folder, 'public/'

    redis = Redis.new

        get "/seeddata/?" do 
            redis.flushdb
            redis.set "appgreeting", "Welcome Users!"

            redis.set "visitorreward", 0
            redis.set "randomwinnercount", 0
            
            #only set the value if the key doesn't exist
            redis.setnx "customerid",0
            redis.setnx "invoiceid",0

            redis.rpush "vidlist", "Postgres"
            redis.rpush "vidlist", "RavenDB"
            redis.rpush "vidlist", "SQL Server"

            Customer.createcustomer('robs@example.com', 'TopRob', 'rob sullivan', 'yes')
            Customer.createcustomer('robc@example.com', 'AppDevil', 'rob conery', 'yes')

            Invoice.createinvoice('robs@example.com', 'Postgres')
            Invoice.createinvoice('robc@example.com', 'SQL Server')

            redirect '/' 

            'data has been seeded'
        end

        get "/" do
        	renfo = redis.info
        	renfo.to_s
        end	

        get "/seedcustomer/" do
            #Customer.seedcustomer
            "yay"
        end

        #dummy URL for looking at output
        get "/blarby/" do 
            @videos = redis.lrange "vidlist" ,0 ,-1
            @videos.inspect
        end
end

   # def get_pk(classtype)
    #        properkey = classtype + 'id'
    #        pk = redis.incr properkey
    #        "#{classtype}:#{pk}"
    #end