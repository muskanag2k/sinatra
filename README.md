# sinatra

Write a server that can generate random API keys, assign them for usage, and release them after some time. The following endpoints should be available on the server to interact with it.
E1 -> post '/generate_keys'
There should be one endpoint to generate keys.

E2 -> get '/get_key'
There should be an endpoint to get an available key. On hitting this endpoint, the server should serve a random key that is not already being used. This key should be blocked and should not be served again by E2, till it is in this state. If no eligible key is available then it should serve 404.

E3 -> post '/unblock_key/:key'
There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.

E4 -> post '/delete_key/:key'  
There should be an endpoint to delete a key. Deleted keys should be purged.

E5 -> post '/keep_alive/:key'
All keys are to be kept alive by clients calling this endpoint every 5 minutes. If a particular key has not received a keep alive in the last five minutes then it should be deleted and never used again.

Apart from these endpoints, following rules should be enforced:
R1. All blocked keys should get released automatically within 60 secs if E3 is not called.  => check_point for this internally.

Extra Endpoints :-
get '/get_all_available_keys' to get all available keys
get '/get_all_served_keys' to get all served keys
