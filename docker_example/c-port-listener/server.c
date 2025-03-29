#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define MAX_CLIENTS 10
#define BUFFER_SIZE 1024

void handle_client(int client_socket) {
    char buffer[BUFFER_SIZE];
    char method[10];
    char path[1024];

    // Read the request from the client
    int read_size = recv(client_socket, buffer, sizeof(buffer) - 1, 0);
    if (read_size < 0) {
        perror("recv failed");
        close(client_socket);
        return;
    }

    buffer[read_size] = '\0';  // Null-terminate the received message
    printf("Received request:\n%s\n", buffer);  // Print the received request

    // Parse the request to get the method and path (only basic parsing)
    sscanf(buffer, "%s %s", method, path);

    // Handle POST method and extract the message from the body
    char *body = strstr(buffer, "\r\n\r\n");
    if (body != NULL) {
        body += 4;  // Skip the "\r\n\r\n" part to reach the body content
    } else {
        body = "No body found";
    }

    // Prepare the HTTP response
    const char *http_response_template =
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/plain\r\n"
        "Connection: close\r\n"
        "Content-Length: %d\r\n"
        "\r\n"
        "%s \n";

    // Calculate the length of the response content
    int response_length = snprintf(NULL, 0, http_response_template, (int)strlen(body), body);

    // Allocate buffer for the full HTTP response
    char http_response[response_length + 1];
    snprintf(http_response, sizeof(http_response), http_response_template,
        (int)strlen(body) + sizeof(" \n"), body);

    // Send the HTTP response to the client
    send(client_socket, http_response, response_length, 0);

    close(client_socket);
}

int main() {
    int server_socket, client_socket, client_len;
    struct sockaddr_in server_addr, client_addr;

    // Create server socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        perror("Could not create socket");
        exit(EXIT_FAILURE);
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Bind the socket to the address
    if (bind(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_socket, MAX_CLIENTS) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port %d\n", PORT);

    // Accept incoming client connections
    client_len = sizeof(client_addr);
    while ((client_socket = accept(server_socket, (struct sockaddr*)&client_addr, &client_len)) >= 0) {
        handle_client(client_socket);
    }

    if (client_socket < 0) {
        perror("Accept failed");
        exit(EXIT_FAILURE);
    }

    close(server_socket);
    return 0;
}
