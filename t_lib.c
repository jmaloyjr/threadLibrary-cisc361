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

  tcb *uc;
  uc = (tcb*) malloc(sizeof(tcb));
  uc->thread_id = id;
  uc->thread_priority = pri;

  getcontext(&uc->thread_context);

  uc->thread_context.uc_stack.ss_sp = malloc(sz);  /* new statement */
  uc->thread_context.uc_stack.ss_size = sz;
  uc->thread_context.uc_stack.ss_flags = 0;
  uc->thread_context.uc_link = running;

  makecontext(&uc->thread_context, (void (*)(void)) fct, 1, id);

  end_queue->next = uc;
  end_queue = uc;
  end_queue->next = NULL;

  return 0;
}
