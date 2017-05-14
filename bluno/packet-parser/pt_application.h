#ifndef PT_APPLICATION_H
#define PT_APPLICATION_H

//typedef char (app_consume_bytes_f)(const void *buffer, uint8_t size, void *application_specific_key) ;

typedef char (^app_consume_bytes_b)(const void *buffer, uint8_t size, void *application_specific_key) ;

#endif

