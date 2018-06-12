#include "symbol_table.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define TABLE_SIZE 4000

struct s_table
{
    uint32_t pointer;
    t_symbol entries[TABLE_SIZE];
};

typedef struct s_table t_table;

t_table global_table = {0};

uint32_t add_symbol(const uint8_t* id, t_type type, uint8_t depth)
{
    t_symbol *new_symbol = &(global_table.entries[global_table.pointer]);
    strcpy(new_symbol->id, id);
    new_symbol->mem_size = type;
    new_symbol->initialized = 0;
    new_symbol->depth = depth;

    global_table.pointer++;

    return global_table.pointer - 1;
}

void pop_symbol(){
    global_table.pointer--;
}

uint32_t get_address(const uint8_t* id, uint8_t depth)
{
    for(uint32_t i=0; i<global_table.pointer; i++)
    {
        t_symbol *cur_symbol = &(global_table.entries[i]);
        if(cur_symbol->depth == depth)
            if(!strcmp(cur_symbol->id, id))
                return i;
    }

    /* Critical failure: access to inexistent symbol */  
    exit(-666);  
}

uint32_t get_last_pointer(){
    return global_table.pointer-1;
}

t_type get_type(const uint8_t* id, uint8_t depth)
{
    uint32_t addr = get_address(id, depth);
    return global_table.entries[addr].mem_size;
}

void set_initialized(const uint8_t* id, uint8_t depth)
{
    uint32_t addr = get_address(id, depth);
    global_table.entries[addr].initialized = 1;
}

uint8_t is_initialized(const uint8_t* id, uint8_t depth)
{
    uint32_t addr = get_address(id, depth);
    return global_table.entries[addr].initialized;
}

void print_table()
{
    printf("~~~~ Symbol table dump ~~~~\n");
    for(uint32_t i=0; i<global_table.pointer; i++)
    {
        t_symbol *cur_symbol = &(global_table.entries[i]);
        uint8_t depth = cur_symbol->depth;
        printf("idx=%d", i);
        for(uint8_t j=0; j<depth; j++)
            printf("\t");

        printf("id=%s\tsize=%d\tinit=%d\n", cur_symbol->id, cur_symbol->mem_size, cur_symbol->initialized);
    } 
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");   
}