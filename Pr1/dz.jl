
function gcd_(a::T, b::T) where T 
    while !iszero(b)
        a, b = b, rem(a,b) 
    end
    return abs(a)
end

function isnegative(a::Integer)
    return a<0
end

function gcdx_(a::T, b::T) where T
    u, v = one(T), zero(T) 
    u_, v_ = v, u
    while !iszero(b) 
        k,r = divrem(a,b)
        a, b = b, r 
        u, u_ = u_, u-k*u_
        v, v_ = v_, v-k*v_
    end
    if isnegative(a) 
        a, u, v = -a, -u, -v
    end
    return a, u, v 
end

function invmod_(a::T, M::T) where T
    if(gdc_(a,m) != 1)
        return nothing
    end
return gcdx_(a, M)[2]
end

function diaphant_solve(a::T,b::T,c::T) where T

    if(a==b)
        print("nothing")
        return nothing
    end
    if(rem(c, gcd_(a,b)) != 0)
        print("c не делится на НОД(a,b) nothing")
        return nothing
    end
    
    g,x,y = gcdx_(a,b)
    print(string(g," = g\n"))
    print(string(x," = x\n"))
    print(string(y," = y\n"))
    if(g==1)
        print("g=1")
        return [x,y]
    
    end 
    return [(x*(c/g)), (y*(c/g))]
end


mutable struct Residue{T,M}
    a::T
    m::M
    Residue{T,M}(a,m) where{T,M} = new(mod(a,m),m)
end

import Base: +, -, *, ^, display

function +(a::Residue, b::Integer)
    return mod((a.a + b), a.m)
end

function -(a::Residue, b::Integer)
    return mod((a.a - b), a.m)
end

function *(a::Residue, b::Integer)
    return mod((a.a * b), a.m)
end

function +(a::Residue)
    return invmod_(a,m)
end

function *(a::Residue, b::Integer)
    return mod((a.a ^ b), a.m)
end

function inverse(a::Residue)
    return -a
end
function display(a::Residue)
    print(a.a)
     print(" mod(") 
     print(a.m) 
     print(")")
end

struct Polynom
    coefficients::Vector{T}
end