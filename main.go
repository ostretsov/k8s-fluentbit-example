package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		defer func(start time.Time) {
			log(fmt.Sprintf("request processing is finished, took %04f seconds", time.Now().Sub(start).Seconds()))
		}(time.Now())
		log("request processing is started")
		time.Sleep(time.Duration(rand.Intn(50)) * time.Millisecond)
		writer.Write([]byte("Ok"))
	})
	panic(http.ListenAndServe(":8888", http.DefaultServeMux))
}

type logRecord struct {
	Message string `json:"message"`
}

func log(message string) {
	encodedMessage, _ := json.Marshal(logRecord{message})
	fmt.Println(string(encodedMessage))
}
