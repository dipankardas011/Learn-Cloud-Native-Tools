#!/usr/bin/python3
mygrades=[100,93,88,95,85,99,100,78]
print(mygrades)
mygrades.append(100)
print(mygrades)
average = sum(mygrades) / len(mygrades)
print("the average score is %.2f" % (average))
