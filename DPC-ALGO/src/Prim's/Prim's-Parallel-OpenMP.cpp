#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>
#include <random>
#include <omp.h>

#define NODES 1500
#define MAX_DIST 10000

double get_time();
void initialise_graph(int* graph, std::mt19937& rand_gen);
void print_graph(int* graph);

int main() {
    double t1, t2;
    std::mt19937 rand_gen(0);
    
    int* graph = (int*)malloc(sizeof(int) * NODES * NODES);
    initialise_graph(graph, rand_gen);
    printf("Initialised Graph: %d x %d\n", NODES, NODES);
    if (NODES <= 15) {
        print_graph(graph);
    }
    
    bool mst[NODES];
    memset(mst, false, sizeof(mst));
    
    int node = rand_gen() % NODES; // randomly select starting node
    mst[node] = true; // add node to mst
    printf("Starting Node: %d\n", node);
    
    int total_path = 0;
    int edges = 0;
    
    t1 = get_time();
    while (edges < NODES - 1) {
        int min_path = MAX_DIST + 1;
        
        #pragma omp parallel firstprivate(graph, mst)
        {
            int p_min_path = min_path;
            int p_node = node;
            #pragma omp for
            for (int i = 0; i < NODES; i++) {
                if (mst[i]) {
                    for (int j = 0; j < NODES; j++) {
                        int path = graph[i * NODES + j];
                        
                        if (!mst[j] && path) {
                            if (path < p_min_path) {
                                p_min_path = path;
                                p_node = j;
                            }
                        }
                    }
                }
            }
            #pragma omp critical
            if (p_min_path < min_path) {
                min_path = p_min_path;
                node = p_node;
            }
        }
        
        mst[node] = true; // add node to mst
        total_path += min_path;
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
