// https://www.reddit.com/r/haskell/comments/6iukkz/interfacing_with_vendor_c_library/
// https://stackoverflow.com/questions/8889388/schedule-error-when-calling-multi-threaded-c-ffi-with-haskell-callback-function

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>

typedef struct {
  int threadIndex;
  void (*callback)(int);
} ThreadConfig;

void *my_thread(void *threadConfig_)
{
  ThreadConfig *threadConfig = reinterpret_cast<ThreadConfig *>(threadConfig_);
#if 0
  sleep(1); // pretend to work for a while...
#else
  std::cout << "Hello from thread #" << threadConfig->threadIndex << "\n";
#endif
  threadConfig->callback(threadConfig->threadIndex);
  return NULL;
}

extern "C"
void spawn_threads(int count, void (*callback)(int)) {
  struct Threads {
     pthread_t *threads;
     ThreadConfig *threadConfigs;
     ~Threads() {
        delete [](threadConfigs);
        delete [](threads);
     }
  } ts = {
     new pthread_t[ (sizeof(pthread_t) * count) ],
     new ThreadConfig[ (sizeof(ThreadConfig) * count) ]
  };

  for (int i=0; i<count; ++i) {
    ts.threadConfigs[i].threadIndex = i;
    ts.threadConfigs[i].callback = callback;
    if (pthread_create(&(ts.threads[i]), NULL, my_thread, &(ts.threadConfigs[i]))) {
      fprintf(stderr, "error creating thread\n");
      exit(1);
    }
  }

  for (int i=0; i<count; ++i) {
    if (pthread_join(ts.threads[i], NULL)) {
      fprintf(stderr, "error joining thread\n");
      exit(1);
    }
  }

}

