from flask import Flask
from random import randint

app = Flask(__name__)

@app.route("/rolldice")
def roll_dice():
    return str(do_roll())

def do_roll():
    res = randint(1, 6)
    return res

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8082, debug=True, use_reloader=False)