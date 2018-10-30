#include "t_lib.h"

tcb* running;
tcb* end_queue;

void t_yield()
{
  /*ucontext_t *tmp;

  tmp = running;
  running = ready;
  ready = tmp;

  swapcontext(ready, running);*/
}

void t_init()
{

  /*  ORIGINAL IMPLEMENTATION
  ucontext_t *tmp;
  tmp = (ucontext_t *) malloc(sizeof(ucontext_t));

  getcontext(tmp);    /* let tmp be the context of main() 
  running = tmp;
  */

  tcb *tmp;
  tmp = (tcb *) malloc(sizeof(tcb));
  tmp->next = NULL;
  tmp->thread_priority = 1;

  /* let tmp be the context of main() */
  getcontext(&tmp->thread_context);
  running = tmp;
  end_queue = tmp;

 


  
}

void t_shutdown(){

  //free all
  while(running != NULL){
    tcb *tmp = running;
    running = running->next;
    free(tmp->thread_context.uc_stack.ss_sp);
    free(tmp);
  }
  
}

int t_create(void (*fct)(int), int id, int pri)
{
  size_t sz = 0x10000;

  ucontext_t *uc;
  uc = (ucontext_t *) malloc(sizeof(ucontext_t));

  getcontext(uc);
/***
  uc->uc_stack.ss_sp = mmap(0, sz,
       PROT_READ | PROT_WRITE | PROT_EXEC,
       MAP_PRIVATE | MAP_ANON, -1, 0);
***/
  uc->uc_stack.ss_sp = malloc(sz);  /* new statement */
  uc->uc_stack.ss_size = sz;
  uc->uc_stack.ss_flags = 0;
  uc->uc_link = running; 
  makecontext(uc, (void (*)(void)) fct, 1, id);
  ready = uc;
}
