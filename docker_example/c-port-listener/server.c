#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024
#define LOG_FILE "received_messages.log"

void handle_client(int client_socket, FILE *log_file) {
    char buffer[BUFFER_SIZE];
    int bytes_read;

    while ((bytes_read = read(client_socket, buffer, BUFFER_SIZE)) > 0) {
        buffer[bytes_read] = '\0';
        fprintf(log_file, "%s\n", buffer);  // Write message to log file
        fflush(log_file);                   // Ensure the file is written to disk
    }

    if (bytes_read < 0) {
        perror("Read failed");
    }
    close(client_socket);
}

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    FILE *log_file;

    // Create a socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Bind the socket to the port
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);
    
    if (bind(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        perror("Bind failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_socket, 5) == -1) {
        perror("Listen failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server is listening on port %d...\n", PORT);

    // Open log file to store received messages
    log_file = fopen(LOG_FILE, "a");
    if (!log_file) {
        perror("Failed to open log file");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    while (1) {
        // Accept an incoming connection
        client_socket = accept(server_socket, (struct sockaddr*)&client_addr, &addr_len);
        if (client_socket == -1) {
            perror("Accept failed");
            continue;
        }

        printf("Connected to client...\n");
        handle_client(client_socket, log_file);
    }

    fclose(log_file);
    close(server_socket);
    return 0;
}
