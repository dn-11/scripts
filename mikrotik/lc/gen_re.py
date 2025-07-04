cross_type = input('cross type(normally 11000-11003): ')
strn = input('code: ')
res = []
for i in range(len(strn)):
    res.append(''.join([ '[0-9]' if i!=x else f'[^{strn[x]}]' 
                        for x in range(len(strn))]))
    
for i in range(len(strn)-1):
    res.append("[0-9]"*(i+1))

res.append("[0-9]"*(len(strn)+1) + "+")

# check
import re
p = re.compile("^{}$".format("|".join(res)))
for i in range(10**(len(strn)+1)):
    if not p.fullmatch(str(i)):
        if str(i) != strn:
            raise Exception(f'check error on {i}')
    else:
        if str(i) == strn:
            raise Exception(f'check error on {i}')

print("^(422008|421111)[0-9]+:{}:({})$".format(cross_type,"|".join(res)))
