#include <string>
#include <iostream>
#include <thread>
#include <cstdlib>

using namespace std;

int main(int argc, char ** argv)
{ 
    //thread t1(task1, "Hello");
    // Makes the main thread wait for the new thread to finish execution, therefore blocks execution.
    //t1.join();
    cout << "Currently Programming" << endl;
    return 0;
}
