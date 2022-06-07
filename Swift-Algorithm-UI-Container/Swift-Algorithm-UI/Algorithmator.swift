//
//  Algorithmator.swift
//  Swift-Algorithm-UI
//
//  Created by Ethan Hess on 1/18/21.
//

//MARK: Implements algorithms with input, output is time / space complexity

import Foundation
import UIKit

//MARK: TODO If any of these were originally written by someone else, credit them with a GitHub link etc.

//MARK: While most of these are my own work (mostly from LeetCode) I did use some tutorials from www.raywenderlich.com to help with some of the sorting algorithms and credited them accordingly. If I've forgetten to credit someone please let me know.

//MARK: TODO Organize by data structure type (tree, strings, arrays etc.)

class Algorithmator: NSObject {
    
    //Matrix of 1's (MAX)
    
    //MARK: Not working yet, fix this

    //MARK Both space and time would be O(n * m) // rows * col
    static func maximalSquare(_ matrix: [[Character]]) -> Int {
        var cache : [[Int]]  = [[]]
        var result = 0
        
        //Iterate through Matrix (all the arrays)
        for i in 0...matrix.count - 1 {
            for j in 0...matrix[i].count - 1 {
                if i == 0 || j == 0 {
                    // Do something here?
                } else if matrix[i][j].wholeNumberValue! > 0 {
                    // Storing / cloning in our matrix property
                    let firstCompare = cache[i][j-1]
                    let secondCompare = cache[i-1][j]
                    let thirdCompare = cache[i-1][j-1]
                    let arrToCompare = [firstCompare, secondCompare, thirdCompare]
                    let theMin = arrToCompare.min()
                    if let minVal = theMin {
                        cache[i][j] = 1 + minVal
                    } else {
                        print("No min") // what to do?
                    }
                } else if cache[i][j] > result {
                    result = cache[i][j]
                }
            }
        }
        
        return result
    }
    
    //Can add init / shared instance if we want state, class / static functions are thrown on the stack w/o state
    
    static func asteroidCollision(_ asteroids: [Int]) -> [Int] {
        if asteroids.count < 2 || asteroids.count > 1000 {
            return []
        }
        
        //Note: If asteroid is 0 or is greater than 1k or less than -1k remove from array (or discard), is invalid
        //Turn negative into positive with abs()
        
        var storageArray : [Int] = []

        for i in 0...asteroids.count - 1 {
            if storageArray.isEmpty || asteroids[i] > 0 {
                storageArray.append(asteroids[i])
            } else {
                while true {
                    let lastRoid = storageArray.last!
                    if lastRoid < 0 {
                        storageArray.append(asteroids[i])
                        break
                    } else if lastRoid == -asteroids[i] {
                        storageArray.removeLast()
                        break
                    } else if lastRoid > -asteroids[i] {
                        break
                    } else {
                        storageArray.removeLast()
                        if storageArray.isEmpty {
                            storageArray.append(asteroids[i])
                            break
                        }
                    }
                }
            }
        }
        
        return storageArray.reversed()
    }
    
    //MARK: Recursion
    static func recurSubviewsOfView(theView: UIView) {
        if theView.subviews.count == 0 {
            //TODO set up logging class
            return
        }
        for subview in theView.subviews {
            print("--- VIEW DESC. --- \(theView.description)")
            recurSubviewsOfView(theView: subview)
        }
    }
    
    //MARK: Buildings facing the sea
    static func buildingsFacingTheSea(buildingArray: [Int]) -> Int {
        if buildingArray.count == 0 {
            return 0
        }
        var returnCount = 1
        var curMax = buildingArray[0]
        
        //Start at second index (1)
        for i in 1...buildingArray.count - 1 {
            if buildingArray[i] > curMax {
                curMax = buildingArray[i]
                returnCount += 1
            }
        }
        return returnCount
    }
    
    //MARK: Sorting
    //-- MERGE SORT --
    
    //TODO make some Swift changes via this
    //https://www.raywenderlich.com/741-swift-algorithm-club-swift-merge-sort
    
    static func mergeSort(array: [Int]) -> [Int] {
        if array.count == 0 {
            return []
        }
        guard array.count > 1 else { return array }
        
        let midPoint = array.count / 2 //what happens even / odd?
        let leftArray = Array(array[0..<midPoint]) //Is like "subarrayWithRange"
        let rightArray = Array(array[midPoint..<array.count - midPoint])
        
        let returnArray = mergeArraysWithLeft(left: mergeSort(array: leftArray), right: mergeSort(array: rightArray))
        return returnArray
    }
    
    static func mergeArraysWithLeft(left: [Int], right: [Int]) -> [Int] {
        var returnArray : [Int] = []
        var i = 0
        var j = 0
        //Both indices are less than their corresponding arrays
        while i < left.count && j < right.count {
            let leftVal = left[i]
            let rightVal = right[j]
            if leftVal < rightVal {
                returnArray.append(left[i])
                i += 1
            } else {
                returnArray.append(right[j])
                j += 1
            }
        }
        
        while i < left.count {
            returnArray.append(left[i])
            i += 1
        }
        while j < right.count {
            returnArray.append(right[j])
            j += 1
        }
        
        return returnArray
    }
    
    //-- QUICKSORT --
    
    //TODO update, doesn't currently work
    //https://www.raywenderlich.com/books/data-structures-algorithms-in-swift/v3.0/chapters/34-quicksort
    
    static func quickSortWithArray(array: [Int]) -> [Int] {
        if array.count == 0 {
            return []
        }
        
        guard array.count > 1 else { return array }
        let pivot = array.count / 2
        
        var smaller : [Int] = []
        var larger : [Int] = []
        var pivotArray : [Int] = []
        
        pivotArray.append(pivot)
        
        for i in 0...array.count - 1 {
            let num = array[i]
            if num < pivot {
                smaller.append(num)
            } else if num > pivot {
                larger.append(pivot)
            } else if (i != array.count / 2) && pivot == num {
                pivotArray.append(num)
            }
        }
        
        var returnArray : [Int] = []
        
        //Recur
        returnArray.append(contentsOf: quickSortWithArray(array: smaller))
        returnArray.append(contentsOf: pivotArray)
        returnArray.append(contentsOf: quickSortWithArray(array: larger))
        
        return returnArray
    }
    
    //-- PEAK FINDER --
    //Left and right are columns? Rename?
    static func findPeak(matrix: [[Int]], left: inout Int, right: inout Int) -> Int {
        if matrix.count == 0 {
            return 0
        }
        
        //inout?
        if right == -1 {
            right = matrix[0].count
        }
        
        let j = (left + right) / 2;
        let globalMax = findGlobalMaxPeak(matrix: matrix, column: j)
        
        let firstCondition = globalMax - 1 > 0 && matrix[globalMax][j] >= matrix[globalMax - 1][j]
        let secondCondition = globalMax + 1 < matrix.count && matrix[globalMax][j] >= matrix[globalMax + 1][j]
        let thirdCondition = j - 1 > 0 && matrix[globalMax][j] >= matrix[globalMax][j - 1]
        let fourthCondition = j + 1 < matrix[globalMax].count && matrix[globalMax][j] >= matrix[globalMax][j + 1]
        
        if firstCondition == true && secondCondition == true && thirdCondition && fourthCondition == true {
            return matrix[globalMax][j]
        }
        
        let fifthCondition = j > 0 && matrix[globalMax][j - 1] > matrix[globalMax][j]
        let sixthCondition = j + 1 < matrix[globalMax].count && matrix[globalMax][j + 1] > matrix[globalMax][j]
        
        if fifthCondition == true {
            right = j
            return findPeak(matrix: matrix, left: &left, right: &right)
        }
        if sixthCondition == true {
            left = j
            return findPeak(matrix: matrix, left: &left, right: &right)
        }
        
        return matrix[globalMax][j]
    }
    
    
    //Find Peak Auxiliary
    static func findGlobalMaxPeak(matrix: [[Int]], column: Int) -> Int {
        var max = 0
        var index = 0
        
        for i in 0...matrix.count - 1 {
            if max < matrix[i][column] {
                max = matrix[i][column]
                index = i
            }
        }
        return index
    }
    
    //MARK: Updating observer from Algorithm implementation class
    static func postNotifcationWithVal<T>(val: T) {
        NotificationCenter.default.post(name: Notification.Name(kNotificationNameAlgorithmDataUpdated), object: T.self)
    }
    
    //MARK: Ray Wenderlich QS + MS, just for some variation
    //https://www.raywenderlich.com/741-swift-algorithm-club-swift-merge-sort
    
    //TODO <T: Comparable>: i.e. generic, this handles ints as is
    
    //Does this work correctly?
    static func mergeSortRW(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        let middleIndex = array.count / 2
        let leftArray = Array(array[0..<middleIndex])
        let rightArray = Array(array[middleIndex..<array.count])
        
        return mergeRW(leftArray, rightArray)
    }
    
    static func mergeRW(_ left: [Int], _ right: [Int]) -> [Int] {
        var leftIndex = 0
        var rightIndex = 0

        var orderedArray: [Int] = []
        while leftIndex < left.count && rightIndex < right.count {
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]

            if leftElement < rightElement {
                orderedArray.append(leftElement)
                leftIndex += 1
            } else if leftElement > rightElement {
                orderedArray.append(rightElement)
                rightIndex += 1
            } else {
                orderedArray.append(leftElement)
                leftIndex += 1
                orderedArray.append(rightElement)
                rightIndex += 1
            }
        }

        while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
        }

        while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
        }
        
        return orderedArray
    }

    
    //https://www.raywenderlich.com/books/data-structures-algorithms-in-swift/v3.0/chapters/34-quicksort#toc-chapter-037-anchor-001
    static func quicksortRW<T: Comparable>(_ a: [T]) -> [T] {
        guard a.count > 1 else {
            return a
        }
        let pivot = a[a.count / 2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }
        return quicksortRW(less) + equal + quicksortRW(greater)
    }
    
    
    //MARK: Search 2D Array (Matrix, sorted) for a value
    
    static func searchMatrixForValue(matrix: [[Int]], target: Int) -> Bool {
        if matrix.count == 0 { return false } //What if 1 count?
        
        let rows = matrix.count
        let columns = matrix[0].count
        
        var left = 0
        var right = rows * columns - 1
        
        while left <= right {
            let midpointIndex = left + (right-left) / 2
            let midpointElement = matrix[midpointIndex/columns][midpointIndex%columns]
            if midpointElement == target {
                return true
            } else if target < midpointElement {
                right = midpointIndex - 1
            } else {
                left = midpointIndex + 1
            }
        }
        
        //If never found, return false
        
        return false
    }
    
    //MARK: --- NEW STUFF ---
    
    //MARK: From playground (Peaks is duplicate / updated, replace)
    
    //MARK: --- :) :) :) ---
    
    
    //Questions
    //Do the indices have to be contiguous? (Answer: NO)
    //If the first index == target, what to do?

    //O(n2) time complexity (says nothing about space)

    //MARK: Two sum

    //Input (move to main VC)
    
    //let arr = [2,7,11,15]
    //let target = 9
//   let arr = [3,2,4]
//   let target = 6
    
    static func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        if nums.count < 2 {
            return []
        }
        var returnArray : [Int] = []
        
        //Compare first index with all others then move up if no match
        
        //Brute force, nested for loop is O(n2), this could be more efficient though
        for i in 0...nums.count - 1 {
            for j in 0...nums.count - 1 {
                if nums[i] + nums[j] == target && i != j {
                    print("i \(i) j \(j)")
                    if returnArray.count == 0 {
                        returnArray.append(i)
                        returnArray.append(j)
                        print("Return array \(returnArray)")
                    }
                }
            }
        }
        
        //More efficient?

        return returnArray
    }

    //Input myAtoi("897 Hey")
    
    //MARK: atoi
    static func myAtoi(_ s: String) -> Int {
        
        //do we need operator var here?
        var returnInt = 0
        var doubleWhiteSpace = true
        var isOperator = false // plus / minus
        var finalResultOperand = 1 // result could be positive or negative
        
        for char in s {
            if char.isNumber == true {
                doubleWhiteSpace = false
                isOperator = true //Update: in this case could also be operator or number
                
                returnInt = returnInt * 10 + char.toNumber()
                
                //Upper bounds
                if finalResultOperand > 0 && returnInt > Int(Int32.max) {
                    return Int(Int32.max)
                }
                
                //Lower
                if finalResultOperand < 0 && returnInt * finalResultOperand < Int(Int32.min) {
                    return Int(Int32.min)
                }

            } else {
                if char.isWhitespace == true {
                    if doubleWhiteSpace == true {
                        continue
                    } else {
                        break
                    }
                }
                doubleWhiteSpace = false
                
                if isOperator == true {
                    break
                }
                if char.isPlusOrMinus() == true {
                    finalResultOperand = char == "-" ? -1 : 1
                    isOperator = true
                } else {
                    break
                }
            }
        }
        
        return returnInt * finalResultOperand
    }

    //MARK: search insert
    // O(log n)
    // A Logarithm is the inverse of exponentiation (i.e. good / easier every step)
    
    //searchInsert([1,3,5,6], 7)
    
    static func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        if nums.count == 0 {
            return 0
        }
        if nums.count == 1 && nums[0] == target {
            return 0
        }
        
        //MARK: TODO return the index where if would be if inserted in order
        
        //In first iteration, if target is not found, store index of number that's closest to target but still less than, account for position zero if need to insert zero
        
        var firstIndexGreater = 0
        var notFound = false
        
        for i in 0...nums.count - 1 {
            if nums[i] == target {
                return i
            } else {
                if nums[i] > target {
                    firstIndexGreater = i
                    break
                } else {
                    //Should put at end
                    if i == nums.count - 1 {
                        notFound = true
                    }
                }
            }
        }
        
        //If compiler reaches here target doesn't exist, find where it would be (numbers will be in order)

        return notFound == false ? firstIndexGreater : nums.count
    }

    //MARK: rotate matrix

    //Input

    //[[1,2,3],
    // [4,5,6],
    // [7,8,9]]

    //Result (not output because function doesn't return anything, modify parameter inside function)

    //[[7,4,1],
    // [8,5,2],
    // [9,6,3]]

    //NOTES:

    //First index of first array will always go to last index of first array
    //Second index of first array will always go to last index of second array
    //Third index of first array will always go to last index of third array and so on

    //Middle (i.e. 5 in this case) will always stay the same

    //First index of last array will always go to first of first array
    //Second index of last array will always go to first of second array
    //Third index of last array will always go to first of third array and so on

    //First index of middle array

    //MARK: Needs to be N x N, meaning rows / columns are same count
    static func rotate(_ matrix: inout [[Int]]) {
        if matrix.count == 0 {
            return
        }
        
        //Transpose (i.e. turn rows into columns)
        let n = matrix.count; //count of (sub) arrays in matrix
        
        //Iterate through all arrays in matrix
        for i in 0...n - 1 {
            for j in 0...i {
                let tempValue = matrix[i][j]
                matrix[i][j] = matrix[j][i]
                matrix[j][i] = tempValue
            }
        }
        
        for i in 0...n - 1 {
            for j in 0...(n / 2) - 1 {
                let tempValue = matrix[i][j]
                matrix[i][j] = matrix[i][n - j - 1]
                matrix[i][n - j - 1] = tempValue
            }
        }
        
        print("ROTATED MATRIX \(matrix)")
    }

    //MARK: Range sum of Binary Search Tree

    //MARK: This does not work yet, FIX!

    //Given the root node of a binary search tree and two integers low and high, return the sum of values of all nodes with a value in the inclusive range [low, high].

    static func rangeSumBST(_ root: TreeNode?, _ low: Int, _ high: Int) -> Int {
        //MARK: Logic
        //Brute force: Traverse tree, check if each node is within range, note that left child will be less and right more, so no need to continue in that direction if not
        if root == nil {
            return 0
        }
        var result = 0
        
        //TODO logic
        //Time complexity =
        //Space complexity =
        
        if withinRange(root, low, high) == true {
            result += root!.val
        }
        
        if root!.val < high {
            result += rangeSumBST(root?.right, low, high)
        }
        
        if root!.val > low {
            result += rangeSumBST(root?.left, low, high)
        }
        

        return result
    }

    static func withinRange(_ node: TreeNode?, _ low: Int, _ high: Int) -> Bool {
        guard let theNode = node else {
            return false
        }
        return theNode.val > low && theNode.val < high
    }

    //MARK: Example

    //[10,5,15,3,7,null,18]

    //MARK: Looks like:

    //      10
    //     /  \
    //    5   15
    //   / \    \
    //  3   7    10

    //MARK: Would output:

    //32, because nodes 7, 10, and 15 are in the range [7, 15]. 7 + 10 + 15 = 32
    
    
    
    //MARK: Palindrome

    //Big O:
    
    //TODO make faster, space complexity is good but time complexity is bad, should be the opposite


    static func isPalindrome(_ word: String) -> Bool {
        if word.count == 1 {
            return true
        }
        //Factor in other conditions?
        
        let newString = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let newStringOnlyLetters = newString.filter( { $0.isLetter == true || $0.isNumber == true } )
        
        print("NSOL \(newStringOnlyLetters.lowercased())")
        
        //Loop from both ends inward and compare characters
        let array = Array(newStringOnlyLetters.lowercased())
        
        //Was only non-letters
        if array.count == 0 || array.count == 1 {
            return true
        }
        
        let isEvenCount = array.count % 2 == 0
        
        for i in 0...array.count - 1 {
            let upperBoundsMiddle = isEvenCount == true ? array.count / 2 : array.count == 3 ? 1 : (array.count / 2) - 1
            print("UBM \(upperBoundsMiddle)")
            if i < upperBoundsMiddle {
                print("I \(i)")
                print("IAC \((array.count - 1) - i)")
                if array[i] != array[(array.count - 1) - i] {
                    print("False hit --- left char:\(array[i]) right char:\(array[array.count - 1])")
                    return false
                }
            }
        }
        
        return true
    }

//    isPalindrome("racecar")
//    isPalindrome("hello")
//
//    //TODO remove spaces / chars
//    //"A man, a plan, a canal: Panama"
//
//    isPalindrome("A man, a plan, a canal: Panama")
//    isPalindrome(".,") //NOTE: this should return true
//    isPalindrome("0P")
//    isPalindrome("abb")


    //TODO highest peak problem + Space and Time comp.

    // [[10,8,10,10],[14,13,12,11],[15,9,11,11],[15,9,11,21],[16,17,19,20]]

    static func peakFinder(_ matrix: [[Int]], _ left: inout Int, _ right: inout Int) -> Int {
        if matrix.count == 0 {
            return 0
        }
        
        //Putting right pointer (defaulting to -1) at the end of the first row
        if right == -1 {
            let firstArray = matrix[0]
            right = firstArray.count
        }
        
        //j will be middle of first array
        let j = (left + right) / 2
        let globalMax = findGlobalMax(matrix, j) //index of matrix where highest point is (in column)
        
        //array where global max is (after vertical column traversal)
        let gmArray = matrix[globalMax]
        
        //globalMax - 1 > 0 will check if array is first, cannot traverse backwards if it's the top one
        
        let gmIsNotFirst = globalMax - 1 > 0
        let isGreaterThanPreviousArrAtColumn = gmIsNotFirst && matrix[globalMax][j] > matrix[globalMax - 1][j] //second clause compares same column with previous array in the matrix
        
        let gmIsNotLast = globalMax + 1 < matrix.count
        let isGreaterThanNextArrAtColum = gmIsNotLast && matrix[globalMax][j] >= matrix[globalMax + 1][j]
        
        let notAtLeftEdge = j - 1 > 0
        let notAtRightEdge = j + 1 < gmArray.count
        
        let jGreaterThanLeft = notAtLeftEdge && matrix[globalMax][j] >= matrix[globalMax][j - 1]
        let jGreaterThanRight = notAtRightEdge && matrix[globalMax][j] >= matrix[globalMax][j + 1]
        
        if isGreaterThanPreviousArrAtColumn == true && isGreaterThanNextArrAtColum == true && jGreaterThanLeft == true && jGreaterThanRight == true {
            return matrix[globalMax][j]
        }
        
        let jGreaterThanRightMiddle = j > 0 && matrix[globalMax][j - 1] > matrix[globalMax][j]
        let jGreaterThanLeftMiddle = j + 1 < gmArray.count && matrix[globalMax][j + 1] > matrix[globalMax][j]
        
        if jGreaterThanRightMiddle == true {
            right = j
            return peakFinder(matrix, &left, &right)
        }
        
        if jGreaterThanLeftMiddle == true {
            left = j
            return peakFinder(matrix, &left, &right)
        }
        
        //MARK: Just a placeholder
        return matrix[globalMax][j]
    }

    //Being passed the matrix from main function as well as the current column (j in this case, which starts in the middle of the first array)
    static func findGlobalMax(_ matrix: [[Int]], _ column: Int) -> Int {
        var max = 0
        var index = 0
        
        for i in 0...matrix.count - 1 { //iterating through subarrays
            let currentMatrixNumber : Int = matrix[i][column] //subarray at index, then column
            if max < currentMatrixNumber {
                max = currentMatrixNumber
                index = i
                print("MAX \(max) INDEX \(index)")
            }
        }
        
        return index
    }

//    var left = 0
//    var right = -1

    // peakFinder(matrix, &left, &right)


    //MARK: TODO Facebook problem "fe" "fbe" palindrome (check drafts from July)


    

}

