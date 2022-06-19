#include <chrono>
#include <cstdlib>
#include <iostream>
#include <array>
#include <string.h>

using namespace std;

constexpr int nodes = 300;
constexpr int SquareNode = nodes * nodes;


array<int,SquareNode> APD(array<int,SquareNode> graph) {

    array<int,SquareNode> BMatrix;

    array<int,SquareNode> AMatrix;



    AMatrix = graph;
    
    array<int,SquareNode> ZMatrix;

    std::cout << "ZMatrix Calculating " <<"\n";

    //Transpose
    for (int i = 0; i < nodes; i++) {
        for (int j = 0; j < nodes; j++) {
            int sum = 0;
            for (int k=0; k< nodes; k++){
                sum += AMatrix[i * nodes + k] * AMatrix[k * nodes + j];
                ZMatrix[i * nodes + j] = sum;
            }
        }
    }

    for (int i = 0; i < nodes; i++) {
        for (int j = 0; j < nodes; j++) {
            if (i != j) {
                if (AMatrix[i * nodes + j] == 1 || ZMatrix[i * nodes + j] > 0) {
                    BMatrix[i * nodes + j] = 1;
                } else {
                    BMatrix[i * nodes + j] = 0;
                }
            } else {
                BMatrix[i * nodes + j] = 0;
            }
        }
    }


    bool Recur = false;
    bool continueFlow = false;
    
    for (int i = 0; i < nodes; i++) {
        for (int j = 0; j < nodes; j++) {
            if ( (i != j) && (BMatrix[i * nodes + j] == 0) ) {
                    Recur = true;
            }
        }
    }
    array<int,SquareNode> TMatrix;

    if (Recur) {
        std::cout << "Recurring " <<"\n";

        TMatrix = APD(BMatrix);
        continueFlow = true;

    } else {

        std::cout << "Creating DMatrix BASECASE " <<"\n";
        array<int,SquareNode> DMatrix;


         continueFlow = false;

        for (int i = 0; i < nodes; i++) {
            for (int j = 0; j < nodes; j++) { 
                DMatrix[i * nodes +j] = 2 * BMatrix[i * nodes + j] - AMatrix[i * nodes + j];
            }   
        }

        return DMatrix;

    }

    if (continueFlow) {

        array<int,SquareNode> XMatrix;

        for (int i = 0; i < nodes; i++) {
            for (int j = 0; j < nodes; j++) {
                int sum = 0;
                for (int k=0; k< nodes; k++){
                    sum += TMatrix[i * nodes + k] * AMatrix[k * nodes + j];
                    XMatrix[i * nodes + j] = sum;
                }
            }
        }
    
        int DegreeVector[nodes];

        for (int i = 0; i < nodes; i++) {
            for (int j = 0; j < nodes; j++) {
                int sum =0;
                sum += AMatrix[i * nodes + j];
                DegreeVector[i] = sum;
            }
        }

        array<int,SquareNode> DMatrix;

        for (int i = 0; i < nodes; i++) {
            for (int j = 0; j < nodes; j++) {
                if (XMatrix[i * nodes + j] >= (TMatrix[i * nodes + j]) * DegreeVector[j]) {
                    DMatrix[i * nodes + j] = 2 * TMatrix[i * nodes + j];
                } else {
                    DMatrix[i * nodes + j] = 2 * TMatrix[i * nodes + j] - 1;
                }
            }
        }
       return DMatrix;
    }
}



int main() {

    array<int,nodes*nodes> FinalGraph;
    array<int,nodes*nodes> graph;

    for (int i = 0; i < nodes; i++) {
           
        for (int j = 0; j < nodes; j++) {
            if (i == j) {
                graph[i * nodes +j] = 0;
            }
            else if (!(rand() % 2)) { 
                graph[i * nodes + j] = 1;
                graph[j * nodes + i] = 1;
            }
            else {
                graph[i * nodes + j] = 0;
                graph[j * nodes + i] = 0;
            }
          
        }
    }

    std::cout << "\n";

    auto begin = chrono::high_resolution_clock::now();

    FinalGraph  = APD(graph);
    
    auto end = chrono::high_resolution_clock::now();
    auto dur = end - begin;
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(dur).count();
    
    std::cout << "\n Sequential Seidel took " << ms << " milliseconds to run." << std::endl;

    return 0;

}