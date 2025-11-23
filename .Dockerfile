# Stage 1: Build Stage - Use a slightly smaller Python base image for faster downloads
FROM python:3.11-slim

# Set environment variables
# PYTHONUNBUFFERED ensures that Python output is sent straight to the terminal/logs
ENV PYTHONUNBUFFERED 1
# Set the port Streamlit will listen on (8501 is the standard default)
ENV PORT 8501

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
# This step is cached, so if requirements.txt doesn't change,
# the dependencies won't be reinstalled unnecessarily.
COPY requirements.txt .

# Install dependencies
# Using --no-cache-dir reduces the size of the final image.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files, including app.py and the Dockerfile itself
COPY . .

# The necessary port for Streamlit must be exposed
EXPOSE 8501

# The command to run when the container starts. 
# --server.address=0.0.0.0 is MANDATORY for AWS/Docker to allow external access.
# We also use the local model path to ensure the model is saved to the working directory.
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
