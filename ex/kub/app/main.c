#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <curl/curl.h>

#define PORT 8080

void send_log_to_logger() {
    CURL *curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "http://logger-python:8081/");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "Hello from c-web");
        CURLcode res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "❌ Failed to send log: %s\n", curl_easy_strerror(res));
        } else {
            printf("✅ Log sent to logger-python service\n");
        }
        curl_easy_cleanup(curl);
    }
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char response[] =
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/plain\r\n"
        "Content-Length: 15\r\n"
        "\r\n"
        "Hello from C!\n";

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == 0) {
        perror("Socket failed");
        return 1;
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        return 1;
    }

    if (listen(server_fd, 3) < 0) {
        perror("Listen");
        return 1;
    }

    printf("Listening on port %d...\n", PORT);
    curl_global_init(CURL_GLOBAL_ALL);

    while (1) {
        new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen);
        if (new_socket < 0) {
            perror("Accept");
            continue;
        }

        send_log_to_logger();  // <--- send log before responding

        send(new_socket, response, strlen(response), 0);
        close(new_socket);
    }

    curl_global_cleanup();
    return 0;
}
