#include <microhttpd.h>
#include <string.h>
#include <stdio.h>

#define PORT 8081

int log_request(void *cls, struct MHD_Connection *connection,
                const char *url, const char *method,
                const char *version, const char *upload_data,
                size_t *upload_data_size, void **con_cls) {
    
    static int dummy;
    if (*con_cls == NULL) {
        *con_cls = &dummy;
        return MHD_YES;
    }

    if (strcmp(method, "POST") == 0 && *upload_data_size > 0) {
        printf("📥 Received log: %.*s\n", (int)*upload_data_size, upload_data);
        *upload_data_size = 0;
    }

    const char *response = "OK\n";
    struct MHD_Response *resp = MHD_create_response_from_buffer(strlen(response),
                                (void *)response, MHD_RESPMEM_PERSISTENT);
    int ret = MHD_queue_response(connection, MHD_HTTP_OK, resp);
    MHD_destroy_response(resp);
    return ret;
}

int main() {
    struct MHD_Daemon *daemon;

    daemon = MHD_start_daemon(MHD_USE_AUTO, PORT, NULL, NULL,
                              &log_request, NULL, MHD_OPTION_END);
    if (NULL == daemon) {
        return 1;
    }

    printf("📡 Logger service running on port %d...\n", PORT);
    getchar();
    MHD_stop_daemon(daemon);
    return 0;
}
