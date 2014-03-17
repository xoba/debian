package main

import (
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %q\n", r.Method, r.RemoteAddr, r.RequestURI)
		w.WriteHeader(http.StatusNoContent)

	})
	log.Fatal(http.ListenAndServe(":8080", nil))
	<-make(chan bool)
}
