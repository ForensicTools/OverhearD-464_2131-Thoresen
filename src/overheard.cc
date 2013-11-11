#include <iostream>
#include <cstdlib>
#include <string>
#include <thread>
#include <mutex>
#include <map>

using namespace std;

// Mutex
static mutex mtx;

// Prototypes
void threadTest(int threadId);

/** 
 * A simple test to see whether or not threads are working
 * outputs the threadId every 2 seconds.
 */
int main(int argc, char ** argv) { 
    thread coreThread(threadTest, 0);
    thread SecondaryThread(threadTest, 1);
    coreThread.join();
    SecondaryThread.join();
    return 0;
}

/**
 * A simple test to see whether or not threads are working
 * outputs the threadId every 2 seconds.
 */
void threadTest(int threadId) {
    map<string, int> currentThreadInfo;
    currentThreadInfo["iteration"] = 0;
    currentThreadInfo["thread_id"] = threadId;

    mtx.lock();

    while(1) {
        if (currentThreadInfo["iteration"] > 3) { break; }
        this_thread::sleep_for(chrono::seconds(2));
        cout << "Thread ID: " << currentThreadInfo["thread_id"] << " - Iteration: " << currentThreadInfo["iteration"] << endl;
        currentThreadInfo["iteration"]++;
    }

    mtx.unlock();
}
