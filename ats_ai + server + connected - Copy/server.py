from flask import Flask, render_template, request, jsonify
import os
import json
import requests
import re

# Server IP and PORT
Server = '192.168.1.4'
Port = 5000

# Instantiate Flask app  
app = Flask(__name__, template_folder='./templates')
app.secret_key = '1a2b5c4d7e'
app.config['UPLOAD_FOLDER'] = 'uploads'  # Main uploads folder

# Ensure the main uploads folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def get_next_submission_folder():
    """Generate the next submission folder name based on count."""
    existing_folders = [d for d in os.listdir(app.config['UPLOAD_FOLDER']) if d.startswith("submission_")]
    next_number = len(existing_folders) + 1  # Count existing folders and add 1
    return os.path.join(app.config['UPLOAD_FOLDER'], f"submission_{next_number}")

@app.route('/')
def index():
    return render_template('index.html', title="Job Application")

@app.route('/submit', methods=['POST'])
def submit():
    job_description = request.form.get('job_description')
    cv_file = request.files.get('cv_file')

    if not job_description or not cv_file:
        return "Error: Please provide both Job Description and CV!"

    # Create a sequential folder for this submission
    submission_folder = get_next_submission_folder()
    os.makedirs(submission_folder, exist_ok=True)  # Create the folder

    # Save the CV file in the user's folder
    cv_filename = cv_file.filename
    cv_path = os.path.join(submission_folder, cv_filename)
    cv_file.save(cv_path)

    # Save the job description as a .txt file
    job_desc_path = os.path.join(submission_folder, "job_description.txt")
    with open(job_desc_path, 'w', encoding='utf-8') as file:
        file.write(job_description)

    # Save data as JSON
    json_data = {
        "job_description": job_description,
        "cv_filename": cv_filename
    }
    json_path = os.path.join(submission_folder, "data.json")
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json.dump(json_data, json_file, indent=4)

    print(f"Data saved in JSON: {json_path}")

    # Send the job description and CV to the AI model
    ai_response = send_to_ai_model(job_description, cv_path)
    print("AI Model Response:", ai_response)

    # Process AI response (Format text and apply bold)
    processed_response = process_ai_response(ai_response)

    # Save the AI response in a JSON file named "result.json"
    result_json_path = os.path.join(submission_folder, "result.json")
    with open(result_json_path, 'w', encoding='utf-8') as result_file:
        json.dump({"ai_response": processed_response}, result_file, indent=4)

    print(f"AI response saved in JSON: {result_json_path}")

    return jsonify({
        "message": "Application submitted successfully!",
        "folder": submission_folder,
        "ai_response": processed_response
    })

def send_to_ai_model(job_description, cv_path):
    """
    Send the job description and CV to the AI model and get the response.
    """
    ai_model_url = "http://localhost:8501/process"

    # Prepare the payload
    with open(cv_path, 'rb') as cv_file:
        files = {'file': cv_file}
        data = {'input_text': job_description}

        # Send a POST request to the AI model
        response = requests.post(ai_model_url, files=files, data=data)

    if response.status_code == 200:
        return response.json()
    else:
        return {"error": "Failed to get response from AI model"}

def process_ai_response(ai_response):
    """
    Process AI response by:
    1. Removing the 'result' key if present.
    2. Formatting response into multiple lines.
    3. Converting **bold text** into __bold__ for Flutter.
    """
    if isinstance(ai_response, dict) and "result" in ai_response:
        response_text = ai_response["result"]
    else:
        response_text = ai_response

    if isinstance(response_text, str):
        # Add line breaks for readability
        formatted_text = response_text.replace(". ", ".\n")

        # Convert **bold text** to __bold__ (for Flutter)
        formatted_text = re.sub(r'\*\*(.*?)\*\*', r'__\1__', formatted_text)

        return formatted_text  # Return as a single string
    
    return str(response_text)  # Convert non-string responses to string

if __name__ == '__main__':
    app.run(host=Server, port=Port, debug=True)
