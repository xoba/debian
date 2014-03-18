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

	var halt, wait, inf bool
	flag.BoolVar(&halt, "halt", false, "whether to halt after first call")
	flag.BoolVar(&wait, "wait", true, "wait to be contacted by vm's")
	flag.BoolVar(&inf, "inf", false, "get info on network interfaces")
	flag.Parse()

	switch {
	case inf:
		fmt.Println(probeInterfaces())
	case wait:
		server(halt)
	default:
	}
}

func IsFlagSet(set, f net.Flags) bool {
	return set&f == f
}

func probeInterfaces() (string, string) {
	infs, err := net.Interfaces()
	check(err)
	for _, x := range infs {
		if IsFlagSet(x.Flags, net.FlagUp) && !IsFlagSet(x.Flags, net.FlagLoopback) {
			addrs, err := x.Addrs()
			check(err)
			if len(addrs) > 0 {
				if i, ok := addrs[0].(*net.IPNet); ok {
					return x.Name, i.IP.String()
				}
			}
		}
	}
	panic("can't find network")
}

func server(halt bool) {
	log.Printf("waiting to be contacted by running vm...")

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

func check(e error) {
	if e != nil {
		panic(e)
	}
}
