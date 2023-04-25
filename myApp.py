from datetime import time
import firebase_admin
from firebase_admin import credentials, firestore
from flask import Flask, jsonify, request
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
    'projectId': 'your-project-id'
})

app = Flask(__name__)

# Create a new profile
@app.route('/profiles', methods=['POST'])
def create_profile():
    data = request.get_json()
    profile = {
        'student_id': data['student_id'],
        'name': data['name'],
        'email': data['email'],
        'date_of_birth': data['date_of_birth'],
        'year_group': data['year_group'],
        'major': data['major'],
        'has_campus_residence': data['has_campus_residence'],
        'best_food': data['best_food'],
        'best_movie': data['best_movie']
    }
    db = firestore.client()
    doc_ref = db.collection('profiles').document(data['student_id'])
    doc_ref.set(profile)
    return jsonify({'message': 'Profile created successfully!'})

#Update an existing profile:

@app.route('/profiles/<student_id>', methods=['PUT'])
def update_profile(student_id):
    data = request.get_json()
    db = firestore.client()
    doc_ref = db.collection('profiles').document(student_id)
    doc_ref.update(data)
    return jsonify({'message': 'Profile updated successfully!'})



# Get a profile by student ID:

@app.route('/profiles/<student_id>', methods=['GET'])
def get_profile(student_id):
    db = firestore.client()
    doc_ref = db.collection('profiles').document(student_id)
    doc = doc_ref.get()
    if doc.exists:
        return jsonify(doc.to_dict())
    else:
        return jsonify({'error': 'Profile not found!'})

# Create a new post:

@app.route('/posts', methods=['POST'])
def create_post():
    data = request.get_json()
    post = {
        'email': data['email'],
        'text': data['text'],
        'created_at': firestore.SERVER_TIMESTAMP
    }
    db = firestore.client()
    doc_ref = db.collection('posts').document()
    doc_ref.set(post)
    
    # Send email notification to all users
    sender_email = 'your-email@example.com'
    sender_password = 'your-email-password'
    recipients = []
    profiles_ref = db.collection('profiles')
    for doc in profiles_ref.stream():
        profile = doc.to_dict()
        recipients.append(profile['email'])
    
    subject = 'New Post Notification'
    message = f"A new post has been created by {data['email']}."
    
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = ", ".join(recipients)
    msg['Subject'] = subject
    msg.attach(MIMEText(message, 'plain'))
    
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(sender_email, sender_password)
        smtp.sendmail(sender_email, recipients, msg.as_string())
        
    return jsonify({'message': 'Post created successfully!'})

#Feed Page/Section

@app.route('/posts', methods=['GET'])
def get_posts():
    db = firestore.client()
    posts_ref = db.collection('posts').order_by('created_at', direction=firestore.Query.DESCENDING)
    posts = []
    for doc in posts_ref.stream():
        post = doc.to_dict()
        post['id'] = doc.id
        posts.append(post)
    return jsonify(posts)

if __name__ == '__main__':
    app.run()

    # Set up Firestore listener to trigger email notification
    db = firestore.client()
    posts_ref = db.collection('posts')
    last_post_time = None
    
    while True:
        # Check for new posts since last check
        query = posts_ref.order_by('created_at', direction=firestore.Query.DESCENDING)
        if last_post_time is not None:
            query = query.where('created_at', '>', last_post_time)
        
        new_posts = [doc.to_dict() for doc in query.stream()]
        
        if new_posts:
            # Get list of all users' emails
            profiles_ref = db.collection('profiles')
            emails = [doc.to_dict()['email'] for doc in profiles_ref.stream()]
            
            # Send email notification to all users
            for email in emails:
                sender_email = 'your-email@gmail.com'
                sender_password = 'your-email-password'
                
                message = f'Subject: New Post\n\nA new post has been made on the platform.'
                recipients = [email]
            sender_email(sender_email, sender_password, recipients, message)
        
        # Update last post time
        if new_posts:
            last_post_time = new_posts[0]['created_at']
        
        # Wait for some time before checking for new posts again
        time.sleep(60)
