// gcc --threaded 

// https://www.reddit.com/r/haskell/comments/6iukkz/interfacing_with_vendor_c_library/
// https://stackoverflow.com/questions/8889388/schedule-error-when-calling-multi-threaded-c-ffi-with-haskell-callback-function

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct {
  int threadIndex;
  void (*callback)(int);
} ThreadConfig;

void *my_thread(void *threadConfig_)
{
  ThreadConfig *threadConfig = threadConfig_;
  sleep(1); // pretend to work for a while...
  threadConfig->callback(threadConfig->threadIndex);
  return NULL;
}

void spawn_threads(int count, void (*callback)(int)) {
  pthread_t *threads = malloc(sizeof(pthread_t) * count);
  ThreadConfig *threadConfigs = malloc(sizeof(ThreadConfig) * count);

  for (int i=0; i<count; ++i) {
    threadConfigs[i].threadIndex = i;
    threadConfigs[i].callback = callback;
    if (pthread_create(&(threads[i]), NULL, my_thread, &(threadConfigs[i]))) {
      fprintf(stderr, "error creating thread\n");
      exit(1);
    }
  }

  for (int i=0; i<count; ++i) {
    if (pthread_join(threads[i], NULL)) {
      fprintf(stderr, "error joining thread\n");
      exit(1);
    }
  }

  free(threadConfigs);
  free(threads);
}

