# Use an official lightweight Python slim image
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /code

# Install system dependencies (required for some NLP/Spacy packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY ./app /app

# Expose the port Hugging Face expects (default is 7860)
EXPOSE 7860

# Run the FastAPI app using Uvicorn
# NOTE: --workers 1 is critical for memory-heavy ML apps to prevent RAM duplication
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7860", "--workers", "1"]