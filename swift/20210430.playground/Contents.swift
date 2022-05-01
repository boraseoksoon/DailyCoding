import Foundation

// [algorithm] new way to implement Fibonacci using closure for any iterator and any sequence.

let res4 = Array(
    AnySequence { () -> AnyIterator<Int> in
        var t1 = (0, 1)
        return AnyIterator<Int> {
            let (a, b) = t1
            t1 = (b, a + b)
            return b
        }
    }
    .prefix(10)
)

res4

// [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

// many ways to implement fibonacci

// fibo coding
// 1,1,2,3,5,8...

// (1) normal
// (2) shorter
// (3) dynamic programming
// (4) TCO
// (5) Trampoline

// (1) normal
func fibo1(n: Int) -> Int {
    if n == 1 {
        return 1
    } else if n == 2 {
        return 1
    } else {
        return fibo1(n:n-1) + fibo1(n:n-2)
    }
}

fibo1(n: 7) // 13
    
// (2) shorter
func fibo2(n: Int) -> Int {
    ((n == 1) ? 1 : ((n == 2) ? 1 : (fibo1(n:n-1) + fibo1(n:n-2))))
}

fibo2(n: 7) // 13


// (3) dynamic programming (DP)

typealias FibonacciIndex = Int
var cache: [FibonacciIndex : Int] = [:]

func fibo3(n: Int) -> Int {
    if cache[n] != nil {
        return cache[n]!
    } else {
        if n == 1 {
            let res = 1
            cache[n] = res
            return res
        } else if n == 2 {
            let res = 1
            cache[n] = res
            return res
        } else {
            let res = fibo3(n: n - 1) + fibo3(n: n - 2)
            cache[n] = res
            return res
        }
    }
}

fibo3(n: 10)

// (4) TCO
func fibo4(n: Int, _n: Int = 1, fibos: [Int] = [1]) -> Int {
    if n == _n {
        return fibos.last ?? 0
    } else {
        let newN = _n + 1
        
        var fibos = fibos
        if _n == 1 {
            fibos.append(1)
        } else {
            fibos.append(fibos[_n - 1] + fibos[_n - 2])
        }
        
        return fibo4(n: n, _n:newN, fibos: fibos)
    }
}

//fibo1(n: 90)
// fibo2(n: 90)

// 1 1 2 3 5 8 13 21
// fibo4(n: 90)

fibo5(n: 90)

// (5) Trampoline
enum Result<A, B, C> {
    case done(C)
    case call(A, B, C)
}

func fibo5(n: Int) -> Int {
    func algorithm(_ n: Int, _ a: Int = 1, _ b: Int = 0) -> Result<Int, Int, Int> {
        guard n > 0 else { return .done(b) }
        return .call(n-1, (a + b), a)
    }

    let trampoline = { (_ result: Result<Int, Int, Int>) -> Int in
        var mutResult = result
        
        while true {
            switch mutResult {
                case let .done(r): return r
                case let .call(x, y, z): mutResult = algorithm(x, y, z)
            }
        }
    }
    
    return trampoline(algorithm(n))
}
