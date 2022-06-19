
#include <CL/sycl.hpp>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <oneapi/dpl/random>

using namespace std;
using namespace sycl;


int maxVal = 0xFFF;

constexpr int nodes = 1024;

constexpr int M = nodes;
constexpr int N = nodes;

int * APD(queue Q, int *Graph, int range) {

    int fullrange = range * range;

    //MALLOC HOST MATRICES
   int *ZMatrixHost = malloc_host<int>(fullrange, Q);
   int *AMatrixHost = malloc_host<int>(fullrange, Q);
   int *BMatrixHost = malloc_host<int>(fullrange, Q);
   int *XMatrixHost = malloc_host<int>(fullrange, Q);
   int *DegreeVectorHost = malloc_host<int>(range, Q);
   int *DMatrixHost = malloc_host<int>(fullrange, Q);

   memcpy(AMatrixHost, Graph, fullrange * sizeof(int));

    //Z matrix mutiplication
    try {
        Q.submit([&](auto &h) {
            //nd_item<1> item
            h.parallel_for(sycl::range(M,N), [=](auto index) 
            {
            int row = index[0];

            int col = index[1];

            int sum = 0;

            for (int i = 0; i < range; i++) {
                sum += AMatrixHost[row * range + i] * AMatrixHost[i * range + col];
            }

            ZMatrixHost[row * range + col] = sum;

            });
        });

        Q.wait();

    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }


    //Create B Matrix
    try {
        Q.submit([&](auto &h) {

            h.parallel_for(sycl::range(M,N), [=](auto index) 
            {
                int row = index[0];
                int col = index[1];

                if (row != col) {

                    if (AMatrixHost[row * range + col] == 1 || ZMatrixHost[row * range + col] > 0) {
                        BMatrixHost[row * range + col] = 1;
                    } else {
                        BMatrixHost[row * range + col] = 0;
                    }

                } else {
                    BMatrixHost[row * range + col] = 0;
                }
            });
        });

    Q.wait();
    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }

    bool *noZero = malloc_shared<bool>(1, Q);
    noZero[0] = true;

    try {
        Q.submit([&](auto &h) {
            h.parallel_for(sycl::range(M,N), [=](auto index)   
            {
                int row = index[0];
                int col = index[1];
                if (row != col && BMatrixHost[row * range + col] == 0) {
                    noZero[0] = false;
                }
            });
        });

    Q.wait();

    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }

    //FREE Z
    free(ZMatrixHost,Q);

    //Create T
    int *TMatrixHost = malloc_shared<int>(fullrange, Q);

    if (noZero[0] == false) {
        //Recursion

        TMatrixHost = APD(Q,BMatrixHost, range);
    } else {
        //Create T
            try {
                    Q.submit([&](auto &h) {
                        h.parallel_for(sycl::range(M,N), [=](auto index) 
                        {
                        int row = index[0];
                        int col = index[1];
                        TMatrixHost[row * range + col] = 2 * BMatrixHost[row * range + col] - AMatrixHost[row * range + col];
                        });
                    });

                    Q.wait();


            } catch (std::exception const &e) {
                cout << "An exception is caught while computing on device.\n";
                terminate();
        }

        free(XMatrixHost,Q);
        free(DegreeVectorHost,Q);
        free(AMatrixHost,Q);
        free(BMatrixHost,Q);

        return TMatrixHost;
    }

    try {
        Q.submit([&](auto &h) {
            h.parallel_for(sycl::range(M,N), [=](auto index) 
            {
                int row = index[0];
                int col = index[1];
                int sum = 0;

                for (int i = 0; i < range; i++) {
                    sum += TMatrixHost[row * range + i] * AMatrixHost[i * range + col];
                }

                XMatrixHost[row * range + col] = sum;
            });
        });
        Q.wait();

    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }
    std::cout << "XMATRIX" << "\n";

    try {
        Q.submit([&](auto &h) {
            h.parallel_for(sycl::range(M,N), [=](auto index) 
            {
                int row = index[0];
                int col = index[1];
                DegreeVectorHost[row] += AMatrixHost[row * range + col];
            });
        });
        Q.wait();
    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }
    std::cout << "Finished Degree" << "\n";

    try {

        Q.submit([&](auto &h) {

            h.parallel_for(sycl::range(M,N), [=](auto index) 
            {
                int row = index[0];
                int col = index[1];

            if (XMatrixHost[row * range + col] >= TMatrixHost[row * range + col] * DegreeVectorHost[col]) {
                DMatrixHost[row * range + col] = 2 * TMatrixHost[row * range + col];

            } else {
                DMatrixHost[row * range + col] = 2 * TMatrixHost[row * range + col] - 1;
            }

            });
        });

        Q.wait();

    } catch (std::exception const &e) {
        cout << "An exception is caught while computing on device.\n";
        terminate();
    }
    //Free ALL
    free(TMatrixHost,Q);
    free(XMatrixHost,Q);
    free(DegreeVectorHost,Q);
    free(AMatrixHost,Q);
    free(BMatrixHost,Q);
    std::cout << "Final return" << "\n";
    return DMatrixHost; 
}

int main() {

    int range = nodes;
    int fullrange = range * range;
    int graph[range * range];
    queue q(default_selector{});

    for (int i = 0; i < range; i++) {

        for (int j = 0; j < range; j++) {
           int cell = i * range + j;

            if (i == j) {
                graph[cell] = 0;
                
            }
            else if (!(rand() % 45)) {
                graph[cell] = 1;
                graph[j*range + i] = 1;
            }
            else {
                graph[cell] = 0;
                graph[j*range + i] = 0;
            }

        }
    }

    std::cout << "\n";

    int *FinalGraph = malloc_shared<int>(fullrange, q);

    auto begin = chrono::high_resolution_clock::now();

    FinalGraph = APD(q,graph, range);

    auto end = chrono::high_resolution_clock::now();
    auto dur = end - begin;
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(dur).count();
   

    std::cout << "\n";

    std::cout << "Finished main" << "\n";

     std::cout << "Naive Parallel Seidel took " << ms << " milliseconds to run." << std::endl;
    
    

    return 0;

}