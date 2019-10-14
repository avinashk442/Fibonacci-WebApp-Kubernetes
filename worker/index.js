const keys = require('./keys');

const redis = require('redis');

const redisClient = redis.createClient({
	host: keys.redisHost,
	port: keys.redisPort,
	// retry if connection to redis server is lost after every 1 sec.
	retry_strategy: () => 1000
});
const sub = redisClient.duplicate();

function fib(index) {
	if(index < 2) return 1;
	return fib(index-1) + fib(index-2);
}

// anytime we get new message (value) we run fib function
// and insert it into hash - value will be fib output and key will be index.
sub.on('message', (channel,message) => {
	redisClient.hset('values',message,fib(parseInt(message)));
});

sub.subscribe('insert');