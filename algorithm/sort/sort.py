#!/usr/bin/env python3
import copy
import numpy
import time

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

def quick(arr, left=None, right=None):
    if left == None:
        left = 0
    if right == None:
        right = len(arr) - 1
    if left < right:
        partitionIndex = partition(arr, left, right)
        quick(arr, left, partitionIndex-1)
        quick(arr, partitionIndex+1, right)
    return arr

def partition(arr, left, right):
    pivot = left
    index = pivot

    # 进行一趟冒泡， 比 pivot 小时 左移冒泡，分区index + 1
    for i in range(pivot+1, right+1):
        if arr[i] < arr[pivot]:
            index += 1
            arr[i],arr[index] = arr[index],arr[i]
    arr[index],arr[pivot] = arr[pivot],arr[index]
    return index

def timeCost(fun, arr):
    start = time.time()
    fun(arr)
    end = time.time()
    print(end-start,fun.__name__)

if __name__ == '__main__':
    arr = [3,5,4,1,2]
    print(len(arr))
    print(bubble(copy.deepcopy(arr)))
    print(insertion(copy.deepcopy(arr)))
    print(selection(copy.deepcopy(arr)))
    print(shell(copy.deepcopy(arr)))
    count = 0
    print(mergeSort(copy.deepcopy(arr)),count,"mergeSort")
    print(quick(copy.deepcopy(arr)), "quick")

    # quick mergeSort 对比
    big = list(numpy.random.randint(50000,size=50000))
    timeCost(quick, copy.deepcopy(big))
    timeCost(mergeSort, copy.deepcopy(big))
    timeCost(shell, copy.deepcopy(big))