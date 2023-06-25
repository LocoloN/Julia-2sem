function insert_sort!(array::AbstractVector{T})::AbstractVector{T} where T <: Number
    n = 1
    # Инвариант: срез array[1:n] - отсортирован

    while n < length(array) 
        n += 1
        i = n

        while i > 1 && array[i-1] > array[i]
            array[i], array[i-1] = array[i-1], array[i]
            i -= 1
        end

        # Утверждение: array[1] <= ... <= array[n]
    end

    return array
end

function rascheska(arr)
    step = length(arr)
    shrink = 1.247
   while step >=1 
        for i in 1:length(arr) - step
            if arr[i] > arr[i+step]
                arr[i], arr[i+step] = arr[i+step], arr[i]
            end
        end
        step = Int(floor(step/shrink))
   end
    return arr
end

arr = [2, 1, 5, 4, 3, 2, 7, 2, 8, 9]

function compare!(arr, i, g)
    if i < 0 || g < 0 
        return;
    end
    if arr[i] > arr[g]
        arr[i], arr[g] = arr[g], arr[i]
        compare!(arr, i, 2i - g)
    end
end

function shell_sort!(arr)
    len = length(arr)   
    step = div(len, 2)          

    while step >= 1
        for i in 1:len - step       
            compare!(arr,i,i + step)
        end
        step = div(step, 2)
    end
    return arr
end

# Сортировка слиянием
function Base.merge!(a1, a2, a3)::Nothing 
    i1, i2, i3 = 1, 1, 1
    @inbounds while i1 <= length(a1) && i2 <= length(a2) 
        if a1[i1] < a2[i2]
            a3[i3] = a1[i1]
            i1 += 1
        else
            a3[i3] = a2[i2]
            i2 += 1
        end
        i3 += 1
    end
    @inbounds if i1 > length(a1)
        a3[i3:end] .= @view(a2[i2:end])  
    else
        a3[i3:end] .= @view(a1[i1:end])
    end
    nothing
end

function merge_sort!(a)
    b = similar(a) # - вспомогательный массив того же размера и типа, что и массив a
    N = length(a)
    n = 1 # n - текущая длина блоков
    @inbounds while n < N
        K = div(N,2n) # - число имеющихся пар блоков длины n
        for k in 0:K-1
            merge!(@view(a[(1:n).+k*2n]), @view(a[(n+1:2n).+k*2n]), @view(b[(1:2n).+k*2n]))
        end
        if N - K*2n > n # - осталось еще смержить блок длины n и более короткий остаток
            merge!(@view(a[(1:n).+K*2n]), @view(a[K*2n+n+1:end]), @view(b[K*2n+1:end]))
        elseif 0 < N - K*2n <= n # - оставшуюся короткую часть мержить не с чем
            b[K*2n+1:end] .= @view(a[K*2n+1:end])
        end
        a, b = b, a
        n *= 2
    end
    if isodd(log2(n)) # - если цикл был выполнен нечетное число раз, то b - это исходная ссылка на массив (на внешний массив), и a - это ссылка на вспомогательный массив (локальный)
        b .= a # b = copy(a) - это было бы не то же самое, т.к. при этом получилась бы ссылка на новый массив, который создает функция copy
        a = b
    end
    return a # - исходная ссылка на внешний массив (проверить, что это так, можно с помощью ===)
end

# Сортировка Хоара
function part_sort!(A, b)
    N = length(A)
    K=0
    L=0
    M=N
    while L < M 
        if A[L+1] == b
            L += 1
        elseif A[L+1] > b
            A[L+1], A[M] = A[M], A[L+1]
            M -= 1
        else 
            L += 1; K += 1
            A[L], A[K] = A[K], A[L]
        end
    end
    return K, M+1 
end

function quick_sort!(A)
    if isempty(A)
        return A
    end
    N = length(A)
    K, M = part_sort!(A, A[rand(1:N)]) 
    quick_sort!(@view A[1:K])
    quick_sort!(@view A[M:N])
    return A
end