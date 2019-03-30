//
//  main.swift
//  ZXSwiftCalculation
//
//  Created by xinying on 2019/3/16.
//  Copyright © 2019年 habav. All rights reserved.
//

import Foundation
import NotificationCenter
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

var array = [2,3,1,323,2]
print(quicksort(array))
//sorted 函数采用的是内省算法，由堆排序，插入排序，快排3种算法构成，依据输入的深度选择最佳算法来完成
var newarray = array.sorted()

//二分搜索，nums已经排好序了
func binarySearch(_ nums: [Int], _ target: Int) -> Bool {
    return binarySearch(nums: nums, target: target , left: 0, right: nums.count - 1)
}

func binarySearch(nums: [Int], target: Int, left: Int, right: Int) -> Bool {
    guard left <= right else {
        return false
    }
    let mid = (right - left) / 2 + left
    if nums[mid] == target {
        return true
    } else if nums[mid] < target {
        return binarySearch(nums: nums, target: target, left: mid + 1, right: right)
    } else {
        return binarySearch(nums: nums, target: target, left: left, right: mid - 1)
    }
}

print(binarySearch(array, 323))

//已知有很多会议，这些会议时间有重叠，就将它们合并
//例如，一个会议时间 下午3点到5点， 另一个会议为下午4点到6点，那合并后的会议时间为下午3点到6点
//已知有开始时间和结束时间，需要先对会议数组 比较 开始时间排序，如果开始时间相同，就比较结束时间；
//排好序后，将第一个元素放入结果数组中，
//然后遍历 比较，如果结果数组中最后元素的会议开始时间 大于 排序后的数组中当前的会议结束时间，结果数组就添加当前元素；
//否则，就将结果数组的当前元素结束时间改为这两个元素的最大结束时间。
public class MeetingTime {
    public var start: Int
    public var end: Int
    public init(_ start: Int, _ end: Int) {
        self.start = start
        self.end = end
    }
}

func merge(meetingTimes: [MeetingTime]) -> [MeetingTime] {
    guard meetingTimes.count > 1 else {
        return meetingTimes
    }
    //排序
    var meetingTimes = meetingTimes.sorted {
        if $0.start != $1.start {
            return $0.start < $1.start
        } else {
            return $0.end < $1.end
        }
    }
    
    //新建结果数组
    var res = [MeetingTime]()
    res.append(meetingTimes[0])
    
    //遍历排序后的原数组，与结果数组归并
    for i in 1 ..< meetingTimes.count {
        let last = res[res.count - 1]
        let current = meetingTimes[i]
        if current.start > last.end {
            res.append(current)
        } else {
            last.end = max(last.end, current.end)
        }
    }
    return res
}

//深度优先搜索DFS ，和广度优先搜索BFS：二叉树的前序遍历和层级遍历的本质分别就是这两者
//DFS的实现使用递归，而BFS的实现是利用队列和循环

//动态规划—— 斐波拉契数列问题：
func Fib(_ max: Int) -> Int {
    var (prev, curr) = (0, 1)
    
    for _ in 1 ..< max {
        (curr, prev) = (curr + prev, curr)
    }
    return curr
}

var num = Fib(50)

//struct Beer : Codable {
//    enum CodingKeys : String, CodingKey {
//        case name
//        case abc = "alcohol_by_volumn"
//        case style
//    }
//}
var num2 = 0
DispatchQueue.global().async {
    
    for _ in 1...1000 {
        num2 += 1
    }
    
}
for _ in 1...1000 {
    num2 += 1
}
//
var highPriorityQueue = DispatchQueue.global(qos: .userInitiated)

var lowPriorityQueue = DispatchQueue.global(qos: .utility)

let semaphore = DispatchSemaphore(value: 1)

lowPriorityQueue.async {
    semaphore.wait()
    
    for i in 0...10 {
        
        print(i)
        
    }
    
    semaphore.signal()
    
}

highPriorityQueue.async {
    
    semaphore.wait()
    
    for i in 11...20 {
        
        print(i)
        
    }
    semaphore.signal()
}

@objcMembers class User: NSObject {
    dynamic var email: String
    init(email: String) {
        self.email = email
    }
}
let user = User(email: "com")
//注册观察者，回调中处理收到的更改通知
let observation = user.observe(\.email) { (user, change) in
    print("\(user.email)")
}

//更改主体对象的属性值，触发发送更改的通知
user.email = "com2"

//swift 使用POP 实现二分搜索查找
extension Array where Element: Comparable {
    public var isSorted: Bool {
        var preIdx = startIndex
        var currentIdx = startIndex + 1
        
        while currentIdx != endIndex {
            if self[preIdx] > self[currentIdx] {
                return false
            }
            
            preIdx = currentIdx
            currentIdx += 1
        }
        return true
    }
}

func binarySearch<T: Comparable>(sortedElements: [T], for element: T) -> Bool {
    //
    assert(sortedElements.isSorted)
    
    var lo = 0, hi = sortedElements.count - 1
    while lo <= hi {
        let mid = lo + (hi - lo) / 2
        if sortedElements[mid] == element {
            return true
        } else if sortedElements[mid] < element {
            lo = mid + 1
        } else {
            hi = mid - 1
        }
    }
    return false
}


print()



