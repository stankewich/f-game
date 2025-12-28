package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	port := os.Getenv("MATCH_ENGINE_PORT")
	if port == "" {
		port = "8080"
	}

	r := gin.Default()
	
	// Health check endpoint
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "ok",
			"service": "match-engine",
		})
	})

	// Basic match simulation endpoint (placeholder)
	r.POST("/simulate", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Match simulation not implemented yet",
		})
	})

	fmt.Printf("Match Engine starting on port %s\n", port)
	log.Fatal(r.Run(":" + port))
}