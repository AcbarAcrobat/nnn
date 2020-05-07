from flask import Flask
from jinja2 import Environment, FileSystemLoader

app = Flask(__name__)


@app.route("/")
def main():
    env = Environment(comment_start_string='{##', loader=FileSystemLoader('reports/'))
    template = env.get_template('test.html')
    return template.render()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5050', debug=True)
