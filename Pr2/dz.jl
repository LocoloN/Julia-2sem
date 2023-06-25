function QuickPow(value, pow::T) where T<:Integer
    result = 1
    z = value
    temp = (pow < 0) ? (-1) : (1)
    pow *= temp
    while(pow > 0)
        if (mod(pow,2) == 1)
            result = result * z
            z = z * z
            pow = (pow - 1)/2
        else
            z = z * z
            pow /= 2
        end

    end
    if(typeof(value) <: Integer)
        (temp == 1) ? (return result) : (return 1/result)
    else
        (temp == 1) ? (return result) : (return result^(-1))
    end
end

function FibMat(n)
    m = [1 1; 1 0]
    m = QuickPow(m,n)
    return m[1,1]
end

function log(a0, x, epsilon)
    a = a0; flag  = false
    if a < 1.0
        a = 1.0 / a
        flag = true
    end
    y = 0.0; z = x; t = 1.0;
    while abs(t) > epsilon || z < 1.0 / a || z > a
        # инвариант a^y * z^t == x
        if z > a
            z /= a
            y += t
        elseif  z < 1.0 / a
            z *= a
            y -= t
        else
            z *= z
            t /= 2.0
        end
    end

    return (flag) ? -y : y
end

function f(x)
    return x * x - 3 * x
end

function bisection(f::Function, a, b, epsilon)
    f_a = f(a)
    while (b - a > epsilon)
        t = (a + b)/2
        f_t = f(t)
        if (f_t == 0)
            return t
        elseif (f_t * f_a < 0)
            b = t
        else
            a, f_a = t, f_t
        end
    end
    return (a+b) / 2
end

#Бинарный поиск
function binary_solution(f::Function, a, b, epsilon)
    x0 = a; x1 = b; 
    @assert f(x0) * f(x1) <= 0
    while abs(x0 - x1) > epsilon
        c = (x0 + x1) / 2   # Середина отрезка
        if f(x0) * f(c) < 0
            x1 = c
        else
            @assert f(c) * f(x1) <= 0
            x0 = c
        end
    end
    return (x0 + x1) / 2
end

function newton(r::Function, x, epsilon; num_max = 10)
    dx = -r(x)
    k=0
    while abs(dx) > epsilon && k <= num_max
        x += dx
        k += 1
    end
    k > num_max && @warn("Требуемая точность не достигнута")
    return x
end

function MyCos(x)
    return cos(x) - x
end
