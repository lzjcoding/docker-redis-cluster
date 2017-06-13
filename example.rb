#!/usr/bin/env ruby

require './cluster'

startup_nodes = [
	{:host => "127.0.0.1", :port => 8001},
	{:host => "127.0.0.1", :port => 8002}
]
rc = RedisCluster.new(startup_nodes, 32, :timeout => 0.1)

last = false

while not last
	begin
		last = rc.get("__last__")
		last = 0 if !last
	rescue => e
		puts :error #{e.to_s}"
		sleep 1
	end
end

((last.to_i+1)..1000000000).each{ |x|
	begin
		rc.set("foo#{x}", x)
		puts rc.get("foo#{x}")
		rc.set("__last__", x)
	rescue => e
		puts "error #{e.to_s}"
	end
	sleep 0.1
}
