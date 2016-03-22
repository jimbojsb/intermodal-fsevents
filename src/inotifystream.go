package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os/exec"
	"strings"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	wg.Add(2)

	filesModified := make(chan string, 256)
	fmt.Println("Watching /sync...")

	go func() {
		cmd := exec.Command("/usr/bin/inotifywait", "-m", "-r", "-e", "modify,create,delete", "/sync")
		stdout, err := cmd.StdoutPipe()
		if err != nil {
			log.Fatal(err)
		}
		cmd.Start()
		r := bufio.NewReader(stdout)
		for {
			line, _, err := r.ReadLine()
			if err != nil {
				log.Fatal(err)
			}
			stringParts := strings.Split(string(line), " ")
			file := stringParts[0] + stringParts[2]
			file = file[0:len(file) - 1]
			fmt.Println(file)
			filesModified <- file
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
			file := <-filesModified
			file += "\n"
			_, err = conn.Write([]byte(file))
			if err != nil {
				log.Fatal("Write to server failed:", err.Error())
			}
		}
	}()

	wg.Wait()
}
