# Use official Python image
FROM python:3.11-alpine

# Set working directory to the ui folder
WORKDIR /app/ui

# Copy all project files
COPY . /app/

# Expose port 8000
EXPOSE 8000

# Serve the ui folder using Python's built-in HTTP server
CMD ["python", "-m", "http.server", "8000"]
