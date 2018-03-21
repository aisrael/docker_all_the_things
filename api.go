package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Greeting struct {
	Greeting string `json:"greeting"`
}
type Data struct {
	Data interface{} `json:"data"`
}

func main() {
	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		who := "world"
		values, ok := r.URL.Query()["who"]
		if ok && len(values) > 0 {
			who = values[0]
		}
		data := Data{Data: Greeting{Greeting: fmt.Sprintf("Hello, %s!", who)}}
		json.NewEncoder(w).Encode(data)
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
