#Import all data and store it in a list

data = []

for i in range(10):

    file_name = "data{}.txt".format(i+1)

    with open(file_name) as f:
        lineList = f.readlines()

    lineList = [line.rstrip('\n') for line in open(file_name)]

    temp = []

    for str in lineList:
        temp.append(int(str))
    
    data.append(temp)

#Calculate the average

average = []
total = 0

for i in range(255):
    for j in range(10):
        total += data[j][i]
    average.append(total/10)
    total = 0

print(average)