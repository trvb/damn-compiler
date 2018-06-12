#pragma once
#include <stdint.h>

enum e_type
{
    S8BIT=1,
    S16BIT=2
};

typedef enum e_type t_type;

struct s_symbol
{
    uint8_t id[256];
    enum e_type mem_size;
    uint8_t initialized;
    uint8_t depth;
};

typedef struct s_symbol t_symbol;

uint32_t add_symbol(const uint8_t*, t_type, uint8_t);
void pop_symbol();
uint32_t get_address(const uint8_t*, uint8_t);
t_type get_type(const uint8_t*, uint8_t);
uint32_t get_last_pointer();
void set_initialized(const uint8_t*, uint8_t);
uint8_t is_initialized(const uint8_t*, uint8_t);
void print_table();