package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("Welcome to the Buddha Go Service")
	fmt.Println("Current time:", time.Now().Format("2006-01-02 15:04:05"))
	
	// Simple demonstration of Go features
	verses := []string{
		"Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.",
		"Peace comes from within. Do not seek it without.",
		"The mind is everything. What you think you become.",
		"Three things cannot be long hidden: the sun, the moon, and the truth.",
		"You will not be punished for your anger, you will be punished by your anger.",
	}
	
	fmt.Println("\nBuddhist Verses:")
	for i, verse := range verses {
		fmt.Printf("%d. %s\n", i+1, verse)
	}
	
	// Demonstrate a simple function
	count := countWords(verses[0])
	fmt.Printf("\nFirst verse has %d words\n", count)
	
	// Channel demonstration
	messages := make(chan string)
	go func() {
		messages <- "May all beings be happy"
	}()
	
	msg := <-messages
	fmt.Println("\nChannel message:", msg)
}

func countWords(text string) int {
	words := 0
	inWord := false
	
	for _, char := range text {
		if char == ' ' || char == ',' || char == '.' {
			if inWord {
				words++
				inWord = false
			}
		} else {
			inWord = true
		}
	}
	
	if inWord {
		words++
	}
	
	return words
}