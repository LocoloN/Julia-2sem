# Представим вектор как именованный кортеж
using LinearAlgebra

Vector2D{T<:Real} = NamedTuple{(:x, :y), Tuple{T,T}}

# Сложение векторов
Base. +(a::Vector2D{T},b::Vector2D{T}) where T = Vector2D{T}(Tuple(a) .+ Tuple(b))

# Разность векторов
Base. -(a::Vector2D{T}, b::Vector2D{T}) where T = Vector2D{T}(Tuple(a) .- Tuple(b))

# Векторное произведение векторов
Base. *(α::T, a::Vector2D{T}) where T = Vector2D{T}(α.*Tuple(a))

# Длина вектора
LinearAlgebra.norm(a::Vector2D) = norm(Tuple(a))

# Скалярное произведение векторов (a,b)=|a||b|cos(a,b)
LinearAlgebra.dot(a::Vector2D{T}, b::Vector2D{T}) where T = dot(Tuple(a), Tuple(b))

# Косое произведение    (a,b)=|a||b|sin(a,b)
xdot(a::Vector2D{T}, b::Vector2D{T}) where T = a.x*b.y-a.y*b.x

# Синус угла между векторами
Base.sin(a::Vector2D{T}, b::Vector2D{T}) where T = xdot(a,b)/norm(a)/norm(b)

# Косинус угла между векторами
Base. cos(a::Vector2D{T}, b::Vector2D{T}) where T = dot(a,b)/norm(a)/norm(b)

# Угол между векторами
Base.angle(a::Vector2D{T}, b::Vector2D{T}) where T = atan(sin(a,b),cos(a,b))

# Знак угла
Base.sign(a::Vector2D{T}, b::Vector2D{T}) where T = sign(sin(a,b))

# Отрезок 
Segment2D{T<:Real} = NamedTuple{(:A, :B), NTuple{2,Vector2D{T}}}

function is_one(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where T 
    l = s.B-s.A     # Направляющий вектор заданной прямой
    return sin(l, P-s.A)*sin(l,Q-s.A) > 0   # Если угол между (l,AP) и (l,BP) имеют один знак, значит точки с 1 стороны 
end

is_one_area(F::Function, P::Vector2D{T}, Q::Vector2D{T}) where T = (F(P...)*F(Q...)>0)

# Точка пересечения двух отрезков(nothing если не пересекаются)
function intersection(s1::Segment2D{T},s2::Segment2D{T}) where T
    A = [s1.B[2]-s1.A[2]  s1.A[1]-s1.B[1]
         s2.B[2]-s2.A[2]  s2.A[1]-s2.B[1]]

    b = [s1.A[2]*(s1.A[1]-s1.B[1]) + s1.A[1]*(s1.B[2]-s1.A[2])
         s2.A[2]*(s2.A[1]-s2.B[1]) + s2.A[1]*(s2.B[2]-s2.A[2])]

    x,y = A\b   # Случай с определителем матрицы отбросим
    # Если точка не принадлежит какому-либо сегменту, то нет ответа
    if isinner((;x, y), s1)==false || isinner((;x, y), s2)==false   
        return nothing
    end
    return (;x, y) #Vector2D{T}((x,y))
end

# Проверка на то, является ли точка внутренней для сегмента
isinner(P::Vector2D, s::Segment2D) = (s.A.x <= P.x <= s.B.x || s.A.x >= P.x >= s.B.x)  && (s.A.y <= P.y <= s.B.y || s.A.y >= P.y >= s.B.y)

function isinside(point::Vector2D{T},polygon::AbstractArray{Vector2D{T}})::Bool where T
	sum = zero(Float64)

    # Если сумма углов 0 — снаружи. 2π — внутри
	for i in firstindex(polygon):lastindex(polygon)
		sum += angle( polygon[i] - point , polygon[i % lastindex(polygon) + 1] - point )
	end
	
    # Чтобы не было неточностей при сравнении сравним с π(если < то это 0, если больше то 2π)
	return abs(sum) > π
end

function isinside(point::Vector2D{T},polygon::AbstractArray{Vector2D{T}})::Bool where T
	sum = zero(Float64)

    # Если сумма углов 0 — снаружи. 2π — внутри
	for i in firstindex(polygon):lastindex(polygon)
		sum += angle( polygon[i] - point , polygon[i % lastindex(polygon) + 1] - point )
	end
	
    # Чтобы не было неточностей при сравнении сравним с π(если < то это 0, если больше то 2π)
	return abs(sum) > π
end
