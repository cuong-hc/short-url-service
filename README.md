# README

Short-URL Challenge

Github: https://github.com/cuong-hc/short-url-service

Short-URL API is hosted on: https://fathomless-brook-34457.herokuapp.com

  1.  POST api/encode: Encode the original url
      - Request: 
        - curl -d '{"original_url": "https://github.com/rposborne/wkhtmltopdf-heroku/issues/111212323"}' -H "Content-Type: application/json" -X POST https://fathomless-brook-34457.herokuapp.com/api/encode
      - Response: 
        - {"short_url":"https://fathomless-brook-34457.herokuapp.com/bYk4ga"}

  2. POST api/decode: Decode the code to original url
      - Request 
        - curl -d '{"key_code": "bYk4ga"}' -H "Content-Type: application/json" -X POST https://fathomless-brook-34457.herokuapp.com/api/decode  
      - Response: 
        - {"original_url":"https://github.com/rposborne/wkhtmltopdf-heroku/issues/111223"}

To resolve this challenge, in my opinion, we need to resolve the below problems:
  1. Generate the unique key_code to map with a long URL
  2. How to get the key_code to map with a long URL fast and avoid duplications or collisions

My solutions: 
  1. To get a unique key code, I 've converted Unix timestamp by base62 conversion. Please check function  `ShortenerUrlService.base62_number_to_string` 
  2. Generating unique key_code beforehand and stores them in database table "key_availables". I 've generated about 86400 `key_code` by function `ShortenerUrlService.generate_key_code_offline(DateTime.current, DateTime.current + 1)`.
  3. Whenever we want to shorten a URL, we will take one of the already generated keys in table `key_availables` and use it. We won’t have to worry about duplications or collisions.

Database: PostgreSQL
  1. Table `shortener_urls`: store the original_url and key_code
  - `id` 
  - `original_url` 
  - `key_code`: key_code in table `key_availables`
  - `expired_at`

  2. `key_availables`: generates unique key_code from Unix Timestamp
  - `id` 
  - `key_code` 
  - `number_to_convert`: Unix Timestamp

Improvement: 
  1. Need to have a strategy to fill the new key_code in table "keys_available" when it 's empty. Such as: Cronjob to generate a new_key with a new time range
  
  2. Consider change the data type from `int` to `bigint` to store many URLs
  
## Run project by Docker

- Install docker: https://docs.docker.com/engine/install/
- Copy file .env.example to .env and replace the values if needed
- Go source folder and run following command to start docker: `docker-compose up`
- Wait until docker has installed all of the libraries and start _rails server_ successfully
- Open browser and go to: http://localhost:3000

## Potential attack vectors on the application
1. Injection Attacks
2. DoS Attacks
 - Throtlle and rate limit the API
3. Parameter Tampering  

## Scale up and solve the collision problem. 
 1. Decouple function "Generate key_code offline" to a standalone service -> using NoSQL to store the keys
 2. Database Partioning and Replication: Tuning performance for query to databases.
 3. Caching: Cache URLs that are frequently accessed and cache a part of `key_code` in table `keys_available` in memory for avoiding the hitting of the database.
 4. Apply load balancer and auto-scaling for Application Servers, Database Servers, Cache servers
 5. Stragery for DB Cleanup 
  - Set default expiration time for each link. Whenever the user access the expired link -> return the error
  - A seperate service to remove the expired link from database and cache. 
  - After removing an expired link, we can put the key_code back into table `keys_available` to be reused.
 