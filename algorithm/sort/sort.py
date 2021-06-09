#!/usr/bin/env python3
import copy

def bubble(arr):
    n = 0
    for i in range(1, len(arr)):
        flag = 1
        for j in range(0, len(arr) - i):
            n += 1
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
                flag = 0
        # 如果一趟冒泡没有发生交换，则已经排好序
        if flag == 1:
            return arr,n,"bubble"
    return arr,n,"bubble"

def insertion(arr):
    # 第一个元素作为已排序序列，第二个元素到最后一个元素当成是未排序序列。
    n = 0
    for i in range(1,len(arr)):
        preIndex = i-1
        cur = arr[i]
        while preIndex >=0 and arr[preIndex] > cur:
            n += 1
            arr[preIndex+1] = arr[preIndex]
            preIndex -= 1
        arr[preIndex+1] = cur
        
    return arr,n,"insertion"

def selection(arr):
    n = 0
    for i in range(len(arr) - 1):
        # 记录最小数的索引
        minIndex = i
        for j in range(i + 1, len(arr)):
            n += 1
            if arr[j] < arr[minIndex]:
                minIndex = j
        # i 不是最小数时，将 i 和最小数进行交换
        if i != minIndex:
            arr[i], arr[minIndex] = arr[minIndex], arr[i]
    return arr,n,"selection"

def shell(arr):
    gap=0
    part = 3
    n = 0
    while(gap < len(arr)/part):
        gap = gap*part+1
    while gap > 0:
        for i in range(gap,len(arr)):
            temp = arr[i]
            j = i-gap
            while j >=0 and arr[j] > temp:
                n += 1
                arr[j+gap]=arr[j]
                j-=gap
            arr[j+gap] = temp
            
        gap = int((gap-1)/part)
        
    return arr,n,"shell"


def merge(left,right):
    global count
    result = []
    while left and right:
        count += 1
        if left[0] <= right[0]:
            result.append(left.pop(0))
        else:
            result.append(right.pop(0))
    while left:
        count += 1
        result.append(left.pop(0))
    while right:
        count += 1
        result.append(right.pop(0))
    return result

def mergeSort(arr):
    if(len(arr)<2):
        return arr
    middle = int(len(arr)/2)
    left, right = arr[0:middle], arr[middle:]
    return merge(mergeSort(left), mergeSort(right))
    
if __name__ == '__main__':
    arr = [5,1,4,2,3,15,22,37,99,22,23,21,9,8,6,2,7,111,233,90,87,67,98,766,877,234,432,45,67,33,48,49,50,67,901]
    print(len(arr))
    print(bubble(copy.deepcopy(arr)))
    print(insertion(copy.deepcopy(arr)))
    print(selection(copy.deepcopy(arr)))
    print(shell(copy.deepcopy(arr)))
    count = 0
    print(mergeSort(copy.deepcopy(arr)),count,"mergeSort")
    print(insertion([5,4,3,2,1]))
    print(shell([5,4,3,2,1]))
