class Customer
	require 'redis'

	$redis = Redis.new

    def self.createcustomer(email, name, happy)
        keyid = $redis.incr "customerid"
        customerkey = 'customer:' + keyid.to_s
     
        $redis.hmset customerkey, 'email',email, 'name', name, 'happy', happy, 'signupdate', Time.now
        $redis.lpush('customerlist', customerkey)
        $redis.lpush('customeremaillist', email)
    end

#	def seedcustomer
#		redis.set "customerid",0
        
#        customer = Hash.new
        
#        customer = {"customerid"=> getpk,
#               "email"=>'robs@example.com', "name"=>'rob sullivan', "happy"=>'yes', "signupdate"=>Time.now }

        #redis.hmset customer["customerid"], customer
#        redis.lpush('customerlist', customer["customerid"])
#        redis.lpush('customeremaillist', customer["email"])
            
#        customerid = redis.incr "customerid"                    
#        customer = {"customerid"=> 'customer:' + customerid,
#                    "email"=>'robc@example.com', "name"=>'rob conery', "happy"=>'yes' }
#        redis.hmset invoicekey, 'email',email, 'video', video, 'dateordered', dateordered
#        redis.lpush('invoicelist', invoicekey)
#	end
	
#	def getpk
#		customerid = redis.incr "customerid"
#		"customer:#{customerid}"
#	end


end