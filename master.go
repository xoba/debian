package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
)

func main() {

	log.Printf("waiting to be contacted by running vm...")

	var halt bool
	flag.BoolVar(&halt, "halt", false, "whether to halt after first call")
	flag.Parse()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %q\n", r.Method, r.RemoteAddr, r.RequestURI)
		w.WriteHeader(http.StatusNoContent)
		host, _, err := net.SplitHostPort(r.RemoteAddr)
		if err == nil {
			fmt.Printf("ssh-keygen -f ~/.ssh/known_hosts -R %s; ssh root@%s # machine %q\n", host, host, r.URL.Query().Get("name"))
			if halt {
				os.Exit(0)
			}
		}
	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}
