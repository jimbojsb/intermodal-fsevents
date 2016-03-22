package main;

import (
	"log"
	"sync"
	"net"
	"github.com/rjeczalik/notify"
)

func main() {
	var wg sync.WaitGroup
	wg.Add(2)

	filesModified := make(chan string)
	inotifyEvents := make(chan notify.EventInfo, 32)
	if err := notify.Watch("/sync/...", inotifyEvents, notify.All); err != nil {
		log.Fatal(err)
	}
	defer notify.Stop(inotifyEvents)

	go func() {
		for {
			eventInfo := <- inotifyEvents
			filesModified <- eventInfo.Path()
		}
	}()

	go func() {
		inboundSocket, err := net.Listen("tcp4", ":2874")
		if err != nil {
			log.Fatal(err)
		}
		conn, err := inboundSocket.Accept()
		if err != nil {
			log.Fatal(err)
		}
		for {
			file := <- filesModified
			file += "\n"
			_, err = conn.Write([]byte(file))
			if err != nil {
				log.Fatal("Write to server failed:", err.Error())
			}
		}
	}()

	wg.Wait()
}