# Stage 1: Build stage
FROM python:3.10-slim AS build

WORKDIR /app

# Copy only requirements first for better caching of dependencies
COPY requirements.txt .

# Install dependencies in the build stage
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Stage 2: Final stage
FROM python:3.10-slim AS final

WORKDIR /app

# Copy installed dependencies from the build stage
COPY --from=build /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

# Copy only the necessary application files
COPY --from=build /app /app

# Set command to run the app
CMD ["python", "app.py"]

