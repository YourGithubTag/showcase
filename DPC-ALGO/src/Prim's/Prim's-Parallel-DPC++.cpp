#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>
#include <random>
#include <CL/sycl.hpp>

#define NODES 1500
#define MAX_DIST 10000

using namespace sycl;

double get_time();
void initialise_graph(int* graph, std::mt19937& rand_gen);
void print_graph(int* graph);

int main() {
    double t1, t2;
    std::mt19937 rand_gen(0);
    queue q;
    
    int* graph = (int*)malloc(sizeof(int) * NODES * NODES);
    initialise_graph(graph, rand_gen);
    printf("Initialised Graph: %d x %d\n", NODES, NODES);
    if (NODES <= 15) {
        print_graph(graph);
    }
    
    bool mst[NODES];
    memset(mst, false, sizeof(mst));
    
    int* node = malloc_shared<int>(1, q);
    node[0] = rand_gen() % NODES; // randomly select starting node
    mst[node[0]] = true; // add node to mst
    printf("Starting Node: %d\n", node[0]);
    
    int total_path = 0;
    int edges = 0;
    
    t1 = get_time();
    while (edges < NODES - 1) {
        int* min_path = malloc_shared<int>(1, q);
        min_path[0] = MAX_DIST + 1;
        
        q.submit([&](handler& h) {
            h.parallel_for(NODES, [=](auto& i) {
                ONEAPI::atomic_ref<int, ONEAPI::memory_order::relaxed, ONEAPI::memory_scope::system,
                access::address_space::global_space> atomic_min_path(min_path[0]);
                
                ONEAPI::atomic_ref<int, ONEAPI::memory_order::relaxed, ONEAPI::memory_scope::system,
                access::address_space::global_space> atomic_node(node[0]);
                
                if (mst[i]) {
                    for (int j = 0; j < NODES; j++) {
                        int path = graph[i * NODES + j];
                        
                        if (!mst[j] && path) {
                            if (path < atomic_min_path) {
                                atomic_min_path.store(path);
                                atomic_node.store(j);
                            }
                        }
                    }
                }
            });
        });
        q.wait();
        
        mst[node[0]] = true; // add node to mst
        total_path += min_path[0];
        edges++;
    }
    t2 = get_time();
    
    printf("Total Path: %d\n\n", total_path);
    
    printf("Total Time: %.2f secs\n", (t2 - t1));
    printf("%12s%.2f milli secs\n", "", (t2 - t1) * 1e3);
    printf("%12s%.2f micro secs\n", "", (t2 - t1) * 1e6);
    
    return 0;
}

double get_time() {
    struct timeval t;
    double sec, msec;
    
    while (gettimeofday(&t, NULL) != 0);
    sec = t.tv_sec;
    msec = t.tv_usec;
    
    sec = sec + msec/1000000.0;
    
    return sec;
}

void initialise_graph(int* graph, std::mt19937& rand_gen) {
    for (int i = 0; i < NODES; i++) {
        for (int j = 0; j < NODES; j++) {
            int cell = i * NODES + j;
            int temp = 0;
            
            if ((i == j) || (rand_gen() % 2)) {
                graph[cell] = 0;
                graph[j * NODES + i] = 0;
            } else {
                temp = rand_gen() % MAX_DIST + 1;
                graph[j * NODES + i] = temp;
                graph[cell] = temp;
            }
        }
    }
}

void print_graph(int* graph) {
    for (int i = 0; i < NODES; i++) {
        for (int j = 0; j < NODES; j++) {
            int cell = i * NODES + j;
            printf("%5d", graph[cell]);
            if (j != NODES - 1) {
                printf(", ");
            }
        }
        printf("\n");
    }
    printf("\n");
}

