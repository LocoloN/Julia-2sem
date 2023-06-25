# Генерация всех размещений с повторениями
function next_repit_plasement!(p::Vector{T}, n::T) where T<:Integer
    i = findlast(x->(x < n), p)
    isnothing(i) && (return nothing)
    p[i] += 1
    p[i+1:end] .= 1 
    return p
end

# Генерация всех перестановок
function next_permutation!(p::AbstractVector)
    n = length(p)
    k = 0 
    for i in reverse(1:n-1) 
        reverse(firstindex(p):lastindex(p)-1)
        if p[i] < p[i+1]
             k=i
             break
         end
    end

    k == firstindex(p)-1 && return nothing 
    i=k+1
    while i<n && p[i+1]>p[k] 
        p[k]
        i += 1
    end

    p[k], p[i] = p[i], p[k]
    reverse!(@view p[k+1:end])
    return p

end

# Генерация всех подмножеств
function next_indicator!(indicator::AbstractVector{Bool})
    i = findlast(x->(x==0), indicator)
    isnothing(i) && return nothing
    indicator[i] = 1
    indicator[i+1:end] .= 0
    return indicator 
end

# Генерация всех k-элементных подмножеств
function next_indicator!(indicator::AbstractVector{Bool}, k)
    @assert(k <= n)
    i = lastindex(indicator)
    while indicator[i] == 0
        i -= 1
    end
    m = 0 
    while i >= firstindex(indicator) && indicator[i] == 1 
        m += 1
        i -= 1
    end
    if i < firstindex(indicator)
        return nothing
    end
    indicator[i] = 1
    indicator[i + 1:end] .= 0
    indicator[lastindex(indicator) - m + 2:end] .= 1
    return indicator 
end

# Генерация всех разбиений натурального числа
function next_split!(s ::AbstractVector{Int64}, k)
    k == 1 && return (nothing, 0)
    i = k-1 
    while i > 1 && s[i-1]>=s[i]
        i -= 1
    end
    s[i] += 1
    r = sum(@view(s[i+1:k]))
    k = i+r-1
    s[(i+1):(length(s)-k)] .= 1
    return s, k
end