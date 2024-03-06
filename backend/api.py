from flask import Flask, request, jsonify
from linkedin_api import Linkedin

app = Flask(__name__)
api = Linkedin("dpadia106@gmail.com", "Apdi*5678")

class MyLinkedIn:
    def __init__(self, email, password):
        self.api = Linkedin(email, password)

    def get_profile_details(self, profile_id):
        return self.api.get_profile(profile_id)

    def profile_details(self, profile_details):
        first_name = profile_details.get('firstName', '')
        last_name = profile_details.get('lastName', '')
        company_name = profile_details.get('experience', [{}])[0].get('companyName', '') if profile_details.get('experience') else ''
        skills = profile_details.get('skills', [])
        headline = profile_details.get('headline', '')
        summary = profile_details.get('summary', '')
        display_url = ""
        display_url+=profile_details.get('displayPictureUrl')
        display_url+=profile_details.get('img_200_200')
        profile_photo_url = display_url

        # print(profile_details)
        return {
            'first_name': first_name,
            'last_name': last_name,
            'company_name': company_name,
            'skills': skills,
            'headline': headline,
            'summary': summary,
            'profile_photo_url' :profile_photo_url 
        }

@app.route('/get_profile', methods=['POST'])
def get_profile():
    linkedin_username = request.json.get('linkedin_username')
    if not linkedin_username:
        return jsonify({'error': 'LinkedIn username is required'})

    my_linkedin = MyLinkedIn("dpadia106@gmail.com", "Padia007*")
    profile_details = my_linkedin.get_profile_details(linkedin_username)
    if not profile_details:
        return jsonify({'error': 'Failed to retrieve profile details'})

    data = my_linkedin.profile_details(profile_details)
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
