class Invoice
	require 'redis'

	$redis = Redis.new

    def self.createinvoice(email, video)
        keyid = $redis.incr "invoice"
        invoicekey = "invoice:#{keyid}"

        customerid = $redis.hget("customer:find:email", email)

        $redis.hmset invoicekey, 'email',email, 'customerid', customerid, 'video', video, 'dateordered', Time.now
        $redis.lpush('invoicelist', invoicekey)
    end


    def self.getinvoicedashboard
        # Is Keys really a good way to do this? 
        #keylist = redis.keys 'invoice:*'
        #@invoices = redis.sort( 'invoicelist', :by =>["email"], :get => ['*->video', '*->email'])
        $redis.sort( 'invoicelist', :by =>["dateordered"], :get => ['*->invoicekey', '*->video', '*->email'])
    end

end