import os

name = os.getenv("USER_NAME", "Anonymous")
print(f"Hello, {name} from inside Docker!")
