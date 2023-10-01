# ProductCategory.delete_all
coins = ProductCategory.find_or_create_by name: "coins"
# ebikes = ProductCategory.create! name: "e-bikes"
# ProductCategory.create! name: "kids bikes & accessories"
# ProductCategory.create! name: "parts"
# ProductCategory.create! name: "bikes accessories"
# ProductCategory.create! name: "clothing & shoes"

# Product.delete_all
Product.create! name: "10 coins", price: 1, coin_value: 10, active: true, product_category: coins
Product.create! name: "100 coins", price: 10, coin_value: 100, active: true, product_category: coins
Product.create! name: "200 coins", price: 15, coin_value: 200, active: true, product_category: coins
Product.create! name: "500 coins", price: 20, coin_value: 500, active: true, product_category: coins

# Prompt.delete_all
Prompt.create! subject: "Initial System Setup", body: "You are a helpful assistant that is great at helping job applicants land their dream jobs! You will use their resume information to reference past work experiences, skills, education, and other information about the applicant. Do not make up facts about the applicant. Ask for clarification if unsure how to proceed.  Your responses are formatted as rich text format.", active: false
Prompt.create! subject: "Initial User Setup", body: "Please help me get the job listed in the following job posting:</br>JOB_POSTING</br>Please use my current resume & other information given to help me get this job. Here is my current resume:<br> USER_RESUME<br>Please format all of your responses as rich text format.", active: false
Prompt.create! subject: "Job Posting", body: "JOB_POSTING", active: false
Prompt.create! subject: "Resume", body: "USER_RESUME", active: false

Prompt.create! subject: "Interview Tips", body: "Give me 3 interview tips for applying to this job. DETAILED_RESPONSE", active: true
Prompt.create! subject: "Resume Intro", body: "Please write an awesome resume introduction that will help land an interview for this job. Use my current resume & job posting for details.", active: true
Prompt.create! subject: "Elevator Speech", body: "Write a elevator speech, as me, like I was talking directly to the hiring manager of this job. Keep it short, whitty & light - yet professional & direct. Highlight past experience from my resume where it is applicable to this job.", active: true
Prompt.create! subject: "Detailed Response", body: "Provide as much detail as possible. I understand you are an AI language model with limitations, so any company information you have available will work.", active: false
Prompt.create! subject: "Resume Rewrite", body: "Please rewrite the following resume, highlighting things that align with what this job posting is looking for."
Prompt.create! subject: "Sample Interview Questions", body: "Give me 3 interview questions that you think would be asked for this job and use my resume to answer those questions for me, as me."
Prompt.create! subject: "Company Info", body: "Tell me 3 things that would be helpful for someone applying to COMPANY_NAME as a JOB_TITLE to know about the company. Include things like mission statement, culture, industry, short summary of what they do, office locations (if applicable) & any other useful information. DETAILED_RESPONSE", active: true
