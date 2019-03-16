//
//  main.swift
//  ZXSwiftCalculation
//
//  Created by xinying on 2019/3/16.
//  Copyright © 2019年 habav. All rights reserved.
//

import Foundation
print("Hello, World!")

func add(_ num: Int) -> (Int) -> Int {
    return {
        val in
        return num + val
    }
}

let result = (0...10).map { $0 * $0 }.filter { $0 % 2 == 0}

let addTwo = add(2)(3)
let addFour = add(4)
//栈：先进后出
protocol Stack {
    //持有元素类型
    associatedtype Element
    
    var isEmpty: Bool { get }
    var size: Int { get }
    var peek: Element? { get }
    
    mutating func push(_ newElement: Element)
    mutating func pop() -> Element?
}

struct IntegerStack: Stack {
    typealias Element = Int
    
    private var stack = [Element]()
    
    var isEmpty: Bool { return stack.isEmpty }
    var size: Int { return stack.count }
    var peek: Element? { return stack.last }
    //mutating的本质是传入self，并用inout修饰，让函数修改传递过来的self参数
    mutating func push(_ newElement: Int) {
        stack.append(newElement)
    }
    mutating func pop() -> Element? {
        return stack.popLast()
    }
}

//队列：先进先出
//这里队列，跟栈的区别：使用了2个数组来实现, 数组1用来 入队添加元素；
//数组2用来出队 ，如果数组2为空， 将数组1 reversed反转 再赋值给数组2，数组1移除所有元素，数组2出队列
protocol Queue {
    //持有元素类型
    associatedtype Element
    
    var isEmpty: Bool { get }
    var size: Int { get }
    var peek: Element? { get }
    
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
}

//struct IntegerQueue: Queue {
//    typealias Element = Int
//
//    private var left =  [Element]()
//    private var right = [Element]()
//    var isEmpty: Bool {
//        return left.isEmpty && right.isEmpty
//    }
//    var size: Int {return left.count + right.count }
//    var peek: Element? {return left.isEmpty ? right.first : left.last }
//
//    mutating func enqueue(_ newElement: Int) {
//        right.append(newElement)
//    }
//
//    mutating func dequeue() -> Int? {
//        if left.isEmpty {
//            left = right.reversed()
//            right.removeAll()
//        }
//        return left.popLast()
//    }
//}

//栈和队列互换： 使用2个队列 ／栈来实现

//二叉树：求树的深度，即节点的最大层次
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ val: Int) {
        self.val = val
    }
}
func maxDepth(root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }
    return max(maxDepth(root: root.left), maxDepth(root: root.right)) + 1
}

//判断它是二叉查找树
func isValidBST(root: TreeNode?) -> Bool {
    return _helper(root, nil, nil)
}

private func _helper(_ node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
    guard let node = node else {
        return true
    }
    //所有右子树节点的值 都必须大于根结点的值
    if let min = min, node.val <= min {
        return false
    }
    if let max = max, node.val >= max {
        return false
    }
    return _helper(node.left, min, node.val) &&
        _helper(node.right, node.val, max)
}


//用非递归的方式实现 二叉树的遍历：使用栈实现，用数组来实现
//实现 前序遍历
func preorderTraver(root: TreeNode?) ->[Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    
    while !stack.isEmpty || node != nil {
        if node != nil {
            res.append(node!.val)
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast().right
        }
    }
    return res
}

//图的广度优先遍历会用到队列,层级遍历
func levelOrder(root: TreeNode?) -> [[Int]] {
    var res = [[Int]]()
    //用数组来实现队列
    var queue = [TreeNode]()
    if let root = root {
        queue.append(root)
    }
    
    while queue.count > 0 {
        var level = [Int]()
        
        for _ in 0 ..< queue.count {
            let node = queue.removeFirst()
            
            level.append(node.val)
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        res.append(level)
    }
    return res
}


//快排
func quicksort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    let pivot = array[array.count / 2]
    let left = array.filter({ $0 < pivot })
    let middle = array.filter({ $0 == pivot })
    let right = array.filter({ $0 > pivot })
    
    return quicksort(left) + middle + quicksort(right)
}

print(quicksort([2,3,1,323,2]))



