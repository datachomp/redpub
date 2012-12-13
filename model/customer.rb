class Customer
	require 'redis'

	$redis = Redis.new

    def self.createcustomer(email, password, name, happy)
      
      #All or nothing here. Everything will execute in order
      # as well as stay isolated, and rollback  
      keyid = $redis.incr 'customerid'
      customerkey = "customer:" + keyid.to_s

      $redis.multi do
        #keyid = $redis.incr 'customerid'
        #customerkey = "customer:" + keyid.to_s
     
        $redis.hmset customerkey, 'email',email,'password',password, 'name', name, 'happy', happy, 'signupdate', Time.now
        $redis.lpush('customerlist', customerkey)
        $redis.hset 'customer:find:email', email, customerkey
      end
    end


    def self.getcustomerbyemail(email)
      $redis.multi do
        customerid = $redis.hget('customer:find:email', email)
        $redis.get(customerid)
      end
    end

end