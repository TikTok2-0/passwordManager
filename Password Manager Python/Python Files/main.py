import json
import whirlpool
from cryptography.fernet import Fernet

passDict = {}

def newPassword():
    print('Enter website name: ')
    website = input()
    print('Enter Password: ')
    password = input()

    encPass = cryptolizer.encrypt(bytes(password, 'utf-8'))

    output = {website:str(encPass)}
    with open ("memory.json", "r") as file:
        data = json.load(file)
        data.update(output)

    with open ("memory.json", "w") as file:
        json.dump(data, file)

def editPassword():
    while True:
        print('Website name?')
        website = input()
        with open ("memory.json", "r") as file:
            memory = json.load(file)

        for key in memory:
            if key == website:
                print('Enter new password for {}'.format(website))
                newPass = input()

                encPass = cryptolizer.encrypt(bytes(newPass, 'utf-8'))

                with open ("memory.json", "r") as file:
                    data = json.load(file)
                    data[website] = encPass

                with open ("memory.json", "w") as file:
                    json.dump(data, file)
                break
        else:
            print('not a website in memory')

def deletePassword():
    print('Website name?')
    website = input()
    while True:
        with open ("memory.json", "r") as file:
            memory = json.load(file)
        if website in memory:
            with open ("memory.json", "r") as file:
                    data = json.load(file)
                    data.pop(website)

            with open ("memory.json", "w") as file:
                json.dump(data, file)

            print('Password has been deleted')
            break
        else:
            print('not a website in memory')

with open ("keyHash.json", "r") as file:
    keyHashDict = json.load(file)

while True:
    print('Which key do you have (or end [type "end"]):')
    keyNumber = input()
    if keyNumber == "end":
        break
    print('Enter your key:')
    inputKey = input()
    inputKey = inputKey.encode('utf-8')

    keyWP = whirlpool.new(inputKey)
    hashedKey = keyWP.hexdigest()

    if (keyHashDict.get('key{}'.format(keyNumber))==hashedKey):
        while True:
            cryptolizer = Fernet(inputKey)
            print('What do you want to do?:\nAdd a new password[1]\nEdit an existing password[2]\nDelete a password[3]\nEnd[4]')
            option = input()
            if option == "1":
                newPassword()
            elif option == "2":
                editPassword()
            elif option == "3":
                deletePassword()
            elif option == "4":
                break
            else:
                print('not an option')
    else:
        print("not an option\nthwarting breakthrough\nbye")
        break