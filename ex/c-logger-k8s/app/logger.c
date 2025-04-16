#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <microhttpd.h>

#define PORT 8081

// Struct to hold POST data
struct connection_info_struct {
    char *post_data;
    size_t post_data_size;
};

// Handler to process the request
enum MHD_Result log_request(
    void *cls,
    struct MHD_Connection *connection,
    const char *url,
    const char *method,
    const char *version,
    const char *upload_data,
    size_t *upload_data_size,
    void **con_cls)
{
    struct connection_info_struct *con_info;

    if (*con_cls == NULL) {
        con_info = malloc(sizeof(struct connection_info_struct));
        con_info->post_data = NULL;
        con_info->post_data_size = 0;
        *con_cls = (void *)con_info;
        return MHD_YES;
    }

    con_info = * (struct connection_info_struct **) con_cls;

    if (strcmp(method, "POST") == 0) {
        if (*upload_data_size != 0) {
            con_info->post_data = realloc(con_info->post_data, con_info->post_data_size + *upload_data_size + 1);
            memcpy(&(con_info->post_data[con_info->post_data_size]), upload_data, *upload_data_size);
            con_info->post_data_size += *upload_data_size;
            con_info->post_data[con_info->post_data_size] = '\0';
            *upload_data_size = 0;
            return MHD_YES;
        }

        // Finalize the response after receiving all data
        printf("Received POST request for %s\n", url);
        if (con_info->post_data_size > 0) {
            printf("Body: %s\n", con_info->post_data);
        }

        const char *response_str = "POST data logged\n";
        struct MHD_Response *response = MHD_create_response_from_buffer(
            strlen(response_str),
            (void *)response_str,
            MHD_RESPMEM_PERSISTENT);

        enum MHD_Result ret = MHD_queue_response(connection, MHD_HTTP_OK, response);
        MHD_destroy_response(response);
        free(con_info->post_data);
        free(con_info);
        *con_cls = NULL;
        return ret;
    }

    // Default for non-POST
    printf("Received %s request for %s\n", method, url);

    const char *response_str = "Request received\n";
    struct MHD_Response *response = MHD_create_response_from_buffer(
        strlen(response_str),
        (void *)response_str,
        MHD_RESPMEM_PERSISTENT);

    enum MHD_Result ret = MHD_queue_response(connection, MHD_HTTP_OK, response);
    MHD_destroy_response(response);
    free(con_info);
    *con_cls = NULL;
    return ret;
}

int main()
{
    struct MHD_Daemon *daemon;

    daemon = MHD_start_daemon(
        MHD_USE_INTERNAL_POLLING_THREAD, PORT,
        NULL, NULL,
        &log_request, NULL,
        MHD_OPTION_NOTIFY_COMPLETED, NULL, NULL,
        MHD_OPTION_END);

    if (NULL == daemon)
    {
        fprintf(stderr, "Failed to start HTTP server\n");
        return 1;
    }

    printf("HTTP server running on port %d\n", PORT);

    while (1) {
        sleep(1);
    }

    MHD_stop_daemon(daemon);
    return 0;
}
