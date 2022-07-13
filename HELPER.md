
docker build -t bitsongofficial/go-bitsong:latest .

docker run --name go-bitsong -dp 26657:26657 -d bitsongofficial/go-bitsong:latest

docker push bitsongofficial/go-bitsong:latest


make start