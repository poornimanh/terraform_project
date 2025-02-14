from flask import Flask
import werkzeug
from markupsafe import escape
from markupsafe import soft_str as soft_unicode
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
