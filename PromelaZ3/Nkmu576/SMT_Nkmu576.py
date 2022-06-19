from z3 import And, Not, Xor, BoolSort, Or, sat
from z3 import Solver, Consts

#Functional Specification of the majority voter system
def functional(Y, a, b, c, s):
    s.add(Y == Or(And(Not(a), b, c),
                  And(a, Not(b), c),
                  And(a, b, Not(c)),
                  And(a, b, c)))

#Proposed Implementation of the majority voter system
def implementation(YPrime, a, b, c, s):
    s.add(YPrime == Or(And(a, b), 
                       And(b, c), 
                       And(a, c)))


def main():
    ##Constants for all inputs and outputs
    A, B, C = Consts('A, B, C', BoolSort())
    Y, YPrime = Consts('Y, YPrime', BoolSort())
    #Solver
    s = Solver()

    #Running Functional specification function
    functional(Y, A, B, C, s)
    #Running Proposed Implementation function
    implementation(YPrime, A, B, C, s)

    #Using an XOR to find any difference between the outputs of the spec and implementation
    s.add(Xor(Y, YPrime))

    #If there is any difference in the XOR function, then the if statement is true, meaning the
    #outputs were different. Else, there was no differences and the two are equivalent circuits
    if s.check() == sat:
        print('Circuits not equivalent')
        print(s.model())
    else:
        print('Circuits are equivalent')


if __name__ == '__main__':
    main()
