from dotenv import load_dotenv
load_dotenv()

import base64
import os
import io
from PIL import Image 
import pdf2image
import google.generativeai as genai
from flask import Flask, request, jsonify

# Configure Gemini AI
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# Instantiate Flask app for the AI model
ai_app = Flask(__name__)

def get_gemini_response(input_text, pdf_content, prompt):
    model = genai.GenerativeModel('gemini-1.5-flash')
    response = model.generate_content([input_text, pdf_content[0], prompt])
    return {"result": response.text}

def input_pdf_setup(uploaded_file):
    if uploaded_file is not None:
        # Convert the PDF to image
        images = pdf2image.convert_from_bytes(uploaded_file.read())

        first_page = images[0]

        # Convert to bytes
        img_byte_arr = io.BytesIO()
        first_page.save(img_byte_arr, format='JPEG')
        img_byte_arr = img_byte_arr.getvalue()

        pdf_parts = [
            {
                "mime_type": "image/jpeg",
                "data": base64.b64encode(img_byte_arr).decode()  # encode to base64
            }
        ]
        return pdf_parts
    else:
        raise FileNotFoundError("No file uploaded")

# Define the prompt for the AI model
input_prompt3 = """
You are a skilled ATS (Applicant Tracking System) scanner with a deep understanding of data science and ATS functionality. 
Your task is to evaluate the resume against the provided job description. Provide the percentage match if the resume aligns with
the job description. First, present the output as a percentage, then highlight keywords that are missing, and conclude with
your final thoughts.
"""

@ai_app.route('/process', methods=['POST'])
def process():
    # Get the job description and CV file from the request
    input_text = request.form.get('input_text')  # Ensure this matches the key used in `server.py`
    cv_file = request.files.get('file')

    if not input_text or not cv_file:
        return jsonify({"error": "Please provide both Job Description and CV!"}), 400

    try:
        # Process the CV file
        pdf_content = input_pdf_setup(cv_file)

        # Get the response from the AI model
        response = get_gemini_response(input_text, pdf_content, input_prompt3)
        return jsonify(response), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    ai_app.run(host='localhost', port=8501, debug=True)