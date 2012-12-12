#configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
#  uri = URI.parse(REDISTOGO_URL)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#end
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
            redis.set "customerid",0
            redis.set "invoiceid",0

            redis.rpush "vidlist", "Postgres"
            redis.rpush "vidlist", "RavenDB"
            redis.rpush "vidlist", "SQL Server"

            Customer.createcustomer('robs@example.com', 'rob sullivan', 'yes')
            Customer.createcustomer('robc@example.com', 'rob conery', 'yes')

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


    class Customer
        $redis = Redis.new

        def self.createcustomer(email, name, happy)
            keyid = $redis.incr "customerid"
            customerkey = 'customer:' + keyid.to_s
     
            $redis.hmset customerkey, 'email',email, 'name', name, 'happy', happy, 'signupdate', Time.now
            $redis.lpush('customerlist', customerkey)
            $redis.lpush('customeremaillist', email)
        end
    end

    class Invoice
        $redis = Redis.new

        def self.createinvoice(email, video)
            keyid = $redis.incr "invoice"
            invoicekey = 'invoice:' + keyid.to_s
     
            $redis.hmset invoicekey, 'email',email, 'video', video, 'dateordered', Time.now
            $redis.lpush('invoicelist', invoicekey)
        end
    end
end

   # def get_pk(classtype)
    #        properkey = classtype + 'id'
    #        pk = redis.incr properkey
    #        "#{classtype}:#{pk}"
    #end