# Reference
# https://platform.openai.com/docs/api-reference/introduction

# Let's ask the AI
# Python script to read "survey_feedback_generated.txt" and summarize the feedback using a call to the OpenAI API
import openai
import os
import json
from dotenv import load_dotenv
# Load environment variables from .env file
load_dotenv()
# Set OpenAI API key
openai.api_key = os.getenv("OPENAI_API_KEY")
# Read the survey feedback from the file
with open("in_class_examples/survey_feedback_generated.txt", "r") as file:
    survey_feedback = file.read()

# Define the prompt for summarization
prompt = f"""
Please summarize the following survey feedback, from an experiment where 15 year olds answered about how they view their future work life.
Please reply with the 10 most important points. Answer in bullet points, maximum 3 sentences per bullet point.
"""

from openai import OpenAI
client = OpenAI()

response = client.responses.create(
    model="gpt-4o-mini",
    input = survey_feedback,
    instructions = prompt,
    max_output_tokens=50000,
    temperature=0.4
)

print(response.output[0].content[0].text)