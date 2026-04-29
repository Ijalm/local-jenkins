# Use official Python image
FROM python:3.11-alpine

# Set working directory
WORKDIR /app

# Copy app files
COPY . .

# Expose port 8000
EXPOSE 8000

# Serve using Python's built-in HTTP server
CMD ["python", "-m", "http.server", "8000"]
