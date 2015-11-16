
#projiti vsech podnodu:

ch = getChildnodes("/systems/pokus");

print (ch);

if (ch!=nil) {
    for (i=0; ch[i]!=nil; i=i+1) {
        print (ch[i]);
    }
} else {
    print ("nic nebylo nalezeno");
}
