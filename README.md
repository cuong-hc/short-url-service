# README

This is source code for the back-end of Short URL project. 

To convert long url to short url, my solution is: 
  - Generating unique key_code beforehand and stores them in database table "key_availables". Please check function `ShortenerUrlService.generate_key_code_offline`
  - Whenever we want to shorten a URL, we will take one of the already-generated keys and use it. We won’t have to worry about duplications or collisions.
  - Solution to generate unique key_code: Convert the unique integer to a character string that is at most 6 characters long

I 've created 3 tables are: 
  - shortener_urls: To save the original_url, key_code is used and expiration time
  - key_availables: generates random unique strings beforehand
  - key_useds: mark the keys are used for create short url

My API: 
  - POST api/encode: Encode the original url
    params: original_url
  - POST api/decode: Decode the original url
    params: key_code

For improvement, we need to define the mechanic or schedule to insert new key_code in table "keys_available" when it have less records

## Run project by Docker

- Install docker: https://docs.docker.com/engine/install/
- Copy file .env.example to .env and replace the values if needed
- Go source folder and run following command to start docker: `docker-compose up`
- Wait until docker has installed all of the libraries and start _rails server_ successfully
- Open browser and go to: http://localhost:3000

## Potential attack vectors on the application

-  DoS Attacks
-  Man-In-The-Middle-Attack

## Scale up and solve the collision problem. 
 - Decouple service "Generate key_codes" as a standalone service -> using NoSQL to store the keys
 - Database Partioning and Replication: to store information about billions of URLs
 - Caching: Cache URLs that are frequently accessed and cache a part of keys_available in memory for avoiding the hitting of the database.
 - Apply load balancer and auto-scaling for Application Servers, Database Servers, Cache servers
 - DB Cleanup 
  - Set default expiration time for each link
  - Whenerver user access the expired link -> return the error
  - A seperate service to remove the expired link from database and cache. 
  - After removing an expired link, we can put the key_code back into "keys_available" to be reused.
 