#ifndef TLV_LEN_H
#define TLV_LEN_H

#import "common.h"
#import "pt_type.h"

char tlv_len_serialize(tlv_len_t len, void *bufptr, uint8_t size) ;
char tlv_len_fetch(boolean is_constructed, const void *bufptr, uint8_t size, tlv_len_t *len_r) ;
char tlv_len_skip(struct codec_ctx_s *opt_codec_ctx, boolean is_constructed, const void *bufptr, uint8_t size) ;

#endif

