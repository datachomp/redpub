class Invoice
	require 'redis'

	$redis = Redis.new

    def self.createinvoice(email, video)
        keyid = $redis.incr "invoice"
        invoicekey = 'invoice:' + keyid.to_s

        $redis.hmset invoicekey, 'email',email, 'video', video, 'dateordered', Time.now
        $redis.lpush('invoicelist', invoicekey)
    end


    def self.getinvoicedashboard
        # Is Keys really a good way to do this? 
        #keylist = redis.keys 'invoice:*'
        #@invoices = redis.sort( 'invoicelist', :by =>["email"], :get => ['*->video', '*->email'])
        $redis.sort( 'invoicelist', :by =>["email"], :get => ['*->video', '*->email'])
    end

end