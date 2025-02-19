from flask import Flask, render_template, Response, request, session, render_template, redirect, url_for

#Server IP and PORT
Server = '192.168.1.6'
Port = 5000

#instatiate flask app  
app = Flask(__name__, template_folder='./templates')
app.secret_key = '1a2b5c4d7e'
app.config['SESSION_TYPE'] = 'filesystem'

# ******************
@app.route('/')
def index():
    return render_template('index.html', title="Login")
   
# ********************************
# end Flutter backend code
# ********************************
if __name__ == '__main__':
    app.run(host=Server, port=Port, debug=True)
    

