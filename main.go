package main

import "github.com/confluentinc/confluent-kafka-go/kafka"

func main() {
	p, err := kafka.NewProducer(&kafka.ConfigMap{"bootstrap.servers": "localhost"})
	if err != nil {
		panic(err)
	}

	defer p.Close()
}
