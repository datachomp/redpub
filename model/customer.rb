class Customer
	require 'redis'

	$redis = Redis.new

    def self.createcustomer(email, name, happy)
      
      #All or nothing here. Everything will execute in order
      # as well as stay isolated, and rollback  
      $redis.multi()
        keyid = $redis.incr "customerid"
        customerkey = 'customer:' + keyid.to_s
     
        $redis.hmset customerkey, 'email',email, 'name', name, 'happy', happy, 'signupdate', Time.now
        $redis.lpush('customerlist', customerkey)
        $redis.lpush('customeremaillist', email)
      $redis.exec()
    end
end