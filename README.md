## ExcelliCalc

# ScyllaDB

docker run --rm \
   -p 127.0.0.1:9042:9042 \
   scylladb/scylla \
       --smp 1 \
       --listen-address 0.0.0.0 \
       --broadcast-rpc-address 127.0.0.1

# Steps

- iex -S mix phx.server
  - iex(1)> ExcelliCalc.Migration.run

## Login 

# Request
curl --location --request POST 'http://localhost:4000/api/login' \
--data-raw '{
    "username": "aman",
    "password": "aman"
}'

# Response
{
    "data": {
        "user_id": "abc15f51-1620-495e-9b9c-4f6a61b9af1b"
    }
}

## Calculate 

# Request
curl --location --request POST 'http://localhost:4000/api/calculate' \
--header 'Authorization: abc15f51-1620-495e-9b9c-4f6a61b9af1b' \
--header 'Content-Type: application/json' \
--data-raw '{
    "lvalue": 15,
    "rvalue": 10,
    "operator": "/"
}'

# Response
{
    "data": {
        "result": "1.5"
    }
}

## History 

# Request
curl --location --request GET 'http://localhost:4000/api/history' \
--header 'Authorization: abc15f51-1620-495e-9b9c-4f6a61b9af1b'

# Response
{
    "data": [
        {
            "created_at": 1683894083,
            "lvalue": "15",
            "operator": "/",
            "result": "1.5",
            "rvalue": "10"
        },
        {
            "created_at": 1683893910,
            "lvalue": "15",
            "operator": "/",
            "result": "1.5",
            "rvalue": "10"
        }
    ]
}