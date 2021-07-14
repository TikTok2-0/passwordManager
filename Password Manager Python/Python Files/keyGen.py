from cryptography.fernet import Fernet
import whirlpool
import json

key = Fernet.generate_key()
print(key)

keyWP = whirlpool.new(key)
hashedKey = keyWP.hexdigest()

iIn = open('i.txt', 'r')
i = int(iIn.read())
i += 1

output = {"key{}".format(i): hashedKey}
with open ("keyHash.json", "r") as file:
    data = json.load(file)
    data.update(output)

with open ("keyHash.json", "w") as file:
    json.dump(data, file)

counter = open('i.txt', 'w')
counter.write("{}".format(i))
counter.close()

