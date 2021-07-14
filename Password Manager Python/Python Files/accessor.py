import json
import whirlpool
from cryptography.fernet import Fernet

with open ("memory.json", "r") as file:
    memory = json.load(file)

with open ("keyHash.json", "r") as file:
    keyHashDict = json.load(file)

print('What password do you want to access(website name)?')
website = input()

for key in memory:
    if website == key:
        print('Which key do you have:')
        keyNumber = input()
        print('Enter your key:')
        inputKey = input()
        inputKey = inputKey.encode('utf-8')

        keyWP = whirlpool.new(inputKey)
        hashedKey = keyWP.hexdigest()

        if (keyHashDict.get('key{}'.format(keyNumber))==hashedKey):
            cryptolizer = Fernet(inputKey)

            valueClean = memory.get(key)
            valueClean = str(valueClean).split("'", 1)
            valueClean = valueClean[1]
            valueClean = valueClean[:-1]
            valueBytes = bytes(valueClean, 'utf-8')
            
            password = cryptolizer.decrypt(valueBytes)
            passwordClean = str(password).split("'", 1)
            passwordClean = passwordClean[1]
            passwordClean = passwordClean[:-1]

            print (passwordClean)