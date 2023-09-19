
n_displays = 300

file1 = open('chasing_frames.txt', 'r')
count = 0

filename = "chasing_output/wolfX.js"
wolfX = open(filename, "a")
wolfX.write("var wolfX = {")

filename = "chasing_output/wolfY.js"
wolfY = open(filename, "a")
wolfY.write("var wolfY = {")

filename = "chasing_output/sheepX.js"
sheepX = open(filename, "a")
sheepX.write("var sheepX = {")

filename = "chasing_output/sheepY.js"
sheepY = open(filename, "a")
sheepY.write("var sheepY = {")

filename = "chasing_output/dist1X.js"
dist1X = open(filename, "a")
dist1X.write("var dist1X = {")

filename = "chasing_output/dist1Y.js"
dist1Y = open(filename, "a")
dist1Y.write("var dist1Y = {")

filename = "chasing_output/dist2X.js"
dist2X = open(filename, "a")
dist2X.write("var dist2X = {")

filename = "chasing_output/dist2Y.js"
dist2Y = open(filename, "a")
dist2Y.write("var dist2Y = {")

filename = "chasing_output/dist3X.js"
dist3X = open(filename, "a")
dist3X.write("var dist3X = {")

filename = "chasing_output/dist3Y.js"
dist3Y = open(filename, "a")
dist3Y.write("var dist3Y = {")

filename = "chasing_output/dist4X.js"
dist4X = open(filename, "a")
dist4X.write("var dist4X = {")

filename = "chasing_output/dist4Y.js"
dist4Y = open(filename, "a")
dist4Y.write("var dist4Y = {")

filename = "chasing_output/dist5X.js"
dist5X = open(filename, "a")
dist5X.write("var dist5X = {")

filename = "chasing_output/dist5Y.js"
dist5Y = open(filename, "a")
dist5Y.write("var dist5Y = {")

filename = "chasing_output/dist6X.js"
dist6X = open(filename, "a")
dist6X.write("var dist6X = {")

filename = "chasing_output/dist6Y.js"
dist6Y = open(filename, "a")
dist6Y.write("var dist6Y = {")

# file1 = open('mirror_chasing_frames.txt', 'r')
# count = 0

# filename = "mirror_chasing_output/wolfX.js"
# wolfX = open(filename, "a")
# wolfX.write("var mwolfX = {")

# filename = "mirror_chasing_output/wolfY.js"
# wolfY = open(filename, "a")
# wolfY.write("var mwolfY = {")

# filename = "mirror_chasing_output/sheepX.js"
# sheepX = open(filename, "a")
# sheepX.write("var msheepX = {")

# filename = "mirror_chasing_output/sheepY.js"
# sheepY = open(filename, "a")
# sheepY.write("var msheepY = {")

# filename = "mirror_chasing_output/dist1X.js"
# dist1X = open(filename, "a")
# dist1X.write("var mdist1X = {")

# filename = "mirror_chasing_output/dist1Y.js"
# dist1Y = open(filename, "a")
# dist1Y.write("var mdist1Y = {")

# filename = "mirror_chasing_output/dist2X.js"
# dist2X = open(filename, "a")
# dist2X.write("var mdist2X = {")

# filename = "mirror_chasing_output/dist2Y.js"
# dist2Y = open(filename, "a")
# dist2Y.write("var mdist2Y = {")

# filename = "mirror_chasing_output/dist3X.js"
# dist3X = open(filename, "a")
# dist3X.write("var mdist3X = {")

# filename = "mirror_chasing_output/dist3Y.js"
# dist3Y = open(filename, "a")
# dist3Y.write("var mdist3Y = {")

# filename = "mirror_chasing_output/dist4X.js"
# dist4X = open(filename, "a")
# dist4X.write("var mdist4X = {")

# filename = "mirror_chasing_output/dist4Y.js"
# dist4Y = open(filename, "a")
# dist4Y.write("var mdist4Y = {")

# filename = "mirror_chasing_output/dist5X.js"
# dist5X = open(filename, "a")
# dist5X.write("var mdist5X = {")

# filename = "mirror_chasing_output/dist5Y.js"
# dist5Y = open(filename, "a")
# dist5Y.write("var mdist5Y = {")

# filename = "mirror_chasing_output/dist6X.js"
# dist6X = open(filename, "a")
# dist6X.write("var mdist6X = {")

# filename = "mirror_chasing_output/dist6Y.js"
# dist6Y = open(filename, "a")
# dist6Y.write("var mdist6Y = {")

for line in file1:
    line = line.strip()
    words = line.split(' ')

    if int(words[1])==1:
        wolfX.write("%s: [%s, " % (words[0], words[2]))
        wolfY.write("%s: [%s, " % (words[0], words[3]))
        sheepX.write("%s: [%s, " % (words[0], words[4]))
        sheepY.write("%s: [%s, " % (words[0], words[5]))
        dist1X.write("%s: [%s, " % (words[0], words[6]))
        dist1Y.write("%s: [%s, " % (words[0], words[7]))
        dist2X.write("%s: [%s, " % (words[0], words[8]))
        dist2Y.write("%s: [%s, " % (words[0], words[9]))
        dist3X.write("%s: [%s, " % (words[0], words[10]))
        dist3Y.write("%s: [%s, " % (words[0], words[11]))
        dist4X.write("%s: [%s, " % (words[0], words[12]))
        dist4Y.write("%s: [%s, " % (words[0], words[13]))
        dist5X.write("%s: [%s, " % (words[0], words[14]))
        dist5Y.write("%s: [%s, " % (words[0], words[15]))
        dist6X.write("%s: [%s, " % (words[0], words[16]))
        dist6Y.write("%s: [%s, " % (words[0], words[17]))
    elif int(words[1]) < 120:
        wolfX.write("%s, " % (words[2]))
        wolfY.write("%s, " % (words[3]))
        sheepX.write("%s, " % (words[4]))
        sheepY.write("%s, " % (words[5]))
        dist1X.write("%s, " % (words[6]))
        dist1Y.write("%s, " % (words[7]))
        dist2X.write("%s, " % (words[8]))
        dist2Y.write("%s, " % (words[9]))
        dist3X.write("%s, " % (words[10]))
        dist3Y.write("%s, " % (words[11]))
        dist4X.write("%s, " % (words[12]))
        dist4Y.write("%s, " % (words[13]))
        dist5X.write("%s, " % (words[14]))
        dist5Y.write("%s, " % (words[15]))
        dist6X.write("%s, " % (words[16]))
        dist6Y.write("%s, " % (words[17]))
    elif int(words[1]) == 120:
        wolfX.write("%s], " % (words[2]))
        wolfY.write("%s], " % (words[3]))
        sheepX.write("%s], " % (words[4]))
        sheepY.write("%s], " % (words[5]))
        dist1X.write("%s], " % (words[6]))
        dist1Y.write("%s], " % (words[7]))
        dist2X.write("%s], " % (words[8]))
        dist2Y.write("%s], " % (words[9]))
        dist3X.write("%s], " % (words[10]))
        dist3Y.write("%s], " % (words[11]))
        dist4X.write("%s], " % (words[12]))
        dist4Y.write("%s], " % (words[13]))
        dist5X.write("%s], " % (words[14]))
        dist5Y.write("%s], " % (words[15]))
        dist6X.write("%s], " % (words[16]))
        dist6Y.write("%s], " % (words[17]))
    count += 1
    if count==120*n_displays:
        break


wolfX.write("};")
wolfX.close()
wolfY.write("};")
wolfY.close()
sheepX.write("};")
sheepX.close()
sheepY.write("};")
sheepY.close()
dist1X.write("};")
dist1X.close()
dist1Y.write("};")
dist1Y.close()
dist2X.write("};")
dist2X.close()
dist2Y.write("};")
dist2Y.close()
dist3X.write("};")
dist3X.close()
dist3Y.write("};")
dist3Y.close()
dist4X.write("};")
dist4X.close()
dist4Y.write("};")
dist4Y.close()
dist5X.write("};")
dist5X.close()
dist5Y.write("};")
dist5Y.close()
dist6X.write("};")
dist6X.close()
dist6Y.write("};")
dist6Y.close()
