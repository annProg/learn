#!/usr/bin/env python3

def binSearch(arr, target, left, right):
    if left > right:
        return False
    mid = int((right - left)/2)
    if arr[mid] == target:
        return mid
    elif arr[mid] > target:
        binSearch(arr, target, left, mid - 1)
    else:
        binSearch(arr, target, mid + 1, right)


if __name__ == "__main__":
    arr = [1,3,4,6,7,9,15]
    target = 6
    print(binSearch(arr, target, 0, len(arr)-1))